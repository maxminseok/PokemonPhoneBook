//
//  PhoneBookEditDelegate.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/12/24.
//

import UIKit

/// 연락처 추가, 수정, 삭제를 위한 프로토콜
protocol PhoneBookEditDelegate: AnyObject {
    
    /// 연락처 데이터를 수정하는 메서드
    /// - Parameters:
    ///   - editedPhoneBook: 수정된 연락처 데이터
    ///   - index: 수정된 연락처 데이터의 위치
    func editPhoneBook(_ editedPhoneBook: PhoneBook, at index: Int)
    
    /// 연락처 데이터를 새로 추가하는 메서드
    /// - Parameter newPhoneBook: 새로 추가된 연락처 데이터
    func addNewPhoneBook(_ newPhoneBook: PhoneBook)
    
    /// 연락처 데이터를 삭제하는 메서드
    /// - Parameter index: 삭제할 연락처의 위치
    func deletePhoneBook(at index: Int)
}
