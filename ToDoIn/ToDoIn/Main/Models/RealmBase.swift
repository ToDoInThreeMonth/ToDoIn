import RealmSwift

final class OfflineTask: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var isCompleted: Bool = false
}

final class OfflineSection: Object {
    @objc dynamic var name: String = ""
    
    var tasks = List<OfflineTask>()
}

struct RealmBase {
    private static let realm = try? Realm()
    private static var sections: [OfflineSection] = []
    
    private init() {}
    
    static func downloadSections() {
//        randomUsers() // Заглушка
        
        guard let realm = realm else { return }
        // Обнуляем секции
        sections.removeAll()
        // Достаем секции из базы
        let sections = realm.objects(OfflineSection.self)
        
        // Добавляем в коллекцию
        for section in sections {
            self.sections.append(section)
        }
    }
    
    static func getAllSections() -> [OfflineSection] {
        return sections
    }
    
    static func getNumberOfSections() -> Int {
        return sections.count
    }
    
    static func getNumberOfRows(in section: Int) -> Int {
        return sections[section].tasks.count
    }
    
    static func getTask(section: Int, row: Int) -> OfflineTask? {
        if sections[section].tasks.isEmpty {
            return nil
        }
        
        return sections[section].tasks[row]
    }
    
    static func addSection(_ section: OfflineSection) {
        guard let realm = realm else { return }
        realm.beginWrite()
        realm.add(section)
        try? realm.commitWrite()
    }
    
//    // Заглушка
//    static func randomUsers() {
//        guard let realm = realm else { return }
//        realm.beginWrite()
//        realm.deleteAll()
//        // Массивы для фейк - данных
//        var tasks: [OfflineTask] = []
//        var sections: [OfflineSection] = []
//
//        for _ in 1...4 {
//            // Создаем и наполняем задачи
//            let task = OfflineTask()
//            task.date = Date()
//            task.title = "Много думать"
//            task.descriptionText = "Много думать - это лень :("
//            task.isCompleted = false
//
//            tasks.append(task)
//        }
//
//        for _ in 1...3 {
//            // Создаем и наполняем секции
//            let section = OfflineSection()
//            section.name = "Работа"
//            tasks.forEach {
//                section.tasks.append($0)
//            }
//            sections.append(section)
//        }
//
//        realm.add(sections)
//        try? realm.commitWrite()
//
//    }
    
    
    
//    static func addNewTask(_ task: OfflineTask, from section: Int) {
//        guard let realm = realm else { return }
//        realm.beginWrite()
//        realm.
//    }
}
