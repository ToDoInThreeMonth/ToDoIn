import UIKit

protocol PostStructure {
    var title: String { get }
    var date: String? { get }
    var group: String { get }
}

private struct Post: PostStructure {
    let title: String
    let date: String?
    let group: String
}

struct PostModel {
    static var posts: [[PostStructure]] = [
            [ Post(title: "Написать 10 строк кода", date: nil, group: "Работа"),
              Post(title: "Написать 20 строк кода", date: nil, group: "Работа"),
              Post(title: "Написать 30 строк кода", date: nil, group: "Работа") ],
            [ Post(title: "Покушать", date: nil, group: "Повседневка"),
              Post(title: "Поспать", date: nil, group: "Повседневка"),
              Post(title: "Выпить яблочный сидр", date: nil, group: "Повседневка"),
              Post(title: "Уложить начальство спать", date: nil, group: "Повседневка"),
              Post(title: "Написать 10 строк кода", date: nil, group: "Повседневка") ]
    ]
}
