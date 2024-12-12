//
//  TableViewCell.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/6/24.
//

import UIKit

final class TableViewCell: UITableViewCell {
    
    static let id = "TableViewCell"
    
    /// 이름 레이블
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .label
        return label
    }()
    
    /// 전화번호 레이블
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "010-0000-0000"
        label.textColor = .label
        return label
    }()
    
    /// 프로필 이미지 뷰
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true  // 이미지가 틀을 벗어나면 잘리도록 추가
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀의 UI 구성
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        [
            profileImageView,
            nameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        phoneNumberLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    /// UITableViewCell의 데이터를 받아 세팅하는 메서드
    public func configureCell(phoneBook: PhoneBook) {
        profileImageView.image = UIImage(data: phoneBook.image)
        nameLabel.text = phoneBook.name
        phoneNumberLabel.text = phoneBook.phoneNumber
    }
    
}
