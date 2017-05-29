//
//  AppDelegate.swift
//  HiraganaTouch
//
//  Created by Michael Savich on 5/28/17.
//  Copyright © 2017 Michael Savich. All rights reserved.
//

import Cocoa

enum ModifierReaction {
    case dash, bubble, complex
}

@NSApplicationMain
class AppDelegate: NSResponder, NSApplicationDelegate, NSTouchBarDelegate {
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    
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

    func applicationWillFinishLaunching(_ notification: Notification) {
//        NSApplication.shared().windows.last!.close()
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.setValue("", forKey: "hiragana")
        if let button = statusItem.button {
            button.image = NSImage(named: "あ@3x.png")
            button.action = #selector(AppDelegate.expandStatusPopover(button:))
            let sb = NSStoryboard(name: "Main", bundle: nil)
            let controller = sb.instantiateController(withIdentifier: "menubarApp") as! PopoverViewController
            popover.contentViewController = controller
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    func applicationDidResignActive(_ notification: Notification) {
        if popover.isShown {
            popover.close()
            UserDefaults.standard.setValue("", forKey: "hiragana")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "defaultsDidChange"), object: nil)
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
        UserDefaults.standard.setValue(text, forKey: "hiragana")
        NSPasteboard.general().clearContents()
        NSPasteboard.general().setString(text, forType: NSPasteboardTypeString)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "defaultsDidChange"), object: nil)
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
            var item = NSCustomTouchBarItem(identifier: identifier)
            var scrollView = NSScrollView(frame: NSMakeRect(0, 0, 600, 30))
            scrollView.documentView = ButtonsView(buttons: self.buttons)
            item.view = scrollView
            return item
        }
        else {
            return nil
        }
    }
}

