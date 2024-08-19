//
//  KeychainManager.swift
//  Gourmet
//
//  Created by 최승범 on 8/19/24.
//

import Security
import Foundation

enum KeychainKey: String {
    case accessToken
    case refreshToken
}

final class KeychainManager {

    static let shared = KeychainManager()

    private init() {}

    func save(_ value: String,
              forKey key: String) {
        
        delete(forKey: key)

        guard let data = value.data(using: .utf8) else { return }

        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecValueData : data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)

        assert(status == errSecSuccess,
               "키체인 저장 실패: \(status)")
    }

    func delete(forKey key: String) {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key
        ]

        let status = SecItemDelete(query as CFDictionary)

        assert(status == errSecSuccess ||
               status == errSecItemNotFound,
               "키체인 삭제 실패: \(status)")
    }

    func load(forKey key: String) -> String? {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : key,
            kSecReturnData : true,
            kSecMatchLimit : kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess,
              let retrievedData = dataTypeRef as? Data,
              let value = String(data: retrievedData, encoding: .utf8) else { return nil }

        return value
    }
}
