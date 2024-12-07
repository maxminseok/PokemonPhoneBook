//
//  PhoneBook.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/6/24.
//

import Foundation

struct PhoneBook {
    let name: String
    let phoneNumber: String
    let image: String
}

struct PokemonData: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: UrlImage
}

struct UrlImage: Codable {
    let front_default: String
}
