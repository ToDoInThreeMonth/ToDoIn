import Foundation

class Groups {
    var owners: [Owners]
    
    var groups: [Group]
    
    init() {
        owners = [Owners(owner: "Я", image: "user", tasks: [Task(owner: "Я", name: "Купить кальян", description: "", date: Date())]),
                  Owners(owner: "Вова", image: "user", tasks: [Task(owner: "Вова", name: "Взять колонку", description: "", date: Date()), Task(owner: "Вова", name: "Купить еще кальян", description: "", date: Date())]),
                  Owners(owner: "Вася", image: "user", tasks: [Task(owner: "Вася", name: "Купить еще кальян", description: "", date: Date())]),
                  Owners(owner: "Филипп", image: "user", tasks: [Task(owner: "Филипп", name: "Купить еще кальян", description: "", date: Date())])]
        groups = [Group(name: "Дача", image: "group", owners: owners),
                  Group(name: "Шашлыки", image: "group", owners: owners),
                  Group(name: "Кальяночка", image: "group", owners: owners),
                  Group(name: "Баня", image: "group", owners: owners),
                  Group(name: "День рождения", image: "group", owners: owners),
                  Group(name: "Новый год", image: "group", owners: owners)]
    }
}
