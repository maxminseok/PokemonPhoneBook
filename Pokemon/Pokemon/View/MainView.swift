//
//  MainView.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/11/24.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    private let margin = Margin()

    // 연락처 데이터를 띄울 테이블 뷰
    lazy var friendsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.showsVerticalScrollIndicator = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        return tableView
    }()
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성
    private func configureUI() {
        backgroundColor = .systemBackground
        
        addSubview(friendsListTableView)
        
        friendsListTableView.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(margin.topMargin)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(margin.sideMargin)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // ViewController에서 테이블 뷰 delegate와 dataSource 설정할 수 있도록 허용하는 메서드
    func setTableViewDelegate(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        friendsListTableView.delegate = delegate
        friendsListTableView.dataSource = dataSource
    }
    
    // ViewController에서 테이블 뷰 리로드 할 때 사용할 메서드
    func reloadTableView() {
        friendsListTableView.reloadData()
    }
    
}
