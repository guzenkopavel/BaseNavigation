//
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//

import Foundation
import UIKit

class MainScreenView: UIView, MainScreenViewProtocol {
    public var presenter: MainScreenPresenterForViewProtocol? = nil
    private var entities: [MainScreenViewEntityProtocol] = []

    // MARK: MainScreenViewProtocol

    func showEntities(_ entities: [MainScreenViewEntityProtocol]) {
        self.entities = entities
        collectionView.reloadData()
    }

    func removeEntityWithID(_ entityID: Int) {
        guard let index = entities.firstIndex(where: { $0.id == entityID }) else {
            return
        }

        guard let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MainScreenCell else {
            return
        }

        // Hide content on cell, to right with animate
        cell.hideContent()
        UIView.animate(withDuration: 0.33, animations: {
            cell.layoutIfNeeded()
        }, completion: { b in
            // After animate was complete, remove entity and cell
            self.collectionView.performBatchUpdates {
                self.entities.remove(at: index)
                self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
        })
    }

    func updateEntity(_ entity: MainScreenViewEntityProtocol) {
        collectionView.performBatchUpdates {
            guard let index = entities.firstIndex(where: { $0.id == entity.id }) else {
                return
            }
            entities[index] = entity
            collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
        }
    }

    // MARK: User Interface

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // Create lazy indicator. If user use pull-to-refresh action, it will be show on top
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        refresh.tintColor = .black
        refresh.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        return refresh
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        // Set cell offset to 0
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .blue
        collection.bounces = true
        collection.register(MainScreenCell.self, forCellWithReuseIdentifier: MainScreenCell.cellIdentifier())
        collection.refreshControl = refreshControl
        return collection
    }()

    // MARK: Private func

    // Setup default constrains, and default view parameters
    private func setupUI() {
        backgroundColor = .red
        addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }

    // Reload cells data
    @objc private func reloadData() {
        presenter?.restoreDefaultData()
        refreshControl.endRefreshing()
    }
}

// MARK: UICollectionView Delegate
extension MainScreenView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        entities.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenCell.cellIdentifier(), for: indexPath) as! MainScreenCell
        cell.entity = entities[indexPath.row]
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.width)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let entity = entities[indexPath.row]
        presenter?.tapOnEntity(entity)
    }
}