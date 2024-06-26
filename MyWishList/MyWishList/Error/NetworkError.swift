//
//  NetworkError.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/07.
//

import Foundation

enum NetworkError: Error {
    case notAccessNetwork
    case invalidRequest
    case serverError
    case failToParseJSON
    
    var description: String {
        switch self {
        case .notAccessNetwork:
            return "네트워크에 연결할 수 없습니다. 네트워크 상태 확인 후 다시 시도해 주세요."
        case .invalidRequest:
            return "잘못된 요청입니다. 다른 검색어를 입력해주세요."
        case .serverError:
            return "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .failToParseJSON:
            return "데이터를 가져오는 도중 문제가 발생했습니다."
        }
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        return NSLocalizedString(self.description, comment: "")
    }
}
