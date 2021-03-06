public enum Step: String {
    case script
    case commit
    case tag
    case push
    case branch
    case gitAdd = "git_add"
    case hideDependencies = "hide_dev_dependencies"
    case unhideDependencies = "unhide_dev_dependencies"
    case swiftScript = "swift_script"

    func executor(dictionary: [String: Any]?) -> StepExecutor {
        return executorType.init(step: self, dictionary: dictionary)
    }

    private var executorType: StepExecutor.Type {
        switch self {
        case .script:
            return ScriptExecutor.self
        case .commit:
            return CommitExecutor.self
        case .tag:
            return TagExecutor.self
        case .push:
            return PushExecutor.self
        case .gitAdd:
            return GitAddExecutor.self
        case .hideDependencies:
            return HideDevDependenciesExecutor.self
        case .unhideDependencies:
            return UnhideDevDependenciesExecutor.self
        case .swiftScript:
            return SwiftScriptExecutor.self
        case .branch:
            return BranchExecutor.self
        }
    }
}
