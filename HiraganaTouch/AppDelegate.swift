//
//  AppDelegate.swift
//  HiraganaTouch
//
//  Created by Michael Savich on 5/28/17.
//  Copyright © 2017 Michael Savich. All rights reserved.
//

import Cocoa

enum ModifierReaction {
    case dash, bubble
}

@NSApplicationMain
class AppDelegate: NSResponder, NSApplicationDelegate, NSTouchBarDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    var popoverVC: PopoverViewController?
    
    var buttons: [NSButton] {
        if let cache = cachedButtons { return cache }
        var result: [NSButton] = []
        for value in bases {
            result.append(NSButton(title: value, target: self, action: #selector(AppDelegate.performActionForButton(_:))))
        }
        cachedButtons = result; return result;
    }; var cachedButtons: [NSButton]?;
    
    func reactToModifiers(_ reactions: [ModifierReaction]) {
        for btn in self.buttons {
            let dashedFlag  = reactions.contains(.dash)
            let bubbledFlag = reactions.contains(.bubble)
            
            if !dashedFlag {
                btn.title =? undashed[btn.title]
            }
            if !bubbledFlag {
                btn.title =? unbubbled[btn.title]
            }
            
            if dashedFlag  {
                btn.title =? dashed[btn.title]
            }
            else if bubbledFlag {
                btn.title =? bubbled[btn.title]
            }
        }
    }
    
    override func flagsChanged(with event: NSEvent) {
        let flags = event.modifierFlags
        
        var reactions: [ModifierReaction] = []
        
        if flags.contains(.command) {
            reactions = [.dash]
            if flags.contains(.option) {
                reactions = [.bubble]
            }
        }
        
        
        self.reactToModifiers(reactions)
    }
    
    override func keyDown(with event: NSEvent) {
        let deleteKey: UInt16 = 51
        
        if event.keyCode == deleteKey {
            var text = ""
            text =? UserDefaults.standard.string(forKey: "hiragana")
            
            if !text.isEmpty {
                text.remove(at: text.lastIndex)
                self.updateText(txt: text)
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.setValue("", forKey: "hiragana")
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) { (event: NSEvent) in
            self.flagsChanged(with: event)
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event: NSEvent) in
            self.keyDown(with: event)
            return event
        }
        
        if let button = statusItem.button {
            button.image = NSImage(named: "あ@3x.png")
            button.action = #selector(AppDelegate.expandStatusPopover(button:))
            
            let sb = NSStoryboard(name: "Main", bundle: nil)
            let controller = sb.instantiateController(withIdentifier: "menubarApp") as! PopoverViewController
            popoverVC = controller
            popover.contentViewController = controller
        }
    }
    
    func applicationDidResignActive(_ notification: Notification) {
        if popover.isShown {
            popover.close()
        }
    }
    
    func expandStatusPopover(button:NSButton) {
        if popover.isShown {
            popover.close()
            NSApp.resignFirstResponder()
        }
        else {
            popover.show(relativeTo: NSRect(x: 0,y: 0,width: 300,height: 300), of: button, preferredEdge: NSRectEdge.minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func performActionForButton(_ button: NSButton) {
        var text = UserDefaults.standard.string(forKey: "hiragana") ?? ""
        text += button.title
        self.updateText(txt: text)
    }
    
    func updateText(txt: String) {
        UserDefaults.standard.setValue(txt, forKey: "hiragana")
        
        NSPasteboard.general().clearContents()
        NSPasteboard.general().setString(txt, forType: NSPasteboardTypeString)
        
        popoverVC?.textField.stringValue = txt
    }
    
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        let touchbar = NSTouchBar()
        touchbar.defaultItemIdentifiers = [.hiraganaKeys]
        touchbar.delegate = self
        return touchbar
    }
    
    @available(OSX 10.12.2, *)
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        if identifier == .hiraganaKeys {
            let item = NSCustomTouchBarItem(identifier: identifier)
            let scrollView = NSScrollView(frame: NSMakeRect(0, 0, 600, 30))
            
            scrollView.documentView = ButtonsView(buttons: self.buttons)
            item.view = scrollView
            return item
        }
        else {
            return nil
        }
    }
}

