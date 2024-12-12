//
//  NetworkManager.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/11/24.
//

import UIKit

/// 서버에서 받아올 포켓몬 데이터를 저장할 구조체
struct PokemonData: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: UrlImage
}

/// 포켓몬 데이터 중 이미지를 저장할 구조체
struct UrlImage: Codable {
    let front_default: String
}

/// 서버에서 데이터를 불러오는 fetchData 메서드가 있는 클래스
class NetworkManager {
    // 서버 데이터를 불러오는 일반적인 형태의 메서드
    func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data, error == nil else {
                print("데이터 로드 실패")
                completion(nil)
                return
            }
            
            let suceessRange = 200..<300
            if let response = response as? HTTPURLResponse, suceessRange.contains(response.statusCode) {
                guard let decodeData = try? JSONDecoder().decode(T.self, from: data) else {
                    print("JSON 디코딩 실패")
                    completion(nil)
                    return
                }
                completion(decodeData)
            }
            else {
                print("응답 오류")
                completion(nil)
            }
        }.resume()
    }
}
