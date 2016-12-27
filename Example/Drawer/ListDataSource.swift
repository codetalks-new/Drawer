//
//  TableViewSimplify.swift
//  Drawer
//
//  Created by Haizhen Lee on 12/28/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

public protocol Bindable{
  associatedtype DataItem
  func bind(to item:DataItem)
}

extension String{
  public static let listCellReuseIdentifier = "listCell"
}


public class ListDataSource<Cell:UITableViewCell> : NSObject, UITableViewDataSource  where Cell:Bindable{
  public private(set) var dataItems:[Cell.DataItem] = []
  private weak var  tableView: UITableView?
  
  public init(dataItems:[Cell.DataItem] = []){
    self.dataItems = dataItems
  }
  
  public func bind(to tableView:UITableView){
    self.tableView = tableView
    tableView.dataSource = self
    tableView.register(Cell.classForCoder(), forCellReuseIdentifier: .listCellReuseIdentifier)
  }
  
  // MARK:UITableViewDataSource
  public func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataItems.count
  }
  
  func dataItem(atIndexPath indexPath:IndexPath) -> Cell.DataItem{
    return dataItems[indexPath.row]
  }
  

  func updateDataItems(_ items:[Cell.DataItem]){
    self.dataItems = items
    if tableView?.superview != nil{
      tableView?.reloadData()
    }
    
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: .listCellReuseIdentifier, for: indexPath)
    guard let dataItemCell  = cell as? Cell else {
      fatalError("dataItemell not the declared Cell Type \(Cell.classForCoder())")
    }
    dataItemCell.bind(to: dataItem(atIndexPath: indexPath))
    return cell
  }
}



