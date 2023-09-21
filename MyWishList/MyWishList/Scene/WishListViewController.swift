//
//  WishListViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/11.
//

import UIKit
import RealmSwift

final class WishListViewController: BaseViewController {
    
    private lazy var wishItemRepository = WishItemRepository()
    
    private var wishList: Results<WishItem>!
    
    private lazy var wishListSearchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "찜한 상품에서 검색"
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.returnKeyType = .go
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var emptyWishLishView: MWPlaceholderView = {
        return MWPlaceholderView(symbolName: "archivebox", guideText: "아직 찜한 상품이 없어요.\n상품 검색 화면에서 상품을 찜해보세요!")
    }()
    
    private lazy var wishListCollectionView: MWCollectionView = {
        let collectionView = MWCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var indicatorView: MWIndicatorView = {
        return MWIndicatorView()
    }()
    
    private lazy var emptySearchResultView: MWPlaceholderView = {
        return MWPlaceholderView(symbolName: "questionmark", guideText: "찜한 상품에서 찾을 수 없어요.\n상품 검색에서 찜하러 가볼까요?")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkMonitor.shared.networkStatusUpdateHandler { [weak self] connectionStatus in
            switch connectionStatus {
            case .satisfied, .requiresConnection:
                break
            case .unsatisfied:
                self?.presentNetworkDisconnectStatus()
            @unknown default:
                self?.presentNetworkDisconnectStatus()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wishList = wishItemRepository.fetchTable()
        emptyWishLishView.isHidden = !wishList.isEmpty
        wishListCollectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
        definesPresentationContext = true
        
        configureNavigationBar()
        composeView()
        
        switch NetworkMonitor.shared.currentStatus {
        case .satisfied, .requiresConnection:
            break
        case .unsatisfied:
            presentNetworkDisconnectStatus()
        @unknown default:
            presentNetworkDisconnectStatus()
        }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            wishListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            wishListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            wishListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            wishListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyWishLishView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyWishLishView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptyWishLishView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptyWishLishView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptySearchResultView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptySearchResultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptySearchResultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptySearchResultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func composeView() {
        let components = [wishListCollectionView, emptyWishLishView, emptySearchResultView, indicatorView]
        
        components.forEach { component in
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }
        
        indicatorView.isHidden = true
        emptySearchResultView.isHidden = true
    }
    
    private func configureNavigationBar() {
        title = "나의찜목록"
        navigationItem.searchController = wishListSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func presentNetworkDisconnectStatus() {
        let alert = UIAlertController(title: "인터넷에 연결되지 않았어요", message: "오프라인 상태에서는 찜한 아이템의 사진이 보이지 않을 수 있으며, 찜목록 확인과 삭제만 가능합니다.", preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "알겠어요!", style: .cancel)
        
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}

extension WishListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText == " " ? "" : searchText
        
        var trimmedSuffixString = searchText
        
        if searchText.hasSuffix("  ") {
            trimmedSuffixString.removeLast()
        }
        
        searchBar.text = trimmedSuffixString
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespaces)
        searchBar.text = trimmedKeyword
        
        wishList = wishItemRepository.queryTable(for: keyword)
        wishListCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        wishList = wishItemRepository.fetchTable()
        wishListCollectionView.reloadData()
    }
}

extension WishListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else { return }
        
        wishList = wishItemRepository.queryTable(for: keyword)
        wishListCollectionView.reloadData()
    }
}

extension WishListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MWCollectionViewCell.identifier, for: indexPath) as? MWCollectionViewCell else { return UICollectionViewCell() }
        
        let item = Item(from: wishList[indexPath.item])
        
        cell.item = item
        cell.completionHandler = {
            collectionView.reloadData()
            self.emptyWishLishView.isHidden = !self.wishList.isEmpty
        }
        cell.errorHandler = { error in self.presentErrorAlert(error) }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = Item(from: wishList[indexPath.item])
        
        let productDetailWebView = ProductDetailWebViewController(item: item)
        
        navigationController?.pushViewController(productDetailWebView, animated: true)
    }
}
