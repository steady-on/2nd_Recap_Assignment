//
//  WishListViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/11.
//

import UIKit
import RealmSwift

class WishListViewController: BaseViewController {
    
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
    }
    
    override func configure() {
        super.configure()
        wishList = wishItemRepository.fetchTable()
        
        definesPresentationContext = true
        
        configureNavigationBar()
        composeView()
        
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
        
        if wishList.isEmpty == false {
            emptyWishLishView.isHidden = true
        }
    }
    
    private func configureNavigationBar() {
        title = "위시리스트"
        navigationItem.searchController = wishListSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
        
        cell.wishItem = wishList[indexPath.item]
        cell.toggleWishButtonCompletionHanler = { result in
            switch result {
            case .success(_):
                collectionView.reloadData()
            case .failure(let error):
                self.presentErrorAlert(error)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wishItem = wishList[indexPath.item]
        
        let productDetailWebView = ProductDetailWebViewController(link: wishItem.link, title: wishItem.title, isWish: true) { isInWish in
            guard isInWish == false else { return }
            
            do {
                try self.wishItemRepository.delete(wishItem)
            } catch {
                self.presentErrorAlert(error)
            }
            
            collectionView.reloadData()
        }
        
        navigationController?.pushViewController(productDetailWebView, animated: true)
    }
}
