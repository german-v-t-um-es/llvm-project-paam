#include "llvm/Transforms/Utils/SampleCudaPass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

PreservedAnalyses SampleCudaPass::run(Function &F,
                    FunctionAnalysisManager &AM) {
  errs() << "Analyzing: " << F.getName() << "\n";

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
  }

  uint64_t count = 0;
  for(auto &BB : F) {
    for(auto &I : BB) {
      // errs() << I << "\n";
      if (I.getOpcode() == Instruction::Load) {
        count++;
      }
    }
  }
  errs() << "Number of loads: " << count << "\n";

  return PreservedAnalyses::all();
}

