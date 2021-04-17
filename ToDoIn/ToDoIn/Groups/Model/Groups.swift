import Foundation

class Groups {
    static var owners = [User(user: "Я", image: "user", tasks: [Task(user: "Я", name: "Купить кальян", description: "",                       date: Date())]),
                         User(user: "Вова", image: "user", tasks: [Task(user: "Вова", name: "Взять колонку", description: "", date: Date()), Task(user: "Вова", name: "Купить еще кальян", description: "", date: Date())]),
                         User(user: "Вася", image: "user", tasks: [Task(user: "Вася", name: "Купить еще кальян", description: "", date: Date())]),
                         User(user: "Филипп", image: "user", tasks: [Task(user: "Филипп", name: "Купить еще кальян", description: "", date: Date())])]
}

//class Users {
//    static let users = [User(name: "Я", image: "user", tasks: ), User(name: , image: , tasks: )]
//}


class GroupsService {
    private var data = [Group(name: "Дача", image: "group", users: Groups.owners),
                        Group(name: "Шашлыки", image: "group", users: Groups.owners),
                        Group(name: "Кальяночка", image: "group", users: Groups.owners),
                        Group(name: "Баня", image: "group", users: Groups.owners),
                        Group(name: "День рождения", image: "group", users: Groups.owners)]
    
    func getGroups() -> [Group] {
        return data
    }
    
    func getGroup(by index: Int) -> Group {
        return data[index]
    }
}
