import RealmSwift

class OfflineTask: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var descriptionText: String = ""
    @objc dynamic var date: Date = Date()
}

final class OfflineSection: Object {
    @objc dynamic var name: String = ""
    
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
    
    private init() {
        addObserver()
        addArchiveSection()
    }
    
    func setOutput(_ output: mainFrameRealmOutput) {
        self.output = output
    }
    
    func getProgress() -> Float {
        guard let realm = realm else { return 0 }
        let tasksCount = Float(realm.objects(OfflineTask.self).count)
        let archiveTasksCount = Float(realm.objects(ArchiveSection.self)[0].tasks.count)
        guard tasksCount != 0 && archiveTasksCount != 0 else { return 0 }
        
        return archiveTasksCount / tasksCount
    }
    
    func taskIsComplete(in indexPath: IndexPath) {
        guard let realm = realm else { return }
        let task = realm.objects(OfflineSection.self)[indexPath.section - 1].tasks[indexPath.row]
        let archiveSection = realm.objects(ArchiveSection.self)[0]
        let offlineSection = realm.objects(OfflineSection.self)[indexPath.section - 1]
        try? realm.write {
            archiveSection.tasks.insert(task, at: 0)
            offlineSection.tasks.remove(at: indexPath.row)
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
        var count = realm.objects(OfflineSection.self).count
        count += realm.objects(ArchiveSection.self).count
        return count
    }
    
    func getNumberOfRows(in section: Int, isArchive: Bool) -> Int {
        guard let realm = realm else { return 0 }
        var count = 0
        if isArchive {
            let archiveSection = realm.objects(ArchiveSection.self)[0]
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
            let task = realm.objects(ArchiveSection.self)[0].tasks[row]
            return task
        } else {
            let task = realm.objects(OfflineSection.self)[section - 1].tasks[row]
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
        let currentSection = realm.objects(OfflineSection.self)[section - 1]
        // Auto - updating values
        try? realm.write {
            currentSection.tasks.append(task)
        }
    }
    
    func changeTask(_ task: OfflineTask, indexPath: IndexPath) {
        guard let realm = realm else { return }
        let oldTask = realm.objects(OfflineSection.self)[indexPath.section - 1].tasks[indexPath.row]
        
        try? realm.write {
            oldTask.date = task.date
            oldTask.descriptionText = task.descriptionText
            oldTask.title = task.title
        }
    }
    
    func changeSectionTitle(from text: String, in section: Int) {
        guard let realm = realm else { return }
        let oldSection = realm.objects(OfflineSection.self)[section - 1]
        try? realm.write {
            oldSection.name = text
        }
    }
    
    func deleteTask(section: Int, row: Int, isArchive: Bool) {
        guard let realm = realm else { return }
        if isArchive {
            let task = realm.objects(ArchiveSection.self)[0].tasks[row]
            try? realm.write {
                realm.delete(task)
            }
        } else {
            let task = realm.objects(OfflineSection.self)[section - 1].tasks[row]
            try? realm.write {
                realm.delete(task)
            }
        }
    }
    
    func deleteSection(section: Int) {
        guard let realm = realm else { return }
        let offlineSection = realm.objects(OfflineSection.self)[section - 1]
        let tasks = offlineSection.tasks
        try? realm.write {
            realm.delete(tasks)
            realm.delete(offlineSection)
        }
    }
}
