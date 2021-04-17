import Foundation

class GroupsPresenter: GroupsViewPresenter {
    
    
    private let groupsService = GroupsService()
    weak var groupsView: GroupsView?
    
    required init(groupsView: GroupsView) {
        self.groupsView = groupsView
    }
    
    func getGroups() {
        let groups = groupsService.getGroups()
        groupsView?.setGroups(groups: groups)
    }
}
