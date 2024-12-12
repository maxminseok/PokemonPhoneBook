//
//  ViewController.swift
//  Pokemon
//
//  Created by 박민석 on 12/6/24.
//

import UIKit

/// 앱의 메인 화면을 관리하는 뷰 컨트롤러
/// - 연락처 데이터인 dataSource를 이곳에서 관리합니다.
class ViewController: UIViewController {

    private let mainView: MainView = .init()
    
    // 연락처 데이터
    private var dataSource = [PhoneBook]()
    
    // mainView 로드
    override func loadView() {
        self.view = mainView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MainView의 테이블 뷰 설정을 위한 위임
        mainView.setTableViewDelegate(delegate: self, dataSource: self)
        
        setNavigationBar()
    }
    
    // MainView 네비게이션 바 설정
    private func setNavigationBar() {
        navigationItem.title = "친구 목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(handleDelete))
    }

}

// MARK: - 이벤트 핸들링
// 추가,삭제 버튼 이벤트 처리
extension ViewController {
    /// 버튼 클릭시 추가를 위한 화면으로 이동
    @objc private func addButtonTapped() {
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.delegate = self
        phoneBookVC.isEditingMode = false
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
    /// 삭제 확인 안내 Alert
    @objc private func handleDelete() {
        let alert = UIAlertController(title: "삭제", message: "연락처를 전부 삭제할까요?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.resetDataButtonTapped()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// 삭제 완료 안내 Alert
    private func handleConfirm() {
        let alert = UIAlertController(title: "안내", message: "모든 연락처가 삭제 되었습니다.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    /// 전체 연락처 데이터 삭제
    func resetDataButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "PhoneBook")
        dataSource.removeAll()
        mainView.reloadTableView()
        handleConfirm()
    }
}

// MARK: - 테이블 뷰 리로드
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
// MARK: - 테이블 뷰 Delegate 설정
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
// MARK: - 테이블 뷰 DataSource 설정
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

// MARK: - PhoneBookEditDelegate 프로토콜 메서드 구현
// 데이터 추가, 수정, 삭제를 위한 메서드 구현
extension ViewController: PhoneBookEditDelegate {
    func EditPhoneBook(_ editedPhoneBook: PhoneBook, at index: Int) {
        dataSource[index] = editedPhoneBook
        
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
    
    func DeletePhoneBook(at index: Int) {
        dataSource.remove(at: index)
        
        if let encoded = try? JSONEncoder().encode(dataSource) {
            UserDefaults.standard.set(encoded, forKey: "PhoneBook")
        }
        
        mainView.reloadTableView()
    }
}
