//
//  PhoneBook.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/6/24.
//

import Foundation

/// 연락처 데이터를 저장할 구조체
struct PhoneBook: Codable {
    let name: String
    let phoneNumber: String
    let image: Data
}
