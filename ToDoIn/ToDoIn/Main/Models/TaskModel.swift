import UIKit

protocol OfflineTaskProtocol {
    var title: String { get }
    var date: String? { get }
    var section: String { get }
    var isCompleted: Bool { get set }
}

private struct OfflineTask: OfflineTaskProtocol {
    let title: String
    let date: String?
    let section: String
    var isCompleted: Bool
}

struct TaskModel {
    static var posts: [[OfflineTaskProtocol]] = [
        [ OfflineTask(title: "Написать 10 строк кода", date: nil, section: "Работа", isCompleted: false),
          OfflineTask(title: "Написать 20 строк кода", date: nil, section: "Работа", isCompleted: false),
          OfflineTask(title: "Написать 30 строк кода", date: nil, section: "Работа", isCompleted: false) ],
            [ OfflineTask(title: "Покушать", date: nil, section: "Повседневка", isCompleted: false),
              OfflineTask(title: "Поспать", date: nil, section: "Повседневка", isCompleted: false),
              OfflineTask(title: "Выпить яблочный сидр", date: nil, section: "Повседневка", isCompleted: false),
              OfflineTask(title: "Уложить начальство спать", date: nil, section: "Повседневка", isCompleted: false),
              OfflineTask(title: "Написать 10 строк кода", date: nil, section: "Повседневка", isCompleted: false) ]
    ]
}
