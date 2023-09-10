//
//  NaverSearchAPIManager.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/07.
//

import Foundation

final class NaverSearchAPIManager {
    static let shared = NaverSearchAPIManager()
    
    private init() {}
    
    private let baseURL = "https://openapi.naver.com/v1/search/shop.json"
    private let headers = [
        "X-Naver-Client-Id" : APIKey.naverClientID,
        "X-Naver-Client-Secret" : APIKey.naverClientSecret
    ]
    private let displayItemCount = 30
    
    private var keyword: String = ""
    private var sortType: QuerySortType = .accuracy
    private var start = 1
    private var total = 1000
    
    func search(for keyword: String? = nil, sortedBy sortType: QuerySortType? = nil, nextPage: Bool = false, completionHandler: @escaping (Result<[Item], NetworkError>) -> ()) {
        guard var urlComponents = URLComponents(string: baseURL) else {
            completionHandler(.failure(.invalidRequest))
            return
        }
        
        urlComponents.queryItems = configureParameters(keyword: keyword, sortType: sortType, nextPage: nextPage)
        
        performRequest(for: urlComponents) { (result: Result<QueryResult, NetworkError>) in
            switch result {
            case .success(let queryResult):
                self.total = queryResult.total <= 1000 ? queryResult.total : 1000
                
                DispatchQueue.main.async {
                    completionHandler(.success(queryResult.items))
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func configureParameters(keyword: String?, sortType: QuerySortType?, nextPage: Bool) -> [URLQueryItem] {
        if let keyword, keyword != self.keyword {
            self.keyword = keyword
            self.sortType = .accuracy
            self.start = 1
        }
        
        if let sortType {
            self.sortType = sortType
            self.start = 1
        }
        
        if nextPage {
            start = start + displayItemCount <= total ? start + displayItemCount : total
        }
        
        return [.init(keyword: self.keyword), .init(sortType: self.sortType), .init(displayItemCount: self.displayItemCount), .init(startValue: start)]
    }
    
    private func performRequest<T: Codable>(for urlComponents: URLComponents, completionHandler: @escaping (Result<T, NetworkError>) -> ()) {
        guard let url = urlComponents.url else {
            completionHandler(.failure(.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        var request = URLRequest(url: url, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.notAccessNetwork))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.notAccessNetwork))
                return
            }
            
            guard response.statusCode == 200, let data else {
                if response.statusCode == 500 {
                    completionHandler(.failure(.serverError))
                    return
                }
                
                completionHandler(.failure(.invalidRequest))
                return
            }
            
            guard let decodedData: T = self.parseJSON(data) else {
                completionHandler(.failure(.failToParseJSON))
                return
            }
            
            completionHandler(.success(decodedData))
        }
        
        task.resume()
    }
    
    private func parseJSON<T: Codable> (_ jsonData: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(T.self, from: jsonData)
            return decodedData
        } catch {
            return nil
        }
    }
}
