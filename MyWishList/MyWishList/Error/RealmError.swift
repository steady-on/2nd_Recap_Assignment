//
//  RealmError.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/10.
//

import Foundation

enum RealmError: Error {
    case notInitialized
    case failToCreateItem
    case failToFetchTable
    case failToUpdateItem
    case failToDelete
    case failToQuery
    
    var description: String {
        switch self {
        case .notInitialized:
            return "데이터 저장 공간 초기화에 문제가 생겼습니다."
        case .failToCreateItem:
            return "데이터를 추가하는 도중 문제가 발생했습니다. 다시 시도해 주세요."
        case .failToFetchTable:
            return "데이터를 가져오는 도중 문제가 발생했습니다. 잠시 후 다시 시도해 주세요."
        case .failToUpdateItem:
            return "데이터를 업데이트 하는 도중 문제가 발생했습니다. 다시 시도해 주세요."
        case .failToDelete:
            return "데이터를 삭제하는 도중 문제가 발생했습니다. 다시 시도해 주세요."
        case .failToQuery:
            return "해당하는 데이터를 발견하지 못했습니다."
        }
    }
}

extension RealmError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(self.description, comment: "")
    }
}
