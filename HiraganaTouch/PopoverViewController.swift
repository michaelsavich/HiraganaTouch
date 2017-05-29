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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(PopoverViewController.turnOffEditable), userInfo: nil, repeats: false)
        NotificationCenter.default.addObserver(self, selector: #selector(PopoverViewController.updateTextField), name: NSNotification.Name(rawValue: "defaultsDidChange"), object: nil)
    }
    
    func turnOffEditable() {
        textField.window!.makeFirstResponder(self.view)
    }
    
    func updateTextField() {
        let text = UserDefaults.standard.string(forKey: "hiragana") ?? ""
        
        self.textField.stringValue = text
    }

    
    override func flagsChanged(with event: NSEvent) {
        let flags = event.modifierFlags
        
        var reactions: [ModifierReaction] = []
        
        if flags.contains(.shift)       { reactions.append(.complex) }
        if flags.contains(.command)     { reactions.append(.dash)    }
        if flags.contains(.option)      { reactions.append(.bubble)  }
        let del = NSApp.delegate! as! AppDelegate
        del.reactToModifiers(reactions)
    }
    
    


}
