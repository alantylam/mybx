//
//  MainStyleSheet.swift
//  Mybx
//
//  Created by Nabil Muthanna on 2017-10-19.
//  Copyright © 2017 Nabil Muthanna. All rights reserved.
//

import UIKit

extension UITraitCollection {
    
    var isIpad: Bool {
        return self.verticalSizeClass == .regular && self.horizontalSizeClass == .regular
    }
    
}

struct Dimension {
    let traitCollection: UITraitCollection
}

extension Dimension: BXPagerOptions, BXPagerMenuOptions {
    var showAllItemsOnScreen: Bool {
        return true
    }
    
    var menuItemWidth: Float {
        return 300
    }
    
    
    var menuItemScrollBarColor: UIColor {
        return .white
    }
    
    
    var spacingBetweenItems: Float {
        return 0
    }
    
    var menuOptions: BXPagerMenuOptions { return self }
    
    var menuHeight: Float {
        if self.traitCollection.isIpad {
            return 100
        } else {
            return 50
        }
    }
    
    var scrollBarHeight: Float {
        if self.traitCollection.isIpad {
            return 10
        } else {
            return 8
        }
    }
}


extension Dimension {
    
    
    
    var xpertCellHeight: CGFloat {
        switch traitCollection.horizontalSizeClass {
        case .regular:
            return 320
        default:
            return 270
        }
    }
    
    var loadCell: CGFloat {
        return 30
    }
    
    var firstFont: UIFont {
        switch traitCollection.verticalSizeClass {
        case .regular:
            return UIFont.boldSystemFont(ofSize: 15)
        default:
            return UIFont.boldSystemFont(ofSize: 12)
        }
    }
    
    var secondFont: UIFont {
        switch traitCollection.verticalSizeClass {
        case .regular:
            return UIFont.boldSystemFont(ofSize: 12)
        default:
            return UIFont.boldSystemFont(ofSize: 10)
        }
    }
    
}

struct StyleSheet {
    
    static var defaultTheme = Theme.bx
    
    
    //let traitCollection: UITraitCollection
    
    enum Theme {
        case bx
        
        var mainColor: UIColor  {
            switch self {
            case .bx:
                return UIColor.init(colorWithHexValue: 0xF06260)
            }
        }
        
        var backgroundColor: UIColor {
            switch self {
            case .bx:
                return UIColor.rgb(r: 240, g: 240, b: 240)
            }
        }
        
        var contentBackgroundColor: UIColor {
            switch self {
            case .bx:
                return UIColor.white
            }
        }
    }
}
