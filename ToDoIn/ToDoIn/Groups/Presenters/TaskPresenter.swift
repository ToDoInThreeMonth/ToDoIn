import Foundation

class TaskPresenter: TaskViewPresenter {
    
    // MARK: - Properties
    
//    private let groupsService = GroupsService()
    private let taskView: TaskView?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
        
    // MARK: - Init
    
    required init(addingTaskView: TaskView) {
        self.taskView = addingTaskView
    }
    
    // MARK: - Handlers

    func doneDateTapped(date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy HH:mm"
        taskView?.setDate(with: dateformatter.string(from: date))
    }
    
    func doneUserTapped(user: User) {
        taskView?.setUser(with: user.name)
    }
    
    func buttonTapped(_ isChanging: Bool, task: Task, group: Group) {
        if isChanging {
//            groupsService.changeTask(task, in: group)
        }
        else {
//            groupsService.addTask(task, in: group)
        }
    }
    
//    func getUser(by index: Int, in group: Group) -> User {
//        return groupsManager.getUser(by: group.users[index])
//    }
    
    func getUser(by userId: String, in users: [User]) -> User {
        for user in users {
            if userId == user.id {
                return user
            }
        }
        return User()
    }
}
    
