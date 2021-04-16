import Foundation

class AddingTaskPresenter: AddingTaskViewPresenter {
    
    // MARK: - Properties
    
    private let groupsService = GroupsService()
    weak var addingTaskView: AddingTaskView?
    
    // MARK: - Init
    
    required init(addingTaskView: AddingTaskView) {
        self.addingTaskView = addingTaskView
    }
    
    // MARK: - Handlers

    func addButtonTapped() {
    }
    
}
