//
//  SessionInfo.swift
//  ClimbTracker-Mobile-iOS
//
//  Created by Matthew Richardson on 1/21/18.
//  Copyright © 2018 Matthew Richardson. All rights reserved.
//

import UIKit

struct SessionInfoResponse: ApiResponseModel {
    
    var errors: [String]?
    var model: SessionInfo?

}

struct SessionInfo: Decodable, ApiRequestModel {
    var energyBefore: Int?
    var energyAfter: Int?
}
