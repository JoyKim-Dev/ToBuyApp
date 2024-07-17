//
//  UserDefaultsManager.swift
//  ToBuyApp
//
//  Created by Joy Kim on 7/11/24.
//

import Foundation

enum UserDefaultKey: String, CaseIterable {
    case nickname
    case profileImage
    case searchKeyWord
    case joinedDate
}
@propertyWrapper
struct UserDefault<T> {
    let key: UserDefaultKey
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key.rawValue)
        }
    }
}

final class UserDefaultManager {
    //    static let shared = UserDefaultManager()
    //    static var nickname: String {
    //        get {
    //            return UserDefaults.standard.string(forKey: UserDefaultKey.nickname.rawValue) ?? ""
    //        }
    //
    //        set {
    //            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.nickname.rawValue)
    //        }
    //    }
    //
    //    static var profileImage: Int {
    //        get{
    //            return UserDefaults.standard.integer(forKey: UserDefaultKey.profileImage.rawValue)
    //        }
    //        set {
    //            UserDefaults.standard.setValue(newValue, forKey: UserDefaultKey.profileImage.rawValue)
    //        }
    //    }
    //
    //    static var searchKeyword: [String] {
    //        get {
    //            return UserDefaults.standard.array(forKey: UserDefaultKey.searchKeyWord.rawValue) as? [String] ?? []
    //        }
    //        set {
    //            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.searchKeyWord.rawValue)
    //        }
    //    }
    //
    //    static var joinedDate: Date {
    //        get{
    //            return UserDefaults.standard.object(forKey: UserDefaultKey.joinedDate.rawValue) as? Date ?? Date()
    //        }
    //        set {
    //            UserDefaults.standard.set(newValue, forKey: UserDefaultKey.joinedDate.rawValue)
    //        }
    static let shared = UserDefaultManager()
    
    @UserDefault(key: .nickname, defaultValue: "")
    static var nickname: String
    
    @UserDefault(key: .profileImage, defaultValue: 0)
    static var profileImage: Int
    
    @UserDefault(key: .searchKeyWord, defaultValue: [])
    static var searchKeyword: [String]
    
    @UserDefault(key: .joinedDate, defaultValue: Date())
    static var joinedDate: Date

    
    func clearUserDefaults() {
        let keys = UserDefaultKey.allCases.map { $0.rawValue }
        
        for i in keys {
            UserDefaults.standard.removeObject(forKey: i)
        }
        UserDefaults.standard.synchronize()
    }
}
