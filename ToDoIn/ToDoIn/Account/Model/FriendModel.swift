import UIKit

protocol FriendModelProtocol {
    var image: UIImage? { get }
    var name: String { get }
}

private struct Friend: FriendModelProtocol {
    let image: UIImage?
    let name: String
}

// Singleton database
struct FriendBase {
    static let friends: [FriendModelProtocol] = [
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
