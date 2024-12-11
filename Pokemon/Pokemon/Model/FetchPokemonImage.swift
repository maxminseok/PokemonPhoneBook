//
//  FetchPokemonImage.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/11/24.
//

import UIKit

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

class PhoneBookService {
    static let shared = PhoneBookService()
    private init() {}
    
    func fetchPokemonImage(completion: @escaping (UIImage?) -> Void) {
        let randomNumber = Int.random(in: 1...1000)
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/"+"\(randomNumber)")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            
            let suceessRange = 200..<300
            if let response = response as? HTTPURLResponse, suceessRange.contains(response.statusCode) {
                if let result = try? JSONDecoder().decode(PokemonData.self, from: data),
                   let imageUrl = URL(string: result.sprites.front_default),
                   let imageData = try? Data(contentsOf: imageUrl),
                   let image = UIImage(data: imageData) {
                    completion(image)
                }
                else {
                    print("이미지 디코딩 실패")
                    completion(nil)
                }
            }
            else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
}
