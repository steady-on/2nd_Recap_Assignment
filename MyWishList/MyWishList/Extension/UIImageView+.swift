//
//  UIImageView+.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

extension UIImageView {
    func loadImage(from url: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: url), let data = try? Data(contentsOf: url) else {
                self.image = UIImage(systemName: "photo")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
