//
//  AppConstants.swift
//  AppConstants
//
//  Created by Prashant Bashishth on 27/08/23.
//

import UIKit

public struct AppConstants {
    static let fetchInterval = 10.0
    static let jokesDefault = "jokesDefaultKey"
    static let maxRowCount = 10
    static let apiBaseURL = "https://geek-jokes.sameerkumar.website/api"
}

extension UserDefaults {
    func decode<T : Codable>(for type : T.Type, using key : String) -> T? {
        let defaults = UserDefaults.standard
        guard let data = defaults.object(forKey: key) as? Data else {return nil}
        let decodedObject = try? PropertyListDecoder().decode(type, from: data)
        return decodedObject
    }
    
    func encode<T : Codable>(for type : T, using key : String) {
        let defaults = UserDefaults.standard
        let encodedData = try? PropertyListEncoder().encode(type)
        defaults.set(encodedData, forKey: key)
    }
}

