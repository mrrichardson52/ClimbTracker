//
//  NetworkRequest.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

protocol NetworkRequest: class {
    
    associatedtype Model: Codable
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
}

extension NetworkRequest {
    
    func load(_ url: URL, httpMethod: String, bodyParams: [String : String], withCompletion completion: @escaping (Model?) -> Void) {
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0);
        request.httpMethod = httpMethod;
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParams, options: .sortedKeys);
        } catch {
            // do nothing for now
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self?.decode(data))
        })
        task.resume()
        
    }
    
}
