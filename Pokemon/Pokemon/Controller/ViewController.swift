//
//  ViewController.swift
//  Pokemon
//
//  Created by 박민석 on 12/6/24.
//

import UIKit

class ViewController: UIViewController {

    private let mainView: MainView = .init()
    // 연락처 데이터
    private var dataSource = [PhoneBook]()
    
    // mainView 로드
    override func loadView() {
        view = mainView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MainView의 테이블 뷰 설정을 위임 받기
        mainView.setTableViewDelegate(delegate: self, dataSource: self)
        
        setNavigationBar()
    }
    
    // 네비게이션 바 설정
    private func setNavigationBar() {
        navigationItem.title = "친구 목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(resetDataButtonTapped))
    }

}

// 추가/삭제 버튼 이벤트 처리
extension ViewController {
    // 버튼 클릭시 추가를 위한 화면으로 이동
    @objc private func addList() {
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.delegate = self
        phoneBookVC.isEditingMode = false
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
    // 데이터 삭제
    @objc func resetDataButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "PhoneBook")
        dataSource.removeAll()
        mainView.friendsListTableView.reloadData()
        print("PhoneBook 데이터가 초기화되었습니다.")
    }
}

// 테이블 뷰 reload 설정
extension ViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // UserDefaults에서 데이터 다시 가져오기
        if let data = UserDefaults.standard.data(forKey: "PhoneBook"),
           let phonebooks = try? JSONDecoder().decode([PhoneBook].self, from: data) {
            // 알파벳 순으로 정렬
            let sortedPhoneBooks = phonebooks.sorted { $0.name < $1.name }
            dataSource = sortedPhoneBooks
        }
        mainView.reloadTableView()
    }
}

// 데이터 추가/수정 메서드 구현
extension ViewController: PhoneBookUpdateDelegate {
    func UpdatePhoneBook(_ updatedPhoneBook: PhoneBook, at index: Int) {
        dataSource[index] = updatedPhoneBook
        
        if let encoded = try? JSONEncoder().encode(dataSource) {
            UserDefaults.standard.set(encoded, forKey: "PhoneBook")
        }
        
        mainView.reloadTableView()
    }
    
    func AddNewPhoneBook(_ newPhoneBook: PhoneBook) {
        dataSource.append(newPhoneBook)
        
        if let encoded = try? JSONEncoder().encode(dataSource) {
            UserDefaults.standard.set(encoded, forKey: "PhoneBook")
        }
        
        mainView.reloadTableView()
    }
}

// 테이블 뷰 Delegate 설정
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 셀 클릭 시 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = dataSource[indexPath.row]
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.setFieldData(selectedCell)
        phoneBookVC.delegate = self
        phoneBookVC.isEditingMode = true
        phoneBookVC.phoneBookIndex = indexPath.row
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
}

// 테이블 뷰 dataSource 설정
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(phoneBook: dataSource[indexPath.row])
        return cell
    }
}
