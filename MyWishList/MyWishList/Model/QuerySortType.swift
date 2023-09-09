//
//  QuerySortType.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/08.
//

import Foundation

enum QuerySortType: Int, CaseIterable {
    case accuracy = 1
    case date
    case ascending
    case descending
    
    var value: String {
        switch self {
        case .accuracy: return "sim"
        case .date: return "date"
        case .ascending: return "asc"
        case .descending: return "dsc"
        }
    }
    
    var labelText: String {
        switch self {
        case .accuracy: return "정확도순"
        case .date: return "최신순"
        case .ascending: return "오름차순"
        case .descending: return "내림차순"
        }
    }
}
