#include "llvm/Transforms/Utils/SampleCudaPass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Format.h"

using namespace llvm;

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
         opcode == Instruction::FRem;
}

PreservedAnalyses SampleCudaPass::run(Function &F,
                    FunctionAnalysisManager &AM) {
  errs() << "Analyzing: " << F.getName() << "\n";

  // Begin identifying GPU kernel
  bool isGPUKernel = false;

  // Check for common GPU kernel calling conventions
  if (F.getCallingConv() == CallingConv::PTX_Kernel) {
    isGPUKernel = true;
  }

  // You can also check for attributes, like "kernel" or target-specific ones
  if (F.hasFnAttribute("kernel")) {
    isGPUKernel = true;
  }

  if (isGPUKernel) {
    errs() << "GPU Kernel detected: " << F.getName() << "\n";
  } else {
    errs() << "Not a GPU kernel: " << F.getName() << "\n";
    return PreservedAnalyses::all();
  }
  // End identifying GPU kernel

  // Begin calculating arithmetic intensity / memory operations
  double insts = 0.0;
  double arithmetic_insts = 0.0;

  double memory_ops = 0.0;
  double memory_loads = 0.0;
  double memory_stores = 0.0;

  for(auto &BB : F) {
    for(auto &I : BB) {
      insts++;
      // errs() << I << "\n";
      unsigned opcode = I.getOpcode();
      if (isArithmetic(opcode)) {
        arithmetic_insts++; // arithmetic operations
      } else if (opcode == Instruction::Load || opcode == Instruction::Store) {
        memory_ops++; // memory operations
        if (opcode == Instruction::Load) {
          memory_loads++; // loads
        } else if (opcode == Instruction::Store) {
          memory_stores++; // stores
        }
      }
    }
  }

  double ai = (arithmetic_insts/insts);
  errs() << "All instructions: " << format("%.0f", insts) << "\n";
  errs() << "Arithmetic instructions: " << format("%.0f", arithmetic_insts) << "\n";
  errs() << "Arithmetic intensity: " << format("%.5f", ai) << "\n";
  errs() << "Memory operations: " << format("%.0f", memory_ops) << "\n";
  errs() << "Memory loads: " << format("%.0f", memory_loads) << "\n";
  errs() << "Memory stores: " << format("%.0f", memory_stores) << "\n";
  errs() << "\n";
  // End calculating arithmetic intensity / memory operations

  return PreservedAnalyses::all();
}

