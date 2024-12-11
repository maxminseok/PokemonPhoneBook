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

    private let editView: EditView = .init()
    private let networkManager = NetworkManager()
    weak var delegate: PhoneBookUpdateDelegate?
    
    var isEditingMode: Bool = false // 수정일 땐 true, 추가일 땐 false로 동작
    var phoneBookIndex: Int?    // 수정할 데이터의 인덱스
    var titleText = "연락처 추가"    // 추가 할 땐 "연락처 추가", 수정할 땐 해당 데이터 셀의 name으로 변경
    
    // EditView 로드
    override func loadView() {
        view = editView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editView.delegate = self    // EditView의 이미지 생성 버튼 이벤트 처리를 위한 위임
        setNavigationBar()
    }
    
    // 네비게이션 바 설정
    private func setNavigationBar() {
        navigationItem.title = titleText
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(handleApply))
    }
    
    // 수정 시 UI에 셀 데이터 추가
    func setFieldData(_ phoneBook: PhoneBook) {
        editView.profileImage.image = UIImage(data: phoneBook.image)
        editView.nameTextView.text = phoneBook.name
        editView.phoneNumberTextView.text = phoneBook.phoneNumber
        titleText = phoneBook.name
    }
}

// 버튼 클릭 이벤트 처리
extension PhoneBookViewController: EditViewDelegate {
    // 적용 버튼 이벤트 처리
    @objc private func applyButtonTapped() {
        // 이름, 전화번호, 이미지 값 있는지 확인 후 phoneBook에다가 값 추가하기
        guard let name = editView.nameTextView.text, !name.isEmpty,
              let phoneNumber = editView.phoneNumberTextView.text, !phoneNumber.isEmpty,
              let image = editView.profileImage.image,
              let imageData = image.pngData() else {    // image를 Data 타입으로 변환해야 userDefaults에 저장 가능해서 변환하는 작업
            hanleEmpty()
            return
        }
        
        let newPhoneBook = PhoneBook(name: name, phoneNumber: phoneNumber, image: imageData)
        
        if isEditingMode, let index = phoneBookIndex {
            // 데이터 수정
            delegate?.UpdatePhoneBook(newPhoneBook, at: index)
        }
        else {
            // 데이터 추가
            delegate?.AddNewPhoneBook(newPhoneBook)
        }
        
        // ViewController로 되돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    // 이미지 생성 버튼 이벤트 처리
    @objc func didTapCreateImageButton() {
        let randomNumber = Int.random(in: 1...1000)
        let urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/"+"\(randomNumber)")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        
        networkManager.fetchData(url: url) { [weak self] (result: PokemonData?) in
            guard let self, let result else { return }
            
            guard let imageUrl = URL(string: result.sprites.front_default) else { return }
            if let imageData = try? Data(contentsOf: imageUrl) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.editView.profileImage.image = image
                    }
                }
            }
        }
    }
}

// Alert 설정
extension PhoneBookViewController {
    // 등록 확인 안내 Alert
    @objc private func handleApply() {
        let alert = UIAlertController(
            title: "적용",
            message: "작성 내용을 등록할까요?",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "등록", style: .default) { _ in
            self.applyButtonTapped()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // 필드가 비어있을 때 뜨는 안내 Alert
    @objc private func hanleEmpty() {
        let alert = UIAlertController(
            title: "안내",
            message: "모든 필드를 채워주세요!",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
}
