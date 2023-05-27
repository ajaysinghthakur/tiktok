//
//  FeedCollectionViewCell.swift
//  tiktok
//
//  Created by RMAC-34 on 11/04/23.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    lazy var topLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var playerView: PlayerView = {
        let player = PlayerView.init()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addViews() {
        self.contentView.addSubview(playerView)
        self.contentView.addSubview(topLabel)
        self.contentView.addSubview(bottomLabel)
        NSLayoutConstraint.activate([
            
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            playerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            playerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            topLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 100),
            topLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            bottomLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -100),
            bottomLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
            
        ])
    }
    
    // MARK: exposed methods
    func configure(with videoURL: URL) {
        playerView.videoUrl = videoURL
    }
}
