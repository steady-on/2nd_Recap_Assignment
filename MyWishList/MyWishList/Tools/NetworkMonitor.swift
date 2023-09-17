//
//  NetworkMonitor.swift
//  MyWishList
//
//  Created by Roen White on 2023/09/17.
//

import Foundation
import Network

final class NetworkMonitor {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    init() {
        self.monitor = NWPathMonitor()
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.sync {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
