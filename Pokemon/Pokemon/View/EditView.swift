//
//  EditView.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/11/24.
//

import UIKit
import SnapKit

class EditView: UIView {
    
    private let margin = Margin()
    weak var delegate: EditViewDelegate?
    
    /// 프로필 이미지 뷰
    lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true  // 이미지가 틀을 벗어나면 잘리도록 추가
        imageView.backgroundColor = .systemBackground
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = margin.profileImageSize/2
        return imageView
    }()
    
    /// 랜덤 이미지 생성 버튼
    let createImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(createImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    /// 이름 입력 텍스트 뷰
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 18)
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    /// 전화번호 입력 텍스트 뷰
    let phoneNumberTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .systemFont(ofSize: 18)
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    /// 연락처 개별 삭제 버튼
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        nameTextView.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성
    private func configureUI() {
        backgroundColor = .systemBackground
        [
            profileImage,
            createImageButton,
            nameTextView,
            phoneNumberTextView,
            deleteButton
        ].forEach { addSubview($0) }
        
        profileImage.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).offset(margin.topMargin)
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
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(margin.sideMargin)
            $0.height.equalTo(margin.profileImageSize/4)
        }
        
        phoneNumberTextView.snp.makeConstraints{
            $0.top.equalTo(nameTextView.snp.bottom).offset(margin.quarterTopMargin)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(margin.sideMargin)
            $0.height.equalTo(margin.profileImageSize/4)
        }
        
        deleteButton.snp.makeConstraints{
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(margin.sideMargin)
            $0.top.equalTo(phoneNumberTextView.snp.bottom).offset(margin.topMargin)
            $0.height.equalTo(margin.profileImageSize/4)
        }
    }
    
    /// 이미지 생성 버튼 이벤트 처리를 위한 메서드
    /// - 이벤트 처리는 EditView에 대한 컨트롤러인 PhoneBookViewController에 위임합니다.
    @objc private func createImageButtonTapped() {
        delegate?.didTapCreateImageButton()
    }
    
    /// 연락처 개별 삭제 버튼 이벤트 처리를 위한 메서드
    /// - 이벤트 처리는 EditView에 대한 컨트롤러인 PhoneBookViewController에 위임합니다.
    @objc private func deleteButtonTapped() {
        delegate?.didTapDeleteButton()
    }
    
    /// 삭제 버튼 숨김 설정을 위한 메서드
    func setDeleteButtonHidden(_ isHidden: Bool) {
        deleteButton.isHidden = isHidden
    }
    
}
