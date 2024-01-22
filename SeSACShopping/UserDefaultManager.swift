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
        case userState  // 회원 가입 상태 유무. true일 경우 가입 완료
        case likeProduct   // 상품 좋아요
        case isSetting    // 프로필 설정, 프로필 편집 구별
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
            ud.string(forKey: UDKey.nickname.rawValue) ?? ""
        }
        set {
            ud.setValue(newValue, forKey: UDKey.nickname.rawValue)
        }
    }
    
    var recentSearchWords: [String] {
        get {
            ud.array(forKey: UDKey.recentSearchWords.rawValue) as? [String] ?? []
        }
        set {
            ud.setValue(newValue, forKey: UDKey.recentSearchWords.rawValue)
        }
    }
    
    var userState: Bool {
        get {
            ud.bool(forKey: UDKey.userState.rawValue)
        }
        set {
            ud.setValue(newValue, forKey: UDKey.userState.rawValue)
        }
    }
    
    var likeProduct: [String] {
        get {
            ud.array(forKey: UDKey.likeProduct.rawValue) as? [String] ?? []
        }
        set {
            ud.setValue(newValue, forKey: UDKey.likeProduct.rawValue)
        }
    }
    
    var isSetting: Bool {
        get {
            ud.bool(forKey: UDKey.isSetting.rawValue)
        }
        set {
            ud.setValue(newValue, forKey: UDKey.isSetting.rawValue)
        }
    }

    func removeSelectedImage() {  // 선택한 프로필 이미지를 삭제
        ud.removeObject(forKey: UDKey.selectedImage.rawValue)
    }
    
    func removeNickname() {  // 유저 이름 삭제
        ud.removeObject(forKey: UDKey.nickname.rawValue)
    }
    
    func removeRecentSearchWords() {  // 검색 기록 삭제
        ud.removeObject(forKey: UDKey.recentSearchWords.rawValue)
    }
    
    func removeAll() {
        ud.removeObject(forKey: UDKey.selectedImage.rawValue)
        ud.removeObject(forKey: UDKey.nickname.rawValue)
        ud.removeObject(forKey: UDKey.recentSearchWords.rawValue)
        ud.removeObject(forKey: UDKey.likeProduct.rawValue)
        ud.removeObject(forKey: UDKey.userState.rawValue)
    }
    
    func updateLikeProduct(productId: String) {
        if let index = likeProduct.firstIndex(of: productId) {  // 좋아요 누른 상품 인덱스 구분
            // 이미 좋아요한 상품이라면 제거
            likeProduct.remove(at: index)
        } else {
            // 새로운 좋아요 상품이라면 추가
            likeProduct.append(productId)
        }
    }
}
