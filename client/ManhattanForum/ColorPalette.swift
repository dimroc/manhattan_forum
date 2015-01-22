//
//  ColorPalette.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 12/14/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

// Colors taken from Color Palette here:
// http://iosdesign.ivomynttinen.com/
private let colorTable = [
    UIColor.whiteColor(),
    UIColor(hex: 0x54C7FC),
    UIColor(hex: 0xFF9600),
    UIColor(hex: 0xFF2851),
    UIColor(hex: 0x0076FF),
    UIColor(hex: 0x44DB5E),
    UIColor(hex: 0xFF3824),
    UIColor(hex: 0x8E8E93)
]

class ColorPalette {
    private(set) internal var color: UIColor = UIColor.whiteColor()
    private var index: Int = 0
    
    init() {
        self.index = 0
        self.color = colorTable.first!
    }
    
    private init(index: Int) {
        self.index = index
        self.color = colorTable[index]
    }
    
    class func random() -> ColorPalette! {
        let diceRoll: Int = Int(arc4random_uniform(UInt32(colorTable.count)))
        return ColorPalette(index: diceRoll)
    }
    
    class func white() -> ColorPalette! {
        return ColorPalette()
    }
    
    func next() -> ColorPalette {
        self.index++
        if self.index >= colorTable.count {
            self.index = 0
        }
        
        self.color = colorTable[self.index]
        return self
    }
}