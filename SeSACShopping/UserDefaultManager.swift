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
    
    // 키를 저장하는 enum
    enum UDKey: String {
        case selectedImage  // 프로필 사진
        case nickname   // 유저 이름
        case recentSearchWords   // 최근 검색어
    }
    
    let ud = UserDefaults.standard
    
    var selectedImage: String {
        get {   // 선택한 이미지를 불러온다
            ud.string(forKey: UDKey.selectedImage.rawValue) ?? "profile1"
        }
        set {   // 선택한 이미지를 저장한다
            ud.setValue(newValue, forKey: UDKey.selectedImage.rawValue)
        }
    }
    
    var nickname: String {
        get {
            ud.string(forKey: UDKey.nickname.rawValue) ?? "사용자1"
        }
        set {
            ud.setValue(newValue, forKey: UDKey.nickname.rawValue)
        }
    }
    
    var recentSearchWords: [String] {  // 배열로 변경된 부분
        get {
            ud.array(forKey: UDKey.recentSearchWords.rawValue) as? [String] ?? []
        }
        set {
            ud.setValue(newValue, forKey: UDKey.recentSearchWords.rawValue)
        }
    }
    
    func removeSelectedImage() {  // 선택한 프로필 이미지를 삭제
        ud.removeObject(forKey: UDKey.selectedImage.rawValue)
    }
    
    func removeNickname() {  // 유저 이름 삭제
        ud.removeObject(forKey: UDKey.nickname.rawValue)
    }
    
    
}
