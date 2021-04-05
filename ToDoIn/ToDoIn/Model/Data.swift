import Foundation

class Data {
    static var owners = [Owners(owner: "Я", tasks: [Task(owner: "Я", name: "Купить кальян", description: "", date: Date())]),
                         Owners(owner: "Вова", tasks: [Task(owner: "Вова", name: "Взять колонку", description: "", date: Date()), Task(owner: "Вова", name: "Купить еще кальян", description: "", date: Date())]),
                         Owners(owner: "Вася", tasks: [Task(owner: "Вася", name: "Купить еще кальян", description: "", date: Date())]),
                         Owners(owner: "Филипп", tasks: [Task(owner: "Филипп", name: "Купить еще кальян", description: "", date: Date())])]
    
    static var groups = [Group(name: "Дача", image: "group", owners: owners),
                         Group(name: "Шашлыки", image: "group", owners: owners),
                         Group(name: "Кальяночка", image: "group", owners: owners),
                         Group(name: "Баня", image: "group", owners: owners),
                         Group(name: "День рождения", image: "group", owners: owners),
                         Group(name: "Новый год", image: "group", owners: owners)]
}
