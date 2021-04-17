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
    
    func getTasks(for user: User, from group: Group) -> [Task] {
        return groupsService.getTasks(for: user, from: group)
    }
    
}
