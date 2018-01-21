//
//  NetworkRequest.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

enum DataLoadingErrors: Error {
    case Unauthorized
    case NoDataReturned
    case DecodedModelEmpty
}

protocol NetworkRequest: class {
    
    associatedtype Model: Codable
    func load(withCompletion completion: @escaping (() throws -> Model) -> Void)
    func decode(_ data: Data) throws -> Model
}

extension NetworkRequest {
    
    func load(_ url: URL, httpMethod: String, bodyParams: [String : String], withCompletion completion: @escaping (() throws -> Model) -> Void) {
        
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
            // check for errors
            if (error != nil) {
                completion({
                    throw error!;
                });
                return;
            }
            
            // check the status code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 401:
                    completion({
                        throw DataLoadingErrors.Unauthorized
                    })
                    break;
                default:
                    break;
                }
            }
            
            // prase the data into the model type
            guard let data = data else {
                completion({
                    throw DataLoadingErrors.NoDataReturned;
                });
                return
            }
            
            completion({
                do {
                    guard let model = try self?.decode(data) else {
                        throw DataLoadingErrors.DecodedModelEmpty
                    }
                    return model
                } catch {
                    throw error;
                }
            });

        })
        task.resume()
        
    }
    
}
