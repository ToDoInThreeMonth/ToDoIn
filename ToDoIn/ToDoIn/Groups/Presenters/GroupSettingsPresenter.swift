import Foundation

class GroupSettingsPresenter: GroupSettingsViewPresenter {
    
    // MARK: - Properties
    
    private let groupsService = GroupsService()
    weak var groupSettingsView: GroupSettingsView?
        
    // MARK: - Init
    
    required init(groupSettingsView: GroupSettingsView) {
        self.groupSettingsView = groupSettingsView
    }
    
    // MARK: - Handlers

    func groupTitleDidChange(with title: String) {
        // изменение названия комнаты 
    }
    
    func addUserButtonTapped() {
        // добавление нового участника в комнату
    }
    
}
