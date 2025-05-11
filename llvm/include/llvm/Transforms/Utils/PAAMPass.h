#ifndef LLVM_TRANSFORMS_PAAMPASS_H
#define LLVM_TRANSFORMS_PAAMPASS_H

#include "llvm/IR/PassManager.h"

namespace llvm {

class PAAMPass : public PassInfoMixin<PAAMPass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM);
};

} // namespace llvm

#endif // LLVM_TRANSFORMS_PAAMPASS_H