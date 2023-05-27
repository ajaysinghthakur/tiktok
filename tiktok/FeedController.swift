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
		let videoName: String
	}
	
	// Create the collection view
	private lazy var collectionView: UICollectionView = {
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
	
	
	// Create the Diffable data source
	private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item -> FeedCollectionViewCell? in
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FeedCollectionViewCell else {
			return nil
		}
        if let url = Bundle.main.url(forResource: item.videoName, withExtension: "") {
            cell.configure(with: url)
            cell.playerView.play()
        }
		let color: UIColor = indexPath.row % 2 == 0 ? .red : .green
		cell.backgroundColor = color
		
		return cell
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		// Add the collection view to the view controller's view
		collectionView.isPagingEnabled = true
		collectionView.delegate = self
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
		snapshot.appendItems([Item(id: 1, videoName: "1.mp4"), Item(id: 2, videoName: "2.mp4"), Item(id: 3, videoName: "3.mp4")])
        
		dataSource.apply(snapshot, animatingDifferences: false)
		
	}
	
	
	
}
extension FeedController: UICollectionViewDelegate {
	// this method was not working as expected.
	//	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
	//		// Calculate the percentage of the cell that is visible
	//		let visibleRect = collectionView.bounds
	//		guard let currentLayoutAttribute = collectionView.layoutAttributesForItem(at: indexPath) else {
	//			return
	//		}
	//		guard let allLayoutAttribute = collectionView.collectionViewLayout.layoutAttributesForElements(in: visibleRect)?
	//			.filter({ $0.representedElementCategory == .cell })
	//		else {
	//			return
	//		}
	//		guard let convertedRect = allLayoutAttribute.reduce(nil, { partialResult, attributes -> CGRect? in
	//			guard attributes.frame.intersects(visibleRect) else {
	//				return partialResult
	//			}
	//			return partialResult.map { $0.union(attributes.frame) } ?? attributes.frame
	//		})?
	//			.intersection(currentLayoutAttribute.frame) else {
	//			return
	//		}
	//
	//		let visiblePercentage = convertedRect.width * convertedRect.height / (cell.bounds.width * cell.bounds.height)
	//
	//		// Do something based on the visible percentage
	//		if visiblePercentage >= 0.5 {
	//			print("More than 50% of the cell is visible:\(indexPath.row)")
	//		} else {
	//			print("Less than 50% of the cell is visible:\(indexPath.row)")
	//		}
	//	}
}
extension FeedController: UIScrollViewDelegate {
	// TODO: have to check attribute frame
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// Calculate the percentage of visible cells
		guard let collectionView = scrollView as? UICollectionView else {
			return
		}
		
		for cell in collectionView.visibleCells.compactMap({$0 as? FeedCollectionViewCell}) {
			let f = cell.frame
			let w = self.view.window!
			let rect = w.convert(f, from: cell.superview!)
			let inter = rect.intersection(w.bounds)
			let ratio = (inter.width * inter.height) / (f.width * f.height)
			let rep = (String(Int(ratio * 100)) + "%")
			
			cell.topLabel.text = rep
			cell.bottomLabel.text = rep
		}
	}
}

