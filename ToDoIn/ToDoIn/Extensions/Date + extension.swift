import Foundation

extension Date {
    func toString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateformatter.string(from: self)
    }
}
