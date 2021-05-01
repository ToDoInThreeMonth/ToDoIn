//import Foundation
//import FirebaseFirestore
//
//struct Tasks {
//    static var tasks = [Task(userId: Users.users[0].id, title: "Купить кальян", description: "Описание...", date: Date()),
//                        Task(userId: Users.users[0].id, title: "Взять колонку", description: "Описание...", date: Date()),
//                        Task(userId: Users.users[1].id, title: "Купить поесть", description: "Описание...", date: Date()),
//                        Task(userId: Users.users[1].id, title: "Заказать такси", description: "Описание...", date: Date()),
//                        Task(userId: Users.users[2].id, title: "Купить еще поесть", description: "Описание...", date: Date()),
//                        Task(userId: Users.users[3].id, title: "Купить еще кальян", description: "Описание...", date: Date())]
//}
//
//struct Users {
//    static let users = [User(name: "Я", image: "user"),
//                        User(name: "Вова", image: "user"),
//                        User(name: "Вася", image: "user"),
//                        User(name: "Филипп", image: "user")]
//}
//
//
//class GroupsService {
//    private var data = [Group(title: "Дача", image: "group", tasks: Tasks.tasks, users: Users.users),
//                        Group(title: "Шашлыки", image: "group", tasks: Tasks.tasks, users: Users.users),
//                        Group(title: "Кальяночка", image: "group", tasks: Tasks.tasks, users: Users.users),
//                        Group(title: "Баня", image: "group", tasks: Tasks.tasks, users: Users.users),
//                        Group(title: "День рождения", image: "group", tasks: Tasks.tasks, users: Users.users)]
//
//    public var groups = [Group]()
//
//    let db = Firestore.firestore()
//
//    func getGroups() -> [Group] {
//        db.collection("groups").getDocuments { (snapshot, error) in
//            if error == nil && snapshot != nil {
//                for document in snapshot!.documents {
//                    let id = document.data()["id"] as? String ?? ""
//                    let title = document.data()["title"] as? String ?? "err"
//                    let image = document.data()["image"] as? String ?? ""
//                    let group = Group(id: id, title: title, image: image)
//                    self.groups.append(group)
//                }
//            }
//        }
//        return groups
//    }
//
//    func getGroup(by index: Int) -> Group {
//        return data[index]
//    }
//
//    func getTasks(for user: User, from group: Group) -> [Task] {
//        var tasks = [Task]()
//        for task in group.tasks {
//            if (user.id == task.userId) {
//                tasks.append(task)
//            }
//        }
//        return tasks
//    }
//
//    func addTask(_ task: Task, in group: Group) {
//        guard let index = data.firstIndex(of: group) else {
//            return
//        }
//        data[index].tasks.append(task)
//    }
//
//    func changeTask(_ task: Task, in group: Group) {
//        // изменение задачи
//    }
//
//}
//
////                    let tasks = document.data()["tasks"] as? [Any]
////                    if let tasks = tasks {
////                        for task in tasks {
////                            if let task = task as? NSDictionary {
////                                let title = task.value(forKey: "title") as? String
////                            }
////                        }
////                    }
