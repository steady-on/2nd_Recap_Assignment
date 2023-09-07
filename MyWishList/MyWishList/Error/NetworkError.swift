//
//  NetworkError.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/07.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case notAccessNetwork
    case invalidRequestError
    case serverError
    case jsonParseError
    
    var description: String {
        switch self {
        case .notAccessNetwork:
            return "네트워크에 연결할 수 없습니다. 네트워크 상태 확인 후 다시 시도해 주세요."
        case .invalidRequestError:
            return "잘못된 요청입니다. 다른 검색어를 입력해주세요."
        case .serverError:
            return "서버에 문제가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .jsonParseError:
            return "데이터를 가져오는 도중 문제가 발생했습니다."
        }
    }
}
