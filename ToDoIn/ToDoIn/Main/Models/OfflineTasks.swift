import Foundation

struct Section {
    let name: String
    let tasks: [Task]
}

struct OfflineTasks {
    static var sections: [Section] = [
        Section(name: "Работа", tasks: [
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
        ]),
        Section(name: "Дом", tasks: [
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
        ]),
        Section(name: "Чиллаут", tasks: [
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
            Task(user: User(), name: "Поработать", description: "Выйти в нормальную рабочую норму", date: Date()),
        ])
    ]
}
