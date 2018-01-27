//
//  ApiResponse.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/15/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

// adopted by all response models
protocol ApiResponseModel: Decodable {
    var errors: [String]? { get }
}

// adopted by all request models
protocol ApiRequestModel: Encodable {
    //func encodeModel() -> Data?
}

