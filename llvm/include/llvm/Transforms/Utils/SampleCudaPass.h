#ifndef LLVM_TRANSFORMS_SAMPLECUDAPASS_H
#define LLVM_TRANSFORMS_SAMPLECUDAPASS_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class SampleCudaPass : public PassInfoMixin<SampleCudaPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_SAMPLECUDAPASS_H
