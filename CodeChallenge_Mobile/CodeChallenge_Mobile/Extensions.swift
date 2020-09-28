//
//  Extensions.swift
//  CodeChallenge_Mobile
//
//  Created by Bhadresh Radadiya on 2020-09-26.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(from link: String?, contentMode mode: UIView.ContentMode) {
        contentMode = mode
        if link != nil, let imgUrl = URL(string: link!) {
            URLSession.shared.dataTask(with: imgUrl) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error in image download.")
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
