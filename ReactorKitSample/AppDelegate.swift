//
//  AppDelegate.swift
//  ReactorKitSample
//
//  Created by 윤중현 on 2018. 9. 27..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxDataSources
import RxSwiftExtensions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }
    
    private func setup() {
        setupWindow()
    }
    
    // MARK Window
    var window: UIWindow?
    public private(set) lazy var navigationController = UINavigationController(rootViewController: self.rootViewController)
    public private(set) lazy var rootViewController: UIViewController = MainViewController(reactor: MainViewReactor(sampleService: SampleService()))
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

