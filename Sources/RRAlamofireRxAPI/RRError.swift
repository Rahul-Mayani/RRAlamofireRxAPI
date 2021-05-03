//
//  RRError.swift
//  RRAlamofireRxAPI
//
//  Created by Rahul Mayani on 03/05/21.
//

import Foundation

public enum RRError: LocalizedError {
    case unauthorized
    case noInternetConnection

    public var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "Access is denied. User is unauthorized."
        case .noInternetConnection:
            return "Please check your internet connection and try again later."
        }
    }
}
