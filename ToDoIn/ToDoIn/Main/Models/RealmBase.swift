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
    
    private init() {}
    
    static func getAllSections() -> [OfflineSection] {
        guard let realm = realm else { return [] }
        let results = realm.objects(OfflineSection.self)
        return Array(results)
    }
    
    static func getNumberOfSections() -> Int {
        guard let realm = realm else { return 0 }
        let count = realm.objects(OfflineSection.self).count
        return count
    }
    
    static func getNumberOfRows(in section: Int) -> Int {
        guard let realm = realm else { return 0 }
        let count = realm.objects(OfflineSection.self)[section].tasks.count
        return count
    }
    
    static func getTask(section: Int, row: Int) -> OfflineTask? {
        guard let realm = realm else { return nil }
        let task = realm.objects(OfflineSection.self)[section].tasks[row]
        return task
    }
    
    static func addSection(_ section: OfflineSection) {
        guard let realm = realm else { return }
        realm.beginWrite()
        realm.add(section)
        try? realm.commitWrite()
    }

    static func addTask(_ task: OfflineTask, in section: Int) {
        guard let realm = realm else { return }
        let currentSection = realm.objects(OfflineSection.self)[section]
        // Auto - updating values
        try? realm.write {
            currentSection.tasks.append(task)
        }
    }
    
    static func changeTask(_ task: OfflineTask, indexPath: IndexPath) {
        guard let realm = realm else { return }
        let oldTask = realm.objects(OfflineSection.self)[indexPath.section].tasks[indexPath.row]
        
        try? realm.write {
            oldTask.date = task.date
            oldTask.descriptionText = task.descriptionText
            oldTask.title = task.title
        }
    }
    
    static func changeSectionTitle(from text: String, in section: Int) {
        guard let realm = realm else { return }
        let oldSection = realm.objects(OfflineSection.self)[section]
        try? realm.write {
            oldSection.name = text
        }
    }
}
