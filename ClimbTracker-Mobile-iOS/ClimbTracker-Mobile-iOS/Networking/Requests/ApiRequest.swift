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
    var requestModel: Resource.RequestModel?
    
    init(resource: Resource, httpMethod: String, requestModel: Resource.RequestModel?) {
        self.resource = resource;
        self.httpMethod = httpMethod;
        self.requestModel = requestModel;
    }
    
}

extension ApiRequest: NetworkRequest {
    
    typealias ResponseModel = Resource.ResponseModel
    
    typealias RequestModel = Resource.RequestModel
    
    func decode(_ data: Data) throws -> Resource.ResponseModel {
        var model: Resource.ResponseModel?
        do {
            model = try JSONDecoder().decode(Resource.ResponseModel.self, from: data)
        } catch {
            throw error; 
        }
        guard let returnModel = model else {
            throw DataLoadingErrors.DecodedModelEmpty
        }
        return returnModel;
    }

    func load(withCompletion completion: @escaping (() throws -> Resource.ResponseModel) -> Void) {
        load(self.resource.url, httpMethod: self.httpMethod, requestModel: self.requestModel, withCompletion: completion);
    }
}
