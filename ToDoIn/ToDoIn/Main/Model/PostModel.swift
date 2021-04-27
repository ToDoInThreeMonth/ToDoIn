import UIKit

struct Post {
    var title: String
    var description: String
    var date: Date?
    
    init(title: String = "", description: String = "", date: Date = Date()) {
        self.title = title
        self.description = description
        self.date = date
    }
}

struct Section {
    var name: String
    var posts: [Post]
    
    init(name: String = "", posts: [Post] = [Post]()) {
        self.name = name
        self.posts = posts
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
    
    func getPosts(from section: Section) -> [Post] {
        return data[0].posts
    }
    
    func changePost(_ post: Post, in section: Section) {
        
    }
    
    func addTask(_ post: Post, in section: Section) {
        
    }
    
    func addSection(with title: String) {
        print(title)
    }
    
}
