//
//  Model.swift
//  ToDoIn
//
//  Created by Philip on 04.05.2021.
//

import UIKit

protocol FriendModelProtocol {
    var image: UIImage? { get }
    var name: String { get }
}

private struct Friend: FriendModelProtocol {
    let image: UIImage?
    let name: String
}

struct FriendBase {
    static let friends: [FriendModelProtocol] = [
        Friend(image: UIImage(named: "user"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "user"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "user"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "user"), name: "Yarinich Vasek"),
        Friend(image: UIImage(named: "user"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "plus"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "user"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "plus"), name: "Yarinich Vasek"),
        Friend(image: UIImage(named: "group"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "user"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "user"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "plus"), name: "Yarinich Vasek"),
        Friend(image: UIImage(named: "plus"), name: "Kamnev Vladimir"),
        Friend(image: UIImage(named: "user"), name: "Gurin Philipp"),
        Friend(image: UIImage(named: "group"), name: "Tatarinova Darya"),
        Friend(image: UIImage(named: "user"), name: "Yarinich Vasek")
    ]
    
    private init() {}
}
