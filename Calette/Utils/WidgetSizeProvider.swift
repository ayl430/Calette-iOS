//
//  WidgetSizeProvider.swift
//  Calette
//
//  Created by yeri on 8/25/25.
//

import UIKit

enum WidgetFamilyType {
    case systemSmall
    case systemMedium
    case systemLarge
//    case systemExtraLarge
}

struct WidgetSizeProvider {
    
    static func size(for family: WidgetFamilyType) -> CGSize {
        let screen = UIScreen.main.bounds.size
        
        switch family {
        case .systemSmall:
            return smallSize(for: screen)
        case .systemMedium:
            return mediumSize(for: screen)
        case .systemLarge:
            return largeSize(for: screen)
        }
    }
    
    // https://developer.apple.com/design/human-interface-guidelines/widgets
    private static func smallSize(for screen: CGSize) -> CGSize {
        switch screen {
        case CGSize(width: 440, height: 956):   return CGSize(width: 170, height: 170) // iPhone 16 Pro Max
        case CGSize(width: 402, height: 874):   return CGSize(width: 158, height: 158) // iPhone 16 Pro
        case CGSize(width: 430, height: 932):   return CGSize(width: 170, height: 170)
        case CGSize(width: 428, height: 926):   return CGSize(width: 170, height: 170)
        case CGSize(width: 414, height: 896):   return CGSize(width: 169, height: 169)
        case CGSize(width: 414, height: 736):   return CGSize(width: 159, height: 159)
        case CGSize(width: 393, height: 852):   return CGSize(width: 158, height: 158)
        case CGSize(width: 390, height: 844):   return CGSize(width: 158, height: 158)
        case CGSize(width: 375, height: 812):   return CGSize(width: 155, height: 155)
        case CGSize(width: 375, height: 667):   return CGSize(width: 148, height: 148)
        case CGSize(width: 360, height: 780):   return CGSize(width: 155, height: 155)
        case CGSize(width: 320, height: 568):   return CGSize(width: 141, height: 141)
        default:                                return CGSize(width: 155, height: 155)
        }
    }
    
    private static func mediumSize(for screen: CGSize) -> CGSize {
        switch screen {
        case CGSize(width: 440, height: 956):   return CGSize(width: 364, height: 170)
        case CGSize(width: 402, height: 874):   return CGSize(width: 338, height: 158)
        case CGSize(width: 430, height: 932):   return CGSize(width: 364, height: 170)
        case CGSize(width: 428, height: 926):   return CGSize(width: 364, height: 170)
        case CGSize(width: 414, height: 896):   return CGSize(width: 360, height: 169)
        case CGSize(width: 414, height: 736):   return CGSize(width: 348, height: 157)
        case CGSize(width: 393, height: 852):   return CGSize(width: 338, height: 158)
        case CGSize(width: 390, height: 844):   return CGSize(width: 338, height: 158)
        case CGSize(width: 375, height: 812):   return CGSize(width: 329, height: 155)
        case CGSize(width: 375, height: 667):   return CGSize(width: 321, height: 148)
        case CGSize(width: 360, height: 780):   return CGSize(width: 329, height: 155)
        case CGSize(width: 320, height: 568):   return CGSize(width: 292, height: 141)
        default:                                return CGSize(width: 329, height: 155)
        }
    }
    
    private static func largeSize(for screen: CGSize) -> CGSize {
        switch screen {
        case CGSize(width: 440, height: 956):   return CGSize(width: 364, height: 382)
        case CGSize(width: 402, height: 874):   return CGSize(width: 338, height: 354)
        case CGSize(width: 430, height: 932):   return CGSize(width: 364, height: 382)
        case CGSize(width: 428, height: 926):   return CGSize(width: 364, height: 382)
        case CGSize(width: 414, height: 896):   return CGSize(width: 360, height: 379)
        case CGSize(width: 414, height: 736):   return CGSize(width: 348, height: 357)
        case CGSize(width: 393, height: 852):   return CGSize(width: 338, height: 354)
        case CGSize(width: 390, height: 844):   return CGSize(width: 338, height: 354)
        case CGSize(width: 375, height: 812):   return CGSize(width: 329, height: 345)
        case CGSize(width: 375, height: 667):   return CGSize(width: 321, height: 324)
        case CGSize(width: 360, height: 780):   return CGSize(width: 329, height: 345)
        case CGSize(width: 320, height: 568):   return CGSize(width: 292, height: 311)
        default:                                return CGSize(width: 329, height: 345)
        }
    }
}
