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
        taskView?.setDate(with: date.toString())
    }
    
    func doneUserTapped(user: User) {
        taskView?.setUser(with: user.name)
    }
    
    func buttonTapped(_ isChanging: Bool, task: Task, group: Group) {
        if isChanging {
            groupsManager.changeTask(task, in: group)
        }
        else {
            groupsManager.addTask(task, in: group)
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
    
