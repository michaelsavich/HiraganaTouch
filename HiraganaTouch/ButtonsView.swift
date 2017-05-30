//
//  ButtonScrollView.swift
//  HiraganaTouch
//
//  Created by Michael Savich on 5/28/17.
//  Copyright © 2017 Michael Savich. All rights reserved.
//

import Cocoa

class ButtonsView: NSView {

    init (buttons: [NSButton]) {
        var width: CGFloat = 0
        for button in buttons {
            width += button.frame.width + 5
        }
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: 30))
        var offset: CGFloat = 0
        for button in buttons {
            button.frame.size.height = 30
            button.frame.origin.x = offset
            self.addSubview(button)
            offset += button.frame.width + 5
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
