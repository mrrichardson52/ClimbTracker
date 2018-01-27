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
    
    associatedtype ResponseModel: Decodable
    associatedtype RequestModel: Encodable
    func load(withCompletion completion: @escaping (() throws -> ResponseModel) -> Void)
    func decode(_ data: Data) throws -> ResponseModel
}

extension NetworkRequest {
    
    func load(_ url: URL, httpMethod: String, requestModel: RequestModel?, withCompletion completion: @escaping (() throws -> ResponseModel) -> Void) {
        
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0);
        request.httpMethod = httpMethod;
        do {
            if let model = requestModel {
                request.httpBody = try JSONEncoder().encode(model);
            }
        } catch {
            // do nothing for now
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // add token to authorization header if it exists
        let defaults = UserDefaults();
        if let token = defaults.value(forKey: ViewController.TOKEN_KEY) as? String {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
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
