//
//  AppDelegate.swift
//  EasyFinance
//
//  Created by Никита Гундорин on 04.04.2020.
//  Copyright © 2020 Nikita Gundorin. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUpRealm()
        return true
    }
    
    private func setUpRealm() {
        let languageCode = FormatHelper.getLanguageCode()
        let bundlePath = Bundle.main.path(forResource: "default-v0-\(languageCode)", ofType: "realm")!
        let defaultPath = Realm.Configuration.defaultConfiguration.fileURL!.path
        let fileManager = FileManager.default

        if !fileManager.fileExists(atPath: defaultPath){
            do {
                try fileManager.copyItem(atPath: bundlePath, toPath: defaultPath)
            } catch {
                print(error)
            }
        }
    }
}

