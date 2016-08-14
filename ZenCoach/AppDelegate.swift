//
//  AppDelegate.swift
//  ZenCoach
//
//  Created by Leandro Ostera on 8/13/16.
//  Copyright © 2016 ostera.com. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  
  var bar = NSStatusBar.systemStatusBar()
  var item : NSStatusItem = NSStatusItem()
  var user : String?
  
  override init() {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    if userDefaults.objectForKey("UUID") == nil {
      let UUID = NSUUID().UUIDString
      userDefaults.setObject(UUID, forKey: "UUID")
      userDefaults.synchronize()
    }
    self.user = userDefaults.stringForKey("UUID")
    
    super.init()
  }
  
  func terminate() {
    NSApplication.sharedApplication().terminate(self)
  }
  
  override func awakeFromNib() {
    self.item = self.bar.statusItemWithLength(-1)
    self.item.title = "ZenCoach"
    
    let menu = NSMenu()
    let quit = NSMenuItem(title: "Quit", action: #selector(terminate), keyEquivalent: "q")
    menu.addItem(quit)
    
    self.item.menu = menu
  }
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    NSWorkspace
      .sharedWorkspace()
      .notificationCenter
      .addObserverForName(NSWorkspaceDidActivateApplicationNotification,
                          object: nil,
                          queue: NSOperationQueue.mainQueue()
      ) { x in self.track(self.user!, data: self.unpackBundleIdentifier(x.userInfo!)!)}
    
    NSWorkspace
      .sharedWorkspace()
      .notificationCenter
      .addObserverForName(NSWorkspaceWillSleepNotification,
                          object: nil,
                          queue: NSOperationQueue.mainQueue()
      ) { x in self.track(self.user!, data: "com.apple.Sleep")}
    
    NSWorkspace
      .sharedWorkspace()
      .notificationCenter
      .addObserverForName(NSWorkspaceDidWakeNotification,
                          object: nil,
                          queue: NSOperationQueue.mainQueue()
      ) { x in self.track(self.user!, data: "com.apple.Wake")}
  }
  
  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }
  
  func unpackBundleIdentifier(data: NSObject) -> String? {
    return data.valueForKey("NSWorkspaceApplicationKey")!.bundleIdentifier
  }
  
  func track(user: String, data: NSObject) {
    let url = NSURL(string: "http://zencoach.ostera.io/\(user)/\(data)")!
    let task = NSURLSession.sharedSession().dataTaskWithURL(url) { _,_,_ in }
    task.resume()
  }
  
  
}

