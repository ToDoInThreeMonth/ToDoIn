//
//  GroupController.swift
//  ToDoIn
//
//  Created by Дарья on 31.03.2021.
//

import UIKit
import PinLayout

class GroupsController: UIViewController {
    
    var groups = [Group(name: "Дача", image: "group"), Group(name: "Шашлыки", image: "group"), Group(name: "Дача", image: "group"), Group(name: "Шашлыки", image: "group")]
    
    
    weak var collectionView: UICollectionView!
    
    override func loadView() {
            super.loadView()

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//            collectionView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(collectionView)
            self.collectionView = collectionView
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.pin.margin(20).all()
    }
    
    func configureCollectionView() {
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: GroupCell.identifier)
        
        //        collectionView.separatorStyle = .none
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
    }
    
}

extension GroupsController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.identifier, for: indexPath) as! GroupCell
        cell.setUp(group: groups[indexPath.row])
        return cell
    }
}

extension GroupsController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupController = GroupController(group: groups[indexPath.row])
        navigationController?.pushViewController(groupController, animated: true)
    }
}

extension GroupsController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 10)
    }
}
