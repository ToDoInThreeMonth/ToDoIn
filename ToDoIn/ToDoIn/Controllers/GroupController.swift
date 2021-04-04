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
        
        setBackground()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
        collectionView.register(TaskCell.self, forCellWithReuseIdentifier: TaskCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        
        //        collectionView.separatorStyle = .none
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.alwaysBounceVertical = true
        
        view.addSubview(collectionView)
    }

}


// MARK: - Extensions

extension GroupController: UICollectionViewDataSource {
    
    // количество секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return group.owners.count
    }

    // количество ячеек
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return group.owners[section].tasks.count
    }
    
    // заголовок секции
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
        sectionHeaderView.setUp(owner: group.owners[indexPath.section].owner)
        return sectionHeaderView
    }
    
    // размер секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 200, height: collectionView.bounds.height / 12)
    }

    // дизайн ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.setUp(task: group.owners[indexPath.section].tasks[indexPath.row])
        return cell
    }
}

extension GroupController: UICollectionViewDelegateFlowLayout {

    // размер ячейки в CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 15)
    }
}

