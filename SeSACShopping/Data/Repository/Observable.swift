//
//  Observable.swift
//  SeSACShopping
//
//  Created by hwijinjeong on 2/25/24.
//

import Foundation

// 목적: 실시간으로 달라지는 데이터 감지
class Observable<T> {
    
    private var closure: ((T) -> Void)?  // 현재 value 값을 받아와서 실행
    
    var value: T {
        didSet {
            closure?(value) // 값이 바뀔 때마다 closure 실행
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {   // clousure 함수 기능 설정
        closure(value)
        self.closure = closure
    }
    
}
