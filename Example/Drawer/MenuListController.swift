//
//  LeftMenuListController.swift
//  Drawer
//
//  Created by Haizhen Lee on 12/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class MenuCell:UITableViewCell, Bindable{
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  typealias DataItem = String
  
  func bind(to item: String) {
    textLabel?.text = item
  }
  
  func commonInit(){
    textLabel?.numberOfLines = 0
    backgroundColor = .white
    textLabel?.textColor = UIColor(white: 0.22, alpha: 1.0)
  }
  
}

class MenuListController: UITableViewController{
 
  var dataSource: ListDataSource<MenuCell>!
  init(menus: [String]){
    super.init(style: .plain)
    dataSource = ListDataSource<MenuCell>(dataItems:menus)

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    let oldInset = tableView.contentInset
    tableView.contentInset = UIEdgeInsets(top: oldInset.top + 22, left: oldInset.left, bottom: oldInset.bottom, right: oldInset.right)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.tableFooterView = UIView()
    tableView.separatorColor = UIColor(white: 0.933, alpha: 1.0)
//    tableView.separatorEffect = UIBlurEffect(style: .light)
    tableView.backgroundColor = UIColor(white: 0.953, alpha: 1.0)
    dataSource.bind(to: tableView)
    
    
    
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    drawerController?.showFront()
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
