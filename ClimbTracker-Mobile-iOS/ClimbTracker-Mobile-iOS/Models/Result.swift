//
//  Result.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/21/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct ResultResponse: ApiResponseModel {
    
    var errors: [String]?
    var model: Result?
    
}

struct Result: Decodable {
    var success: Bool
}

