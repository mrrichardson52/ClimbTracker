//
//  ApiResource.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/14/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

protocol ApiResource {
    associatedtype Model: Codable
    var methodPath: String { get }
}

extension ApiResource {
    
    var url: URL {
        let baseUrl = "http://192.168.0.100:3000"
        let url = baseUrl + methodPath
        return URL(string: url)!
    }

}
