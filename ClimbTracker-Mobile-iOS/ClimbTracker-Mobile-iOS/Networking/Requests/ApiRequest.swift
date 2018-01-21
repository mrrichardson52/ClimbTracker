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

    func decode(_ data: Data) throws -> Resource.Model {
        
        var model: Resource.Model?
        do {
            model = try JSONDecoder().decode(Resource.Model.self, from: data)
        } catch {
            throw error; 
        }
        
        guard let returnModel = model else {
            throw DataLoadingErrors.DecodedModelEmpty
        }
        
        return returnModel;
        
    }

    func load(withCompletion completion: @escaping (() throws -> Model) -> Void) {
        load(resource.url, httpMethod: httpMethod, bodyParams: bodyParams!, withCompletion: completion);
    }
}
