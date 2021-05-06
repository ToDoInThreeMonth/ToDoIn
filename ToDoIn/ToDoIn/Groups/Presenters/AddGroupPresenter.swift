import Foundation

protocol AddGroupViewPresenter {
    func addButtonTapped()
}

class AddGroupPresenter: AddGroupViewPresenter {
    
    // MARK: - Properties
    
    private let addGroupView: AddGroupView?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
        
    // MARK: - Init
    
    required init(addGroupView: AddGroupView) {
        self.addGroupView = addGroupView
    }
    
    // MARK: - Handlers
    
    func addButtonTapped() {
        
    }
}
