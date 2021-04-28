import Foundation

struct Tasks {
    static var tasks = [Task(user: Users.users[0], name: "Купить кальян", description: "Описание...", date: Date()),
                        Task(user: Users.users[0], name: "Взять колонку", description: "Описание...", date: Date()),
                        Task(user: Users.users[1], name: "Купить поесть", description: "Описание...", date: Date()),
                        Task(user: Users.users[1], name: "Заказать такси", description: "Описание...", date: Date()),
                        Task(user: Users.users[2], name: "Купить еще поесть", description: "Описание...", date: Date()),
                        Task(user: Users.users[3], name: "Купить еще кальян", description: "Описание...", date: Date())]
}

struct Users {
    static let users = [User(name: "Я", image: "user"),
                        User(name: "Вова", image: "user"),
                        User(name: "Вася", image: "user"),
                        User(name: "Филипп", image: "user")]
}


class GroupsService {
    private var data = [Group(name: "Дача", image: "group", tasks: Tasks.tasks, users: Users.users),
                        Group(name: "Шашлыки", image: "group", tasks: Tasks.tasks, users: Users.users),
                        Group(name: "Кальяночка", image: "group", tasks: Tasks.tasks, users: Users.users),
                        Group(name: "Баня", image: "group", tasks: Tasks.tasks, users: Users.users),
                        Group(name: "День рождения", image: "group", tasks: Tasks.tasks, users: Users.users)]
    
    func getGroups() -> [Group] {
        return data
    }
    
    func getGroup(by index: Int) -> Group {
        return data[index]
    }
    
    func getTasks(for user: User, from group: Group) -> [Task] {
        var tasks = [Task]()
        for task in group.tasks {
            if (user == task.user) {
                tasks.append(task)
            }
        }
        return tasks
    }
    
    func addTask(_ task: Task, in group: Group) {
        guard let index = data.firstIndex(of: group) else {
            return
        }
        data[index].tasks.append(task)
    }
    
    func changeTask(_ task: Task, in group: Group) {
        // изменение задачи
    }
    
}
