//
//  AppDelegate.swift
//  Drawer
//
//  Created by banxi1988 on 12/27/2016.
//  Copyright (c) 2016 banxi1988. All rights reserved.
//

import UIKit
import Drawer

func makeController(backgroundColor: UIColor) -> UIViewController{
    let vc = UIViewController()
  vc.view.backgroundColor = backgroundColor
  return vc
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  var drawerController: DrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
       let window = UIWindow(frame: UIScreen.main.bounds)
      let frontController = makeController(backgroundColor: .orange)
      frontController.title = "Drawer Demo"
      let showLeftButton = UIButton(type: .system)
      showLeftButton.setTitle("打开左边抽屉", for: .normal)
      showLeftButton.frame = CGRect(x: 15, y: 94, width: 120, height: 36)
      showLeftButton.addTarget(self, action: #selector(showLeftDrawer), for: .touchUpInside)
      frontController.view.addSubview(showLeftButton)
      
      
      let showRightButton = UIButton(type: .system)
      showRightButton.setTitle("打开右边抽屉", for: .normal)
      showRightButton.frame = CGRect(x: 15, y: 164, width: 120, height: 36)
      showRightButton.addTarget(self, action: #selector(showRightDrawer), for: .touchUpInside)
      frontController.view.addSubview(showRightButton)
      
      let frontNavController = UINavigationController(rootViewController: frontController)
      
      let leftVC =  MenuListController(menus:  ["相册","收藏","钱包", "卡包", "表情", "设置", "要问我会为什么这么伤心,原来是因为你不在我身边?"])
      let rightVC = MenuListController(menus: [
        "发起多人聊天","加好友","扫一扫","面对面快传","付款","你没有想过的事情,是因为你不敢去想还是因为?"
        ])
      let drawerController = DrawerController(frontVC: frontNavController, leftVC: leftVC, rightVC: rightVC)
      window.rootViewController = drawerController
      self.window = window
      self.drawerController = drawerController
      window.makeKeyAndVisible()
        return true
    }

  func showLeftDrawer(){
      drawerController?.showLeftDrawer()
  }
  
  func showRightDrawer(){
    drawerController?.showRightDrawer()
  }
  
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

