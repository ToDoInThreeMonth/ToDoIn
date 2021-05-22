import RealmSwift

final class OfflineTask: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var isCompleted: Bool = false
}

final class OfflineSection: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var countCompletedTasks: Float = 0.0
    
    var tasks = List<OfflineTask>()
}

class MainFrameRealm: MainFrameRealmProtocol {
    static let shared = MainFrameRealm()
    private var output: mainFrameRealmOutput?
    private let realm = try? Realm()
    private var token: NotificationToken?
    
    private init() {}
    
    func setOutput(_ output: mainFrameRealmOutput) {
        self.output = output
        addObserver()
    }
    
    func getProgress() -> Float {
        guard let realm = realm else { return 0 }
        let sections = realm.objects(OfflineSection.self)
        let sectionsCount = Float(sections.count)
        var summaryProgress: Float = 0

        for section in sections {
            if !section.tasks.isEmpty {
                summaryProgress = section.countCompletedTasks / Float(section.tasks.count)
            }
        }
    
        return summaryProgress / sectionsCount
    }
    
    func taskIsComplete(in indexPath: IndexPath) {
        guard let realm = realm else { return }
        let task = realm.objects(OfflineSection.self)[indexPath.section].tasks[indexPath.row]
        
        if task.isCompleted == false {
            let section = realm.objects(OfflineSection.self)[indexPath.section]
            try? realm.write {
                section.countCompletedTasks += 1
                task.isCompleted = true
            }
        }
    }
    
    private func addObserver() {
        token = realm?.observe { [weak self] notification, _ in
            print("прошел")
            guard let self = self else { return }
            switch notification {
            case .didChange:
                self.output?.updateUI()
            default:
                return
            }
        }
    }
    
    func getAllSections() -> [OfflineSection] {
        guard let realm = realm else { return [] }
        let results = realm.objects(OfflineSection.self)
        return Array(results)
    }
    
    func getNumberOfSections() -> Int {
        guard let realm = realm else { return 0 }
        let count = realm.objects(OfflineSection.self).count
        return count
    }
    
    func getNumberOfRows(in section: Int) -> Int {
        guard let realm = realm else { return 0 }
        let count = realm.objects(OfflineSection.self)[section].tasks.count
        return count
    }
    
    func getTask(section: Int, row: Int) -> OfflineTask? {
        guard let realm = realm else { return nil }
        let task = realm.objects(OfflineSection.self)[section].tasks[row]
        return task
    }
    
    func addSection(_ section: OfflineSection) {
        guard let realm = realm else { return }
        try? realm.write {
            realm.add(section)
        }
    }

    func addTask(_ task: OfflineTask, in section: Int) {
        guard let realm = realm else { return }
        let currentSection = realm.objects(OfflineSection.self)[section]
        // Auto - updating values
        try? realm.write {
            currentSection.tasks.append(task)
        }
    }
    
    func changeTask(_ task: OfflineTask, indexPath: IndexPath) {
        guard let realm = realm else { return }
        let oldTask = realm.objects(OfflineSection.self)[indexPath.section].tasks[indexPath.row]
        
        try? realm.write {
            oldTask.date = task.date
            oldTask.descriptionText = task.descriptionText
            oldTask.title = task.title
        }
    }
    
    func changeSectionTitle(from text: String, in section: Int) {
        guard let realm = realm else { return }
        let oldSection = realm.objects(OfflineSection.self)[section]
        try? realm.write {
            oldSection.name = text
        }
    }
    
    func deleteTask(section: Int, row: Int) {
        guard let realm = realm else { return }
        let task = realm.objects(OfflineSection.self)[section].tasks[row]
        try? realm.write {
            realm.delete(task)
        }
    }
    
    func deleteSection(section: Int) {
        guard let realm = realm else { return }
        let section = realm.objects(OfflineSection.self)[section]
        try? realm.write {
            realm.delete(section)
        }
    }
}
