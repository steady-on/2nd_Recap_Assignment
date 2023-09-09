//
//  ProductSearchingViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/09.
//

import UIKit

class ProductSearchingViewController: BaseViewController {
    
    private lazy var webSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "오늘은 뭘 찜해볼까요?"
        searchBar.showsCancelButton = true
        searchBar.returnKeyType = .go
        searchBar.searchTextField.clearButtonMode = .always
        searchBar.tintColor = .label
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
        return MWCollectionView()
    }()
    
    private lazy var indicatorView: MWIndicatorView = {
        return MWIndicatorView()
    }()
    
    private lazy var placeholderView: MWPlaceholderView = {
        return MWPlaceholderView(symbolName: "magnifyingglass", guideText: "원하는 상품을 검색해 주세요!")
    }()
    
    private lazy var noResultView: MWPlaceholderView = {
        return MWPlaceholderView(symbolName: "questionmark", guideText: "검색 결과가 없습니다. \n다른 검색어로 다시 시도해 주세요.")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
    }

    override func configure() {
        super.configure()
        
        title = "상품 검색"
        
        let components = [webSearchBar, sortButtonStackView, searchResultsCollectionView, indicatorView, placeholderView, noResultView]
        components.forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        indicatorView.isHidden = true
        noResultView.isHidden = true
        
        sortButtonGroup.forEach {
            sortButtonStackView.addArrangedSubview($0)
            $0.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        }
        
        webSearchBar.becomeFirstResponder()
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
            noResultView.topAnchor.constraint(equalTo: webSearchBar.bottomAnchor),
            noResultView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            noResultView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            noResultView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func sortButtonTapped(_ sender: UIButton) {
        sortButtonGroup.forEach {
            ($0.tag == sender.tag) ? ($0.isSelected = true) : ($0.isSelected = false)
        }
    }
}