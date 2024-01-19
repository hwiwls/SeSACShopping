//
//  UserDefaultManager.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 1/19/24.
//

import Foundation

class UserDefaultManager {
    // ud 같은 애들이 shared를 통해서만 'UserDefaultManager()' 사용할 수 있어짐
    private init() {
        
    }
    
    // 인스턴스 생성과 상관 없이 언제든지 접근할 수 있는 공간. 한 공간만 차지해서 사용. 효율적.
    static let shared = UserDefaultManager()
    
    enum UDKey: String {
        case selectedImage
    }
    
    let ud = UserDefaults.standard
    
    var selectedImage: String {
        get {
            ud.string(forKey: UDKey.selectedImage.rawValue) ?? "profile1"
        }
        set {
            ud.setValue(newValue, forKey: UDKey.selectedImage.rawValue)
        }
    }
    
}
