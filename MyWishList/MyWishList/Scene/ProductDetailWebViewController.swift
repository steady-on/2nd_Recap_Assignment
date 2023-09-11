//
//  ProductDetailWebViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import UIKit
import WebKit

class ProductDetailWebViewController: BaseViewController {
    
    var link: String!
    
    private var isInWishList: Bool!
    private var isInWishCompletionHandler: ((Bool) -> ())!
    
    private var wishButtonImage: UIImage? {
        isInWishList ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    private lazy var webView: WKWebView = WKWebView()
    
    init(link: String, title: String, isWish isInWishList: Bool, isInWishCompletionHandler: @escaping (Bool) -> ()) {
        super.init()
        
        self.link = link
        self.title = title
        self.isInWishList = isInWishList
        self.isInWishCompletionHandler = isInWishCompletionHandler
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isInWishCompletionHandler(isInWishList)
    }
    
    override func configure() {
        super.configure()
        configureNavigationBar()
        
        guard let link, let url = URL(string: link) else { return }
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
        isInWishList.toggle()
        navigationItem.rightBarButtonItem?.image = wishButtonImage
        
        if isInWishList {
            showToastMessage(style: .save)
        } else {
            showToastMessage(style: .delete)
        }
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
