//
//  DrawerControllerView.swift
//  Pods
//
//  Created by Haizhen Lee on 12/27/16.
//
//

import UIKit

class DrawerControllerView: UIView{
  var hasShadow = true{
    didSet{
      updateShadow()
    }
  }
  weak var viewController: UIViewController?
  
  func updateShadow(){
    if hasShadow{
      let shadowPath = UIBezierPath(rect: bounds)
      layer.masksToBounds = false
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOffset = .zero
      layer.shadowOpacity = 0.5
      layer.shadowRadius = 2.5
      layer.shadowPath = shadowPath.cgPath
    }else{
      layer.masksToBounds = true
      layer.shadowColor = nil
      layer.shadowOffset = .zero
      layer.shadowOpacity = 0
      layer.shadowRadius =  0
      layer.shadowPath = nil
    }
  }
  
  func updateShadow(animationDuration: TimeInterval){
    
  }
  
  func updateViewController(enableUserInteraction:Bool){
    viewController?.view.isUserInteractionEnabled = enableUserInteraction
  }
  
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let targetView = super.hitTest(point, with: event)
    return targetView
  }
  
}
