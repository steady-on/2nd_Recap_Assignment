//
//  URLQueryItem+.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import Foundation

extension URLQueryItem {
    init(displayItemCount: Int) {
        self.init(name: "display", value: "\(displayItemCount)")
    }
    
    init(sortType: QuerySortType) {
        self.init(name: "sort", value: sortType.value)
    }
    
    init(startValue: Int) {
        self.init(name: "start", value: "\(startValue)")
    }
    
    init(keyword: String) {
        self.init(name: "query", value: keyword)
    }
}
