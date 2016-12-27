//
//  UIViewController+Drawer.swift
//  Pods
//
//  Created by Haizhen Lee on 12/27/16.
//
//

import UIKit

extension UIViewController{
  
  struct AssociatedKeys {
    static var drawerController = "drawerController"
  }
  
  public var drawerController : DrawerController?{
    set{
      objc_setAssociatedObject(self, &AssociatedKeys.drawerController, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }get{
      return objc_getAssociatedObject(self, &AssociatedKeys.drawerController) as? DrawerController
    }
  }
}
