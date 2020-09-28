//
//  PlaylistCell.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-25.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

struct PlaylistCellConfig {
    let title: String?
    let count: Int?
    let imageUrlString: String?
}

class PlaylistCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var videoCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with config: PlaylistCellConfig) {
        thumbnailImage.setImage(from: config.imageUrlString, contentMode: .scaleAspectFit)
        title.text = config.title
        
        if let count = config.count {
            videoCount.text = "Number of vieos: \(count)"
        }
    }
}
