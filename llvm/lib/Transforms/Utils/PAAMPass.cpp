#include "llvm/Transforms/Utils/PAAMPass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Format.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Value.h"
#include "llvm/Analysis/LoopInfo.h"

using namespace llvm;

#define AI_THRESHOLD 0.04
#define MAGICAL_NUMBER 1000

// Global statistics
double insts = 0.0;
double arithmetic_insts = 0.0;
double memory_ops = 0.0;
double memory_loads = 0.0;
double memory_stores = 0.0;
double ai = 0.0;

bool isArithmetic(unsigned opcode) {
  return opcode == Instruction::Add  ||
         opcode == Instruction::FAdd ||
         opcode == Instruction::Sub  ||
         opcode == Instruction::FSub ||
         opcode == Instruction::Mul  ||
         opcode == Instruction::FMul ||
         opcode == Instruction::UDiv ||
         opcode == Instruction::SDiv ||
         opcode == Instruction::FDiv ||
         opcode == Instruction::URem ||
         opcode == Instruction::SRem ||
         opcode == Instruction::FRem ||
         opcode == Instruction::Shl  ||
         opcode == Instruction::LShr ||
         opcode == Instruction::AShr;
}

void updateGlobalStats(double local_insts,
                       double local_arithmetic_insts,
                       double local_memory_ops,
                       double local_memory_loads,
                       double local_memory_stores) {
  insts += local_insts;
  arithmetic_insts += local_arithmetic_insts;
  memory_ops += local_memory_ops;
  memory_loads += local_memory_loads;
  memory_stores += local_memory_stores;
  ai = (arithmetic_insts / insts);
}

bool instrIsInLoop(Loop *loop, Instruction *instr) {
  if (loop->contains(instr))
    return true;

  for (auto *subLoop : loop->getSubLoops()) {
    if (instrIsInLoop(subLoop, instr))
      return true;
  }

  return false;
}

bool instrIsInaLoop(LoopInfo &LI, Instruction *instr) {
  for (Loop *loop : LI) {
    if (instrIsInLoop(loop, instr))
      return true;
  }
  return false;
}

// Calculate Arithmetic Intensity for a function
double calculateAI(Function &F, LoopInfo &LI) {
  double local_insts = 0.0;
  double local_arithmetic_insts = 0.0;
  double local_memory_ops = 0.0;
  double local_memory_loads = 0.0;
  double local_memory_stores = 0.0;

  for (auto &BB : F) {
    for (auto &I : BB) {
      int inst_count = 1;
      if (instrIsInaLoop(LI, &I)) {
        inst_count = MAGICAL_NUMBER;
      }

      local_insts+= inst_count;
      unsigned opcode = I.getOpcode();
      if (isArithmetic(opcode)) {
        local_arithmetic_insts+= inst_count;
      } else if (opcode == Instruction::Load || opcode == Instruction::Store) {
        local_memory_ops+= inst_count;
        if (opcode == Instruction::Load)
          local_memory_loads+= inst_count;
        else if (opcode == Instruction::Store)
          local_memory_stores+= inst_count;
      }
    }
  }

  double local_ai = (local_arithmetic_insts / local_insts);

  // Print function-level stats
  errs() << "Function stats (INST, ARITHMETIC, AI, MEM_OPS, LD, ST): ";
  errs() << format("%.0f, ", local_insts);
  errs() << format("%.0f, ", local_arithmetic_insts);
  errs() << format("%.5f, ", local_ai);
  errs() << format("%.0f, ", local_memory_ops);
  errs() << format("%.0f, ", local_memory_loads);
  errs() << format("%.0f", local_memory_stores) << "\n";

  updateGlobalStats(local_insts, local_arithmetic_insts, local_memory_ops,
                    local_memory_loads, local_memory_stores);

  // Print global stats
  errs() << "Global stats (INST, ARITHMETIC, AI, MEM_OPS, LD, ST): ";
  errs() << format("%.0f, ", insts);
  errs() << format("%.0f, ", arithmetic_insts);
  errs() << format("%.5f, ", ai);
  errs() << format("%.0f, ", memory_ops);
  errs() << format("%.0f, ", memory_loads);
  errs() << format("%.0f", memory_stores) << "\n";

  return local_ai;
}

PreservedAnalyses PAAMPass::run(Function &F,
                                      FunctionAnalysisManager &AM) {
  errs() << "Analyzing: " << F.getName() << "\n";

  // Get loop info
  LoopInfo &LI = AM.getResult<LoopAnalysis>(F);
  // Calculate AI
  double function_ai = calculateAI(F, LI);

  // Decision output
  if (function_ai > AI_THRESHOLD) {
    errs() << "-- Function " << F.getName()
           << " presents high arithmetic intensity ("
           << format("%.5f", function_ai)
           << ") and should be run on GPU --\n";
  } else {
    errs() << "-- Function " << F.getName()
           << " presents low arithmetic intensity ("
           << format("%.5f", function_ai)
           << "); maybe it could be run on CPU --\n";
  }

  errs() << "\n";
  return PreservedAnalyses::all();
}