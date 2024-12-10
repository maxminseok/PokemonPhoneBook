//
//  PhoneBookViewController.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/6/24.
//

import UIKit

// 추가/수정을 위한 프로토콜
protocol PhoneBookUpdateDelegate: AnyObject {
    func UpdatePhoneBook(_ updatedPhoneBook: PhoneBook, at index: Int)
    func AddNewPhoneBook(_ newPhoneBook: PhoneBook)
}

class PhoneBookViewController: UIViewController {
    
    private let margin = Margin()
    
    weak var delegate: PhoneBookUpdateDelegate?
    
    var isEditingMode: Bool = false // 수정일땐 true, 추가일 땐 false로 동작
    var phoneBookIndex: Int?    // 수정할 데이터의 인덱스
    var titleText = "연락처 추가"    // 추가 할 땐 "연락처 추가", 수정할 땐 해당 데이터 셀의 name으로 변경
    
    // 수정 시 UI에 셀 데이터 추가
    func setFieldData(_ phoneBook: PhoneBook) {
        profileImage.image = UIImage(data: phoneBook.image)
        nameTextView.text = phoneBook.name
        phoneNumberTextView.text = phoneBook.phoneNumber
        titleText = phoneBook.name
    }
    
    // 작성한 연락처 데이터를 추가시킬 적용 버튼
    private let applyButton: UIButton = {
        let button = UIButton()
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 프로필 이미지 뷰
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true  // 이미지가 틀을 벗어나면 잘리도록 추가
        imageView.backgroundColor = .systemBackground
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = margin.profileImageSize/2
        return imageView
    }()
    
    // 랜덤 이미지 생성 버튼
    private let createImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(createImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 이름 입력 텍스트 뷰
    private let nameTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 18)
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    // 전화번호 입력 텍스트 뷰
    private let phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 18)
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextView.becomeFirstResponder()
        configureUI()
    }
    
    // UI 구성
    private func configureUI() {
        view.backgroundColor = .systemBackground
        [
            applyButton,
            profileImage,
            createImageButton,
            nameTextView,
            phoneNumberTextView
        ].forEach { view.addSubview($0) }
        
        self.navigationItem.title = titleText
        let rightItem = UIBarButtonItem(customView: applyButton)
        self.navigationItem.rightBarButtonItem = rightItem
        
        profileImage.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(margin.topMargin)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(margin.profileImageSize)
        }
        
        createImageButton.snp.makeConstraints{
            $0.top.equalTo(profileImage.snp.bottom).offset(margin.halfTopMargin)
            $0.centerX.equalToSuperview()
        }
        
        nameTextView.snp.makeConstraints{
            $0.top.equalTo(createImageButton.snp.bottom).offset(margin.halfTopMargin)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(margin.sideMargin)
            $0.height.equalTo(margin.profileImageSize/4)
        }
        
        phoneNumberTextView.snp.makeConstraints{
            $0.top.equalTo(nameTextView.snp.bottom).offset(margin.quarterTopMargin)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(margin.sideMargin)
            $0.height.equalTo(margin.profileImageSize/4)
        }
    }
    
}

// 네트워크 통신 메서드
extension PhoneBookViewController {
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
            
            guard let imageUrl = URL(string: result.sprites.front_default) else { return }
            if let imageData = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.profileImage.image = image
                    }
                }
            }
        }
    }
}

// 버튼 클릭 이벤트 처리
extension PhoneBookViewController {
    // 적용 버튼 이벤트 처리
    @objc
    private func applyButtonTapped() {
        // 이름, 전화번호, 이미지 값 있는지 확인 후 phoneBook에다가 값 추가하기
        guard let name = nameTextView.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextView.text, !phoneNumber.isEmpty,
              let image = profileImage.image,
              let imageData = image.pngData() else {    // image를 Data 타입으로 변환해야 userDefaults에 저장 가능해서 변환하는 작업
            print("모든 필드를 채워주세요!")
            return
        }
        
        let newPhoneBook = PhoneBook(name: name, phoneNumber: phoneNumber, image: imageData)
        
        if isEditingMode, let index = phoneBookIndex {
            print("데이터 수정")
            // 데이터 수정
            delegate?.UpdatePhoneBook(newPhoneBook, at: index)
        }
        else {
            print("데이터 추가")
            // 데이터 추가
            delegate?.AddNewPhoneBook(newPhoneBook)
        }
        
        // ViewController로 되돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    // 이미지 생성 버튼 이벤트 처리
    @objc
    private func createImageButtonTapped() {
        fetchPoekemonImage()
    }
}
