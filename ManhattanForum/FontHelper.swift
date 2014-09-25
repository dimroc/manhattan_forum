//
//  FontHelper.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 8/22/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

class FontHelper {
    class func launch() {
//        UILabel.appearance().font = createMenu()
    }
    
    class func createMenu() -> UIFont {
        return UIFont(name: "Open Sans", size: 16.0)
    }
    
    class func createNormal() -> UIFont {
        return UIFont(name: "Open Sans", size: 17.0)
    }
    
    class func createBold() -> UIFont {
        let font = createNormal()
        let descriptor: UIFontDescriptor = font.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
        return UIFont(descriptor: descriptor, size: 0)
    }
}