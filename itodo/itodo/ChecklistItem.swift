//
//  ChecklistItem.swift
//  itodo
//
//  Created by Chandrasekar Gobal on 25/01/17.
//  Copyright © 2017 Zoho Corp. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
  var text = ""
  var checked = false
  
  override init() {
    print(" 1 init ")
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    print(" 2 init ")
    text = aDecoder.decodeObject(forKey: "Text") as! String
    checked = aDecoder.decodeBool(forKey: "Checked")
    super.init()
  }
  
  func toggleChecked() {
    checked = !checked
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(text, forKey: "Text")
    aCoder.encode(checked, forKey: "Checked")
  }
}
