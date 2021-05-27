import RealmSwift

class OfflineTask: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var isCompleted: Bool = false
}

final class OfflineSection: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var countCompletedTasks: Int = 0
    
    var tasks = List<OfflineTask>()
}

final class ArchiveSection: Object {
    @objc dynamic var name: String = "Архив"
    
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
        addArchiveSection()
    }
    
    func getProgress() -> Float {
        guard let realm = realm else { return 0 }
        var countTasks: Float = 0
        var completedTasks: Float = 0
        let sections = realm.objects(OfflineSection.self)
        for section in sections {
            countTasks += Float(section.tasks.count)
            completedTasks += Float(section.countCompletedTasks)
        }
        
        guard countTasks != 0 else { return 0 }
        return completedTasks / countTasks
    }
    
    func taskIsComplete(in indexPath: IndexPath) {
        guard let realm = realm else { return }
        let section = indexPath.section - 1
        let task = realm.objects(OfflineSection.self)[section].tasks[indexPath.row]
        
        if task.isCompleted == false {
            let section = realm.objects(OfflineSection.self)[section]
            try? realm.write {
                section.countCompletedTasks += 1
                task.isCompleted = true
            }
        }
    }
    
    private func addObserver() {
        token = realm?.observe { [weak self] notification, _ in
            guard let self = self else { return }
            switch notification {
            case .didChange:
                self.output?.updateUI()
            default:
                return
            }
        }
    }
    
    private func addArchiveSection() {
        guard let realm = realm else { return }
        let section = ArchiveSection()
        try? realm.write {
            realm.add(section)
        }
    }
    
    func getOfflineSections() -> [OfflineSection] {
        guard let realm = realm else { return [] }
        let results = realm.objects(OfflineSection.self)
        return Array(results)
    }
    
    func getNumberOfSections() -> Int {
        guard let realm = realm else { return 0 }
        let count = realm.objects(OfflineSection.self).count
        return count
    }
    
    func getNumberOfRows(in section: Int, isArchive: Bool) -> Int {
        guard let realm = realm else { return 0 }
        var count = 0
        if isArchive {
            guard let archiveSection = realm.objects(ArchiveSection.self).first else { return 0 }
            count = archiveSection.tasks.count
        } else {
            let section = section - 1
            count = realm.objects(OfflineSection.self)[section].tasks.count
        }
        
        return count
    }
    

    func getTask(section: Int, row: Int, isArchive: Bool) -> OfflineTask? {
        guard let realm = realm else { return nil }
        if isArchive {
            let section = section - 1
            let task = realm.objects(OfflineSection.self)[section].tasks[row]
            return task
        } else {
            guard let archiveSection = realm.objects(ArchiveSection.self).first else { return nil }
            let task = archiveSection.tasks[row]
            return task
        }
    }
    
    func getArchiveSection() -> ArchiveSection? {
        return realm?.objects(ArchiveSection.self).first
    }
    
    func addSection(_ section: OfflineSection) {
        guard let realm = realm else { return }
        try? realm.write {
            realm.add(section)
        }
    }
    
    func addTask(_ task: OfflineTask, in section: Int) {
        guard let realm = realm else { return }
        let section = section - 1
        let currentSection = realm.objects(OfflineSection.self)[section]
        // Auto - updating values
        try? realm.write {
            currentSection.tasks.append(task)
        }
    }
    
    func changeTask(_ task: OfflineTask, indexPath: IndexPath) {
        guard let realm = realm else { return }
        let section = indexPath.section - 1
        let oldTask = realm.objects(OfflineSection.self)[section].tasks[indexPath.row]
        
        try? realm.write {
            oldTask.date = task.date
            oldTask.descriptionText = task.descriptionText
            oldTask.title = task.title
        }
    }
    
    func changeSectionTitle(from text: String, in section: Int) {
        guard let realm = realm else { return }
        let section = section - 1
        let oldSection = realm.objects(OfflineSection.self)[section]
        try? realm.write {
            oldSection.name = text
        }
    }
    
    func deleteTask(section: Int, row: Int) {
        guard let realm = realm else { return }
        let section = section - 1
        let task = realm.objects(OfflineSection.self)[section].tasks[row]
        try? realm.write {
            realm.delete(task)
        }
    }
    
    func deleteSection(section: Int) {
        guard let realm = realm else { return }
        let section = section - 1
        let offlineSection = realm.objects(OfflineSection.self)[section]
        try? realm.write {
            realm.delete(offlineSection)
        }
    }
}
