//
//  ApiRequest.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

class ApiRequest<Resource: ApiResource> {
    
    let resource: Resource
    let httpMethod: String
    var bodyParams: Dictionary<String, String>?
    
    init(resource: Resource, httpMethod: String, bodyParams: Dictionary<String, String> = [:]) {
        self.resource = resource;
        self.httpMethod = httpMethod;
        self.bodyParams = bodyParams; 
    }
    
}

extension ApiRequest: NetworkRequest {
        
    func decode(_ data: Data) -> Resource.Model? {
        
        var model: Resource.Model?
        do {
            model = try JSONDecoder().decode(Resource.Model.self, from: data)
        } catch {
            NSLog("Error: %@", error.localizedDescription);
            return nil;
        }
        return model;
        
    }

    func load(withCompletion completion: @escaping (Model?) -> Void) {
        load(resource.url, httpMethod: httpMethod, bodyParams: bodyParams!, withCompletion: completion);
    }
}
