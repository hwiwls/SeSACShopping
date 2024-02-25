//
//  ProfileSettingViewModel.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 2/25/24.
//

import Foundation

enum ValidationError: Error {
    case emptyString    // 빈 문자열
    case isCharLimit    // 글자수 제한(2글자~10글자)
    case specialChar    // 특수문자
    case isNumber      // 숫자
}

class ProfileSettingViewModel {
    var inputNickname = Observable("")
    var outputValidation = Observable("")   // 검증 결과
    var outputValidColor = Observable(false)
    var outputEnable = Observable(false)    // 버튼 활성화
    var validationError = Observable<ValidationError?>(nil) // 검증 에러
    var userState = Observable(false)   // 처음 가입하는 회원인지 아닌지
    
    init() {
        print("viewModel init")
        
        inputNickname.value = UserDefaultManager.shared.nickname
        
        inputNickname.bind { value in
            print("nickname validation")
            do {
                _ = try self.validation(nickname: value)
                self.outputValidation.value = "사용할 수 있는 닉네임이에요"
                self.outputValidColor.value = true
                self.outputEnable.value = true
                self.saveUserState(nickname: value, state: true)
            } catch {
                self.validationError.value = error as? ValidationError
                self.outputValidColor.value = false
                self.outputEnable.value = false
                self.saveUserState(nickname: value, state: false)
            }
        }
        
        validationError.bind { error in
            guard let error = error else { return }
            switch error {
            case .emptyString:
                self.outputValidation.value = "닉네임을 입력해주세요"
            case .isCharLimit:
                self.outputValidation.value = "2글자 이상 10글자 미만으로 설정해주세요"
            case .specialChar:
                self.outputValidation.value = "닉네임에 @, #, $, %는 포함할 수 없어요"
            case .isNumber:
                self.outputValidation.value = "닉네임에 숫자는 포함할 수 없어요"
            }
        }
    }
    
    private func validation(nickname: String) throws -> Bool {
        let specialChar = ["@", "#", "$", "%"]
        
        guard !(nickname.isEmpty) else {
            print("empty")
            throw ValidationError.emptyString
        }
        
        guard (nickname.count > 1 && nickname.count < 10) else {
            print("isCharLimit")
            throw ValidationError.isCharLimit
        }
        
        guard !(nickname.contains(where: { $0.isNumber })) else {
            print("isNumber")
            throw ValidationError.isNumber
        }
        
        guard !(specialChar.contains(where: nickname.contains)) else {
            print("specialChar")
            throw ValidationError.specialChar
        }
        
        return true
    }
    
    private func saveUserState(nickname: String, state: Bool) {
        UserDefaultManager.shared.nickname = nickname
        UserDefaultManager.shared.userState = state
        userState.value = state
    }
    
}
