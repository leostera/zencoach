//
//  AppDelegate.swift
//  ZenCoach
//
//  Created by Leandro Ostera on 8/13/16.
//  Copyright © 2016 ostera.com. All rights reserved.
//

import Cocoa
import IOKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var bar = NSStatusBar.systemStatusBar()
    var item : NSStatusItem = NSStatusItem()

    override func awakeFromNib() {
        self.item = self.bar.statusItemWithLength(-1)
        self.item.enabled = false
        self.item.title = "ZenCoach"
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSWorkspace
            .sharedWorkspace()
            .notificationCenter
            .addObserverForName(NSWorkspaceDidActivateApplicationNotification,
                            object: nil,
                            queue: NSOperationQueue.mainQueue()
            ) { x in print(x.userInfo.bundleIdentifier!) }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

