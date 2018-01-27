//
//  LoginResponse.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/21/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct LoginResultResponse: ApiResponseModel {
    
    var errors: [String]?
    var model: LoginResult?
    
}

struct LoginResult: Decodable {
    var token: String
}
