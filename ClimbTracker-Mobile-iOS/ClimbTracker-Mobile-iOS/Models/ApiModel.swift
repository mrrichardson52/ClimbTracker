//
//  ApiResponse.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/15/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

// do not instantiate this class - only inherit from this
protocol ApiModel: Codable {
    
    var errors: [String] { get }

}

