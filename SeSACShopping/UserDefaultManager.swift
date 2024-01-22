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
    
    /*
     다음 함수를 실행해도 프로젝트를 다시 실행시키면 userdefault 값이 남아있다(?)는 문제가 있습니다.
     프로젝트를 실행하고 run인 상태에서 마이페이지에서 '처음부터 시작하기' 버튼을 누르면 온보딩 화면으로 넘어가면서 userdefault 값이 삭제되는데,
     온보딩 화면에서 프로젝트를 종료하고 다시 실행시키면 userdefault가 그대로 남아있어서 메인페이지에서 시작하게 됩니다.ㅠㅠ
     이게 정상적인건가요?
    */
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
