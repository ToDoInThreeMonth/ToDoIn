import Foundation

// MainController

protocol MainView: class {
    func setPresenter(presenter: MainViewPresenter, coordinator: MainChildCoordinator)
    func setSections(sections: [Section])
    func addTaskButtonTapped(section: Section)
}


protocol MainViewPresenter {
    init(mainView: MainView)
    
    func setCoordinator(with coordinator: MainChildCoordinator)
    
    func showTaskCotroller(section: Section, post: Post, isChanging: Bool)
    func showAddSection()
    
    func getSections() -> [Section]
    func getPosts(from section: Section) -> [Post]
    
}


// TaskSectionController

protocol TaskSectionView: class {
    func setDate(with date: String)
}

protocol TaskSectionViewPresenter {
    init(taskSectionView: TaskSectionView)
    
    func setCoordinator(with coordinator: MainChildCoordinator)

    func doneDateTapped(date: Date)
    func buttonTapped(post: Post, section: Section, isChanging: Bool)
}
