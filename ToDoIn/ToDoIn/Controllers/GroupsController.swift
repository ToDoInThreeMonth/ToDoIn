//
//  GroupController.swift
//  ToDoIn
//
//  Created by Дарья on 31.03.2021.
//

import UIKit
import PinLayout

class GroupsController: UIViewController {
    
    // MARK: - Properties
    
    var groups = Data.groups
    
    weak var collectionView: UICollectionView!
    
    
    // MARK: - Handlers
    
    override func loadView() {
        super.loadView()
        
        setBackground()
        
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
        collectionView.pin.all()
    }
    
    func setBackground()  {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
    
    func configureCollectionView() {
        collectionView.register(GroupCell.self, forCellWithReuseIdentifier: GroupCell.identifier)
        collectionView.register(HeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.identifier)
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
    }
    
}


// MARK: - Extensions

extension GroupsController: UICollectionViewDataSource {

    // количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }

    // дизайн ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupCell.identifier, for: indexPath) as! GroupCell
        cell.setUp(group: groups[indexPath.row])
        return cell
    }
    
    // дизайн header'a
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionView.identifier, for: indexPath) as! HeaderCollectionView
        header.setUp(label: "")
        return header
    }
    
    // размер header'a
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: 15)
    }
}

extension GroupsController: UICollectionViewDelegateFlowLayout {

    // размер ячейки в CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 10)
    }
}

extension GroupsController: UICollectionViewDelegate {

    // нажатие на ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let groupController = GroupController(group: groups[indexPath.row])
        navigationController?.pushViewController(groupController, animated: true)
    }
}
