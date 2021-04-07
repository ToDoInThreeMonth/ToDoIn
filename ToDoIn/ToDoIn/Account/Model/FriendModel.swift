import UIKit

protocol FriendModel {
    var image: UIImage? { get }
    var name: String { get }
}

private struct Friend: FriendModel {
    let image: UIImage?
    let name: String
}

struct FriendBase {
    static let friends: [FriendModel] = [
        Friend(image: UIImage(named: "nlo"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "nlo"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "nlo"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "nlo"), name: "Yarinich Vasek"),
        Friend(image: UIImage(named: "nlo"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "nlo"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "nlo"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "nlo"), name: "Yarinich Vasek"),
        Friend(image: UIImage(named: "nlo"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "nlo"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "nlo"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "nlo"), name: "Yarinich Vasek"),
        Friend(image: UIImage(named: "nlo"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "nlo"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "nlo"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "nlo"), name: "Yarinich Vasek")
    ]
    
    private init() {}
}
