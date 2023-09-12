//
//  ProductDetailWebViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import UIKit
import WebKit

class ProductDetailWebViewController: BaseViewController {
    
    var indexPath: IndexPath?
    
    var item: Item? {
        get {
            guard let indexPath else { return nil }
            return DataStorage.shared.webQueryResults[indexPath.item]
        }
        
        set {
            guard let index = DataStorage.shared.webQueryResults.firstIndex(where: { $0.productID == newValue?.productID }) else { return }
            indexPath = IndexPath(item: index, section: 0)
        }
    }
    
    private var wishButtonImage: UIImage? {
        guard let item else { return UIImage() }
        return item.isInWishList ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    private var isInWishCompletionHandler: () -> Void
    
    private lazy var webView: WKWebView = WKWebView()
    
    init(completion: @escaping () -> Void) {
        self.isInWishCompletionHandler = completion
        
        super.init()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem?.image = wishButtonImage
    }
    
    override func configure() {
        super.configure()
        configureNavigationBar()
        
        guard let item, let url = URL(string: item.link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: wishButtonImage, style: .plain, target: self, action: #selector(toggleWishButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
    }
    
    @objc private func toggleWishButtonTapped() {
        guard let item else { return }
        do {
            if item.isInWishList {
                try WishItemRepository().delete(for: item.productID)
            } else {
                try WishItemRepository().createItem(from: item, imageData: item.imageData)
            }
        } catch {
            self.presentErrorAlert(error)
        }
        
        navigationItem.rightBarButtonItem?.image = wishButtonImage
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func showToastMessage(style: MWToastMessageView.ToastType) {
        let toastView = MWToastMessageView(toastType: style)
        
        view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toastView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            toastView.heightAnchor.constraint(greaterThanOrEqualTo: toastView.widthAnchor, multiplier: 1)
        ])
        
        UIView.animate(withDuration: 1.2, delay: 0.2, options: .curveLinear, animations: {
            toastView.alpha = 0.0
            }, completion: {(isCompleted) in
                toastView.removeFromSuperview()
            })
    }
}
