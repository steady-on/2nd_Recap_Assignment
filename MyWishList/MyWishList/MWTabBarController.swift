//
//  ViewController.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/07.
//

import UIKit

class MWTabBarController: UITabBarController {
    
    private lazy var productSearchingViewController = ProductSearchingViewController()
    private lazy var wishListViewController = WishListViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
    }

    func configureTabBar() {
        tabBar.tintColor = .label
        
        productSearchingViewController.tabBarItem.title = "상품 검색"
        productSearchingViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        wishListViewController.tabBarItem.title = "나의찜목록"
        wishListViewController.tabBarItem.image = UIImage(systemName: "heart")
        wishListViewController.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        
        let viewControllers = [productSearchingViewController, wishListViewController].map {
            UINavigationController(rootViewController: $0)
        }
        
        setViewControllers(viewControllers, animated: true)
    }
}

