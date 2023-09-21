//
//  ProductDetailWebViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import UIKit
import WebKit

final class ProductDetailWebViewController: BaseViewController {
        
    private var item: Item {
        didSet {
            navigationItem.rightBarButtonItem?.image = wishButtonImage
        }
    }
    
    private var wishButtonImage: UIImage? {
        return item.isInWishList ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    private lazy var webView: WKWebView = WKWebView()
    private lazy var wishItemRepository = WishItemRepository()
    
    init(item: Item) {
        self.item = item
        
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkMonitor.shared.networkStatusUpdateHandler { [weak self] connectionStatus in
            print(connectionStatus)
            switch connectionStatus {
            case .satisfied:
                self?.requestProductLink()
            case .unsatisfied:
                self?.presentNetworkDisconnectStatus()
            case .requiresConnection:
                break
            @unknown default:
                self?.presentNetworkDisconnectStatus()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        item.isInWishList = wishItemRepository.checkItemInTable(for: item.productID) != nil
    }
    
    override func configure() {
        super.configure()
        configureNavigationBar()
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        switch NetworkMonitor.shared.currentStatus {
        case .satisfied:
            requestProductLink()
        case .unsatisfied:
            presentNetworkDisconnectStatus()
        case .requiresConnection:
            break
        @unknown default:
            presentNetworkDisconnectStatus()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: wishButtonImage, style: .plain, target: self, action: #selector(toggleWishButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
    }
    
    @objc private func toggleWishButtonTapped() {
        let result = DataStorage.shared.toggleStatusOfIsInWish(for: item)
        
        switch result {
        case .success(let item):
            self.item = item
        case .failure(let error):
            presentErrorAlert(error)
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
    
    private func requestProductLink() {
        guard let url = URL(string: item.link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
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
    
    override func presentNetworkDisconnectStatus() {
        let alert = UIAlertController(title: "인터넷에 연결되지 않았어요", message: "선택하신 상품의 정보를 불러올 수 없습니다.", preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "알겠어요!", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}
