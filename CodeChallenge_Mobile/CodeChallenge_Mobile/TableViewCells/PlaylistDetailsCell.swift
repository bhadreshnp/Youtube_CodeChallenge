//
//  PlaylistDetailsCell.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-26.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

struct PlaylistDetailsCellConfig {
    let title: String?
    let author: String?
    let minute: String?
    let imageUrlString: String?
}

class PlaylistDetailsCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var minutes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with config: PlaylistDetailsCellConfig) {
        thumbnailImage.setImage(from: config.imageUrlString, contentMode: .scaleAspectFit)
        title.text = config.title
        author.text = config.author
        minutes.text = config.minute
    }
}
