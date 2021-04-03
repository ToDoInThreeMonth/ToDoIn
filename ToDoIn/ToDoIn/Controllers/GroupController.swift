//
//  GroupController.swift
//  ToDoIn
//
//  Created by Дарья on 02.04.2021.
//

import UIKit
import PinLayout

class GroupController: UIViewController {
    
    // MARK: - Properties
    
    weak var collectionView: UICollectionView!
    
    private let group: Group
    
    
    // MARK: - Init
    
    init(group: Group) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Handlers
    
    override func loadView() {
            super.loadView()

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//            collectionView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(collectionView)
            self.collectionView = collectionView
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.pin
            .marginTop(80)
            .marginHorizontal(10)
            .all()
    }
    
    func configureCollectionView() {
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.identifier)
        
        //        collectionView.separatorStyle = .none
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
    }

}


// MARK: - Extensions

extension GroupController: UICollectionViewDataSource {

    // количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return group.tasks.count
    }

    // дизайн ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.setUp(task: group.tasks[indexPath.row])
        return cell
    }
}

extension GroupController: UICollectionViewDelegateFlowLayout {

    // размер ячейки в CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 12)
    }
}

