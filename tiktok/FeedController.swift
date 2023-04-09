//
//  ViewController.swift
//  tiktok
//
//  Created by RMAC-34 on 08/04/23.
//

import UIKit

class FeedController: UIViewController {
	
	
	// Define the section enum
		enum Section {
			case main
		}

		// Define the item struct
		struct Item: Hashable {
			let id: Int
			let title: String
		}
	
	// Create the collection view
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
		collectionView.backgroundColor = .white
		return collectionView
	}()
	
	
	// Define the layout for the collection view
	private lazy var layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
		// Create a layout for each section, representing a single video post
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
		let section = NSCollectionLayoutSection(group: group)
//
		section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0) // Add some bottom padding between each section
		return section
	}
	
	
	// Create the diffable data source
		private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
			let color: UIColor = indexPath.row % 2 == 0 ? .red : .green
			cell.backgroundColor = color
			//cell.textLabel?.text = item.title
			return cell
		}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// Add the collection view to the view controller's view
		collectionView.isPagingEnabled = true
		view.addSubview(collectionView)

		// Configure the collection view constraints
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])

		// Load the initial data
		var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
		snapshot.appendSections([.main])
		snapshot.appendItems([Item(id: 1, title: "Item 1"), Item(id: 2, title: "Item 2"), Item(id: 3, title: "Item 3")])
		dataSource.apply(snapshot, animatingDifferences: false)
		
	}
	
	
	
}

