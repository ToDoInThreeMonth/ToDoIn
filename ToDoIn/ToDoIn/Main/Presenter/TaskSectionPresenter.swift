import Foundation

class TaskSectionPresenter: TaskSectionViewPresenter {

    // MARK: - Properties
    
    weak var coordinator: MainChildCoordinator?

    private let taskSectionView: TaskSectionView
    
    private let postsService = PostService()
    
    // MARK: - Init
    
    required init(taskSectionView: TaskSectionView) {
        self.taskSectionView = taskSectionView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: MainChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers

    func doneDateTapped(date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy HH:mm"
        taskSectionView.setDate(with: dateformatter.string(from: date))
    }

    func buttonTapped(post: Post, section: Section, isChanging: Bool) {
        if isChanging {
            postsService.changePost(post, in: section)
        }
        else {
            postsService.addTask(post, in: section)
        }
    }
    
}
