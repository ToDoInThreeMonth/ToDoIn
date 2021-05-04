import UIKit

struct Post {
    private var title: String
    private var description: String
    private var date: Date?
    
    init(title: String = "", description: String = "", date: Date = Date()) {
        self.title = title
        self.description = description
        self.date = date
    }
}

struct Section {
    private var name: String
    private var posts: [Post]
    
    init(name: String = "", posts: [Post] = [Post]()) {
        self.name = name
        self.posts = posts
    }
    
    func getPosts() -> [Post] {
        return posts
    }
}

struct PostService {
    private var data: [Section] = [Section(name: "Работа", posts: [
                                            Post(title: "Написать 10 строк кода", description: "Описание задания...", date: Date()),
                                            Post(title: "Написать 20 строк кода", description: "Описание задания...", date: Date()),
                                            Post(title: "Написать 30 строк кода", description: "Описание задания...", date: Date())]),
                                  Section(name: "Повседневка", posts: [
                                            Post(title: "Покушать", description: "Описание задания...", date: Date()),
                                            Post(title: "Поспать", description: "Описание задания...", date: Date()),
                                            Post(title: "Выпить яблочный сидр", description: "Описание задания...", date: Date()),
                                            Post(title: "Написать 10 строк кода", description: "Описание задания...", date: Date())])]
    
    func getSections() -> [Section] {
        return data
    }
    
    static func getPosts(from section: Int) -> [Post] {
        return data[section].getPosts()
    }
    
    func changePost(_ post: Post, in section: Section) {
        
    }
    
    func addTask(_ post: Post, in section: Section) {
        
    }
    
    func addSection(with title: String) {
        print(title)
    }
    
}
