import Foundation

class MainPresenter: MainViewPresenter {

    // MARK: - Properties
    
    weak var coordinator: MainChildCoordinator?

    private let mainView: MainView
    
    private let postsService = PostService()
    
    // MARK: - Init
    
    required init(mainView: MainView) {
        self.mainView = mainView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: MainChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers
    
    func getSections() -> [Section] {
        return postsService.getSections()
    }
    
    func getPosts(from section: Section) -> [Post] {
        return postsService.getPosts(from: section)
    }
    
    func showTaskCotroller(section: Section, post: Post, isChanging: Bool) {
        coordinator?.showPostInfo(post: post, in: section, isChanging: isChanging)
    }
    
    func showAddSection() {
        coordinator?.showAddSection()
    }
    
}
