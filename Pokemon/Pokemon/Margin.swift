//
//  Margin.swift
//  Pokemon
//
//  Created by t2023-m0072 on 12/9/24.
//

import UIKit

struct Margin {
    var heightRatio: CGFloat {
        UIScreen.main.bounds.height / 812
    }
    var widthRatio: CGFloat {
        UIScreen.main.bounds.width / 375
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
}

struct FontSize {
    var titleSize = 20
    var textSize = 18
}
