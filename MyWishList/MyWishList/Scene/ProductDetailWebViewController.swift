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
    
    var toggleWishButtonCompletionHandler: (() -> ())?
    
    private lazy var webView: WKWebView = WKWebView()
    
    init(link: String) {
        super.init()
        self.link = link
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(toggleWishButtonTapped)
    }
    
    @objc private func toggleWishButtonTapped() {
        toggleWishButtonCompletionHandler?()
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
