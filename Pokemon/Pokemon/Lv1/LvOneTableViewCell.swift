//
//  LvOneTableViewCell.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/6/24.
//

import UIKit

final class LvOneTableViewCell: UITableViewCell {
    
    static let id = "LvOneTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.textColor = .label
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "010-0000-0000"
        label.textColor = .label
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBackground
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        [
            profileImageView,
            nameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        phoneNumberLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    public func configureCell(phoneBook: PhoneBook) {
        profileImageView.image = UIImage(named: phoneBook.image)
        nameLabel.text = phoneBook.name
        phoneNumberLabel.text = phoneBook.phoneNumber
    }
    
}
