//
//  ViewController.swift
//  Pokemon
//
//  Created by 박민석 on 12/6/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
//    private var dataSource: [PhoneBook] = {
//        [
//            PhoneBook(name: "이름1", phoneNumber: "010-0000-0000", image: "이미지1"),
//            PhoneBook(name: "이름2", phoneNumber: "010-1111-1111", image: "이미지2"),
//            PhoneBook(name: "이름3", phoneNumber: "010-2222-2222", image: "이미지3"),
//            PhoneBook(name: "이름4", phoneNumber: "010-3333-3333", image: "이미지4"),
//            PhoneBook(name: "이름5", phoneNumber: "010-4444-4444", image: "이미지5"),
//            PhoneBook(name: "이름6", phoneNumber: "010-5555-5555", image: "이미지6")
//        ]
//    }()
    
    private var dataSource = [PhoneBook]()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(addList), for: .touchUpInside)
        return button
    }()
    
    private lazy var friendsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @objc
    private func addList() {
        self.navigationController?.pushViewController(PhoneBookViewController(), animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        [
            titleLabel,
            addButton,
            friendsListTableView
        ].forEach { view.addSubview($0) }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(80)
            $0.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.top)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(titleLabel.snp.height)
        }
        
        friendsListTableView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
    }


}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

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
