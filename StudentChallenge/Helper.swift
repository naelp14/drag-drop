//
//  Helper.swift
//  StudentChallenge
//
//  Created by Nathaniel Putera on 05/02/25.
//

import Foundation

extension UserDefaults {
    func getArray(forKey key: String) -> [String] {
        if let data = data(forKey: key), let array = try? JSONDecoder().decode([String].self, from: data) {
            return array
        }
        return []
    }

    func setArray(_ array: [String], forKey key: String) {
        if let data = try? JSONEncoder().encode(array) {
            set(data, forKey: key)
        }
    }
}
