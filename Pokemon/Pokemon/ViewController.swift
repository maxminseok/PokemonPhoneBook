//
//  ViewController.swift
//  Pokemon
//
//  Created by 박민석 on 12/6/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let margin = Margin()
    
    // 연락처 데이터
    private var dataSource = [PhoneBook]()
    
    // 첫 화면 타이틀 레이블
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    // 다음 화면으로 넘어가기 위한 버튼
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(addList), for: .touchUpInside)
        return button
    }()
    
    // 연락처 데이터를 띄울 테이블 뷰
    private lazy var friendsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(resetDataButtonTapped), for: .touchUpInside)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // UI 구성
    private func configureUI() {
        view.backgroundColor = .systemBackground
        [
            titleLabel,
            addButton,
            friendsListTableView,
            deleteButton
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalToSuperview().inset(margin.sideMargin)
            $0.height.equalTo(titleLabel.snp.height)
        }
        
        friendsListTableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(margin.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(margin.sideMargin)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        deleteButton.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.top)
            $0.leading.equalToSuperview().inset(margin.sideMargin)
            $0.height.equalTo(titleLabel.snp.height)
        }
    }

}

// 추가/삭제 버튼 이벤트 처리
extension ViewController {
    
    // 버튼 클릭시 추가를 위한 화면으로 이동
    @objc
    private func addList() {
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.delegate = self
        phoneBookVC.isEditingMode = false
        self.navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
    // 데이터 삭제
    @objc func resetDataButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "PhoneBook")
        dataSource.removeAll()
        friendsListTableView.reloadData()
        print("PhoneBook 데이터가 초기화되었습니다.")
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
        friendsListTableView.reloadData()
    }
}

// 데이터 추가/수정 메서드 구현
extension ViewController: PhoneBookUpdateDelegate {
    func didUpdatePhoneBook(_ updatedPhoneBook: PhoneBook, at index: Int) {
        dataSource[index] = updatedPhoneBook
        
        if let encoded = try? JSONEncoder().encode(dataSource) {
            UserDefaults.standard.set(encoded, forKey: "PhoneBook")
        }
        
        friendsListTableView.reloadData()
    }
    
    func didAddNewPhoneBook(_ newPhoneBook: PhoneBook) {
        dataSource.append(newPhoneBook)
        
        if let encoded = try? JSONEncoder().encode(dataSource) {
            UserDefaults.standard.set(encoded, forKey: "PhoneBook")
        }
        
        friendsListTableView.reloadData()
    }
}
