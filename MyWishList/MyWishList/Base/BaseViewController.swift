//
//  BaseViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setConstraints()
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() {}
}
