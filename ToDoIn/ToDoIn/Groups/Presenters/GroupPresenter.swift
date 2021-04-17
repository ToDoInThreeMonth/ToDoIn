import Foundation

class GroupPresenter: GroupViewPresenter {

    // MARK: - Properties
    
    private let groupsService = GroupsService()
    weak var groupView: GroupView?
    
    // MARK: - Init
    
    required init(groupView: GroupView) {
        self.groupView = groupView
    }
    
    // MARK: - Handlers
    
    
    
}
