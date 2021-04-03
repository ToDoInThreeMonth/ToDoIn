//
//  Data.swift
//  ToDoIn
//
//  Created by Дарья on 03.04.2021.
//

import Foundation

class Data {
    static var tasks = [Task(owner: "Я", name: "Купить кальян", description: "", date: Date()),
                        Task(owner: "Вова", name: "Взять колонку", description: "", date: Date()),
                        Task(owner: "Вова", name: "Купить еще кальян", description: "", date: Date()),
                        Task(owner: "Вася", name: "Купить еще кальян", description: "", date: Date()),
                        Task(owner: "Филипп", name: "Купить еще кальян", description: "", date: Date())]
    
    static var groups = [Group(name: "Дача", image: "group", tasks: tasks),
                         Group(name: "Шашлыки", image: "group", tasks: tasks),
                         Group(name: "Кальяночка", image: "group", tasks: tasks),
                         Group(name: "Баня", image: "group", tasks: tasks),
                         Group(name: "Денья рождения", image: "group", tasks: tasks),
                         Group(name: "Новый год", image: "group", tasks: tasks)]
}
