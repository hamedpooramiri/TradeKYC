//
//  URLRequest+Helpers.swift
//  APIModule
//
//  Created by hamedpouramiri on 1/3/24.
//

import Foundation

extension URLRequest {
    mutating func setHeaderField(_ field: [String: String]?) {
        field?.forEach{ key, value in
            setValue(value, forHTTPHeaderField: key)
        }
    }
}
