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

    func doneDateTapped(date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy HH:mm"
        addingTaskView?.setDate(with: dateformatter.string(from: date))
    }

    
    func doneUserTapped(user: User) {
        addingTaskView?.setUser(with: user.name)
    }
    
    func addButtonTapped() {
        // добавление задачи
    }
    
}
