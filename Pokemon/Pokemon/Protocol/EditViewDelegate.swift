//
//  EditViewDelegate.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/12/24.
//

import UIKit

/// 이미지 생성과 삭제 버튼 처리를 위한 프로토콜
protocol EditViewDelegate: AnyObject {
    
    /// 이미지 생성 버튼 이벤트 처리를 위한 메서드
    func didTapCreateImageButton()
    
    /// 연락처 개별 삭제 버튼 이벤트 처리를 위한 메서드
    func didTapDeleteButton()
}

