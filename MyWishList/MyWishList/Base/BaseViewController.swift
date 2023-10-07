//
//  BaseViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHiararchy()
        setConstraints()
    }
    
    func configureHiararchy() {
        view.backgroundColor = .systemBackground
    }
    
    func setConstraints() {}
    
    func presentNetworkDisconnectStatus() {}
    
    func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: String(describing: error), message: nil, preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "알겠어요!", style: .cancel)
        
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}
