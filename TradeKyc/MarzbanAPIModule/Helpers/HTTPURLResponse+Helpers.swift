//
//  HTTPURLResponse+Helpers.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation

public extension HTTPURLResponse {
    var isValidationError: Bool {
        statusCode == 422
    }
    
    var isUnAuthorizedError: Bool {
        statusCode == 403
    }
    
    var isNotFoundError: Bool {
        statusCode == 404
    }
    
    var isUserAlreadyExists: Bool {
        statusCode == 409
    }
}
