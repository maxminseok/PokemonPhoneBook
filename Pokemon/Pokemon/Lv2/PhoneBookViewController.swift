//
//  PhoneBookViewController.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/6/24.
//

import UIKit

class PhoneBookViewController: UIViewController {
    
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 80
        return imageView
    }()
    
    private let createImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(createImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameTextView: UITextView = {
        let textView = UITextView()
        textView.text = "이름 입력"
        textView.textColor = .secondaryLabel
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.delegate = self
        return textView
    }()
    
    private lazy var phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.text = "전화번호 입력"
        textView.textColor = .secondaryLabel
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.delegate = self
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        [
            applyButton,
            profileImage,
            createImageButton,
            nameTextView,
            phoneNumberTextView
        ].forEach { view.addSubview($0) }
        
        self.navigationItem.title = "연락처 추가"
        let rightItem = UIBarButtonItem(customView: applyButton)
        self.navigationItem.rightBarButtonItem = rightItem
        
        profileImage.snp.makeConstraints{
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(160)
        }
        
        createImageButton.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        nameTextView.snp.makeConstraints{
            $0.top.equalTo(createImageButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        phoneNumberTextView.snp.makeConstraints{
            $0.top.equalTo(nameTextView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    
    @objc
    private func applyButtonTapped() {
        
    }
    
    @objc
    private func createImageButtonTapped() {
        fetchPoekemonImage()
    }
    
    // 서버 데이터를 불러오는 메서드
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (T?) -> Void) {
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
    
    // 서버에서 포켓몬 이미지 불러오는 메서드
    private func fetchPoekemonImage() {
        let randomNumber = Int.random(in: 1...1000)
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/"+"\(randomNumber)")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        fetchData(url: url) { [weak self] (result: PokemonData?) in
            guard let self, let result else { return }
            
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(named: result.sprites.front_default)
            }
        }
    }
    
}

extension PhoneBookViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.text = nil
        textView.textColor = .label
    }
}
