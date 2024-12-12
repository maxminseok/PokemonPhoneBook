//
//  Margin.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit

/// UI 세팅에 쓸 간격과 사이즈를 저장한 구조체
struct Margin {
    var heightRatio: CGFloat {
        UIScreen.main.bounds.height / 874
    }
    var widthRatio: CGFloat {
        UIScreen.main.bounds.width / 402
    }
    
    var sideMargin: CGFloat {
        20 * widthRatio
    }
    var topMargin: CGFloat {
        40 * heightRatio
    }
    
    var halfTopMargin: CGFloat {
        topMargin / 2
    }
    
    var quarterTopMargin: CGFloat {
        topMargin / 4
    }
    
    var profileImageSize: CGFloat {
        widthRatio * 160
    }
}
