//
//  NetworkMonitor.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/17.
//

import Foundation
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor = NWPathMonitor()
    
    var currentStatus: NWPath.Status {
        monitor.currentPath.status
    }
    
    private init() {}
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func networkStatusUpdateHandler(handler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.sync {
                handler(path.status)
            }
        }
    }
}
