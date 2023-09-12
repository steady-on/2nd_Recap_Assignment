//
//  ProductSearchingViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/09.
//

import UIKit
import RealmSwift

class ProductSearchingViewController: BaseViewController {
    
    private let dataStorage = DataStorage.shared
    
    lazy var wishItemRepository = WishItemRepository()
    
    private lazy var webSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "오늘은 뭘 찜해볼까요?"
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .go
        searchBar.searchTextField.clearButtonMode = .always
        searchBar.tintColor = .label
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var sortButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var sortButtonGroup: [UIButton] = {
        var buttonGroup = [UIButton]()
        
        for sortType in QuerySortType.allCases {
            let button = MWToggleButton(title: sortType.labelText, color: .label)
            button.tag = sortType.rawValue
            buttonGroup.append(button)
        }
        
        return buttonGroup
    }()
    
    private lazy var searchResultsCollectionView: MWCollectionView = {
        let collectionView = MWCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    private lazy var indicatorView: MWIndicatorView = {
        return MWIndicatorView()
    }()
    
    private lazy var placeholderView: MWPlaceholderView = {
        return MWPlaceholderView(symbolName: "magnifyingglass", guideText: "원하는 상품을 검색해 주세요!")
    }()
    
    private lazy var emptySearchResultView: MWPlaceholderView = {
        return MWPlaceholderView(symbolName: "questionmark", guideText: "검색 결과가 없습니다. \n다른 검색어로 다시 시도해 주세요.")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchResultsCollectionView.reloadData()
    }

    override func configure() {
        super.configure()
        
        definesPresentationContext = true
        title = "상품 검색"
        
        composeView()
    }
    
    private func composeView() {
        let components = [webSearchBar, sortButtonStackView, searchResultsCollectionView, placeholderView, emptySearchResultView, indicatorView]
        components.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        indicatorView.isHidden = true
        emptySearchResultView.isHidden = true
        
        sortButtonGroup.forEach {
            sortButtonStackView.addArrangedSubview($0)
            $0.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
    }
    
    override func setConstraints() {
        NSLayoutConstraint.activate([
            webSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webSearchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webSearchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sortButtonStackView.topAnchor.constraint(equalTo: webSearchBar.bottomAnchor, constant: 8),
            sortButtonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            sortButtonStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            searchResultsCollectionView.topAnchor.constraint(equalTo: sortButtonStackView.bottomAnchor, constant: 8),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: searchResultsCollectionView.topAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: searchResultsCollectionView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: searchResultsCollectionView.trailingAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: searchResultsCollectionView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: webSearchBar.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptySearchResultView.topAnchor.constraint(equalTo: webSearchBar.bottomAnchor),
            emptySearchResultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            emptySearchResultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            emptySearchResultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        webSearchBar.resignFirstResponder()
        
        sortButtonGroup.forEach {
            ($0.tag == sender.tag) ? ($0.isSelected = true) : ($0.isSelected = false)
        }
        
        indicatorView.isHidden = false
        
        let querySortType = QuerySortType(from: sender.tag)
        NaverSearchAPIManager.shared.search(sortedBy: querySortType) { result in
            switch result {
            case .success(let items):
                self.dataStorage.storeData(items)
            case .failure(let error):
                self.presentErrorAlert(error)
                self.dataStorage.storeData([])
            }
            
            self.updateViewToQueryResult()
        }
    }
    
    private func updateViewToQueryResult() {
        searchResultsCollectionView.reloadData()

        emptySearchResultView.isHidden = !dataStorage.webQueryResults.isEmpty
        
        if dataStorage.webQueryResults.isEmpty == false {
            searchResultsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
        indicatorView.isHidden = true
    }
}

extension ProductSearchingViewController: UISearchBarDelegate {
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
        webSearchBar.resignFirstResponder()
        
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespaces)
        searchBar.text = trimmedKeyword
        
        sortButtonGroup.forEach { $0.isSelected = false }
        sortButtonGroup.first?.isSelected = true
        
        placeholderView.isHidden = true
        indicatorView.isHidden = false
        
        NaverSearchAPIManager.shared.search(for: trimmedKeyword) { result in
            switch result {
            case .success(let items):
                self.dataStorage.storeData(items)
            case .failure(let error):
                self.dataStorage.storeData([])
                self.presentErrorAlert(error)
            }
            
            self.updateViewToQueryResult()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        webSearchBar.resignFirstResponder()
    }
}

extension ProductSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataStorage.webQueryResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MWCollectionViewCell.identifier, for: indexPath) as? MWCollectionViewCell else { return UICollectionViewCell() }
        
        cell.item = dataStorage.webQueryResults[indexPath.item]
        
        cell.saveImageDataCompletionHandler = { data in
            self.dataStorage.storeImageData(at: indexPath, imageData: data)
        }
        
        cell.toggleWishButtonCompletionHandler = { result in
            switch result {
            case .success(_):
                collectionView.reloadItems(at: [indexPath])
            case .failure(let error):
                self.presentErrorAlert(error)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailWebView = ProductDetailWebViewController() {
            collectionView.reloadItems(at: [indexPath])
        }
        
        productDetailWebView.indexPath = indexPath
        
        navigationController?.pushViewController(productDetailWebView, animated: true)
    }
}

extension ProductSearchingViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths where indexPath.item == dataStorage.webQueryResults.count - 2 {
            
            indicatorView.isHidden = false
            
            NaverSearchAPIManager.shared.search(nextPage: true) { result in
                switch result {
                case .success(let items):
                    self.dataStorage.addData(items)
                case .failure(let error):
                    self.presentErrorAlert(error)
                }
                
                self.indicatorView.isHidden = true
                self.searchResultsCollectionView.reloadData()
            }
        }
    }
}
