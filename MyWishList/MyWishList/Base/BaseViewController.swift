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
    
    func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "알겠어요!", style: .cancel)
        
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}
