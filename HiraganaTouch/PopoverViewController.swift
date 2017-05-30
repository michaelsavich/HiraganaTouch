//
//  WindowController.swift
//  HiraganaTouch
//
//  Created by Michael Savich on 5/28/17.
//  Copyright © 2017 Michael Savich. All rights reserved.
//

import Cocoa

extension NSTouchBarItemIdentifier {
    static let hiraganaKeys = NSTouchBarItemIdentifier("com.michaelsavich.hiraganaTouch.keys")
}

class PopoverViewController: NSViewController, NSTouchBarDelegate {

    @IBOutlet weak var textField: NSTextField!
    
    override func viewDidDisappear() {
        UserDefaults.standard.setValue("", forKey: "hiragana")
        textField.stringValue = ""
    }
}
