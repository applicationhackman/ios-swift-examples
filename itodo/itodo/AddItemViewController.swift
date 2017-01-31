//
//  AddItemViewController.swift
//  itodo
//
//  Created by Chandrasekar Gobal on 25/01/17.
//  Copyright © 2017 Zoho Corp. All rights reserved.
//

import Foundation
import UIKit

protocol AddItemViewControllerDelegate: class {
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
    func addItemViewController(_ controller:AddItemViewController, didFinishEditing item: ChecklistItem)
    
}

class AddItemViewController: UITableViewController , UITextFieldDelegate {
    
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var doneBarButtom : UIBarButtonItem!
    
    weak var delegate : AddItemViewControllerDelegate!
    
    var itemToEdit : ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(" viewDidLoad \(itemToEdit)")
        
        if let item = itemToEdit{
            title = " Edit Item"
            textField.text = item.text
	    doneBarButtom.isEnabled = true  
        }
        
    }
    
    @IBAction func done(){
        

        if let item = itemToEdit {
            
            item.text = textField.text!
            delegate?.addItemViewController(self, didFinishEditing: item)
            
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
        
    }
    
   
    
    @IBAction func cancel(){
        
        delegate!.addItemViewControllerDidCancel(self)
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(" ShouldChangeCharactersIn  here ")
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        
        print(" oldText is here \(oldText)")
        
        doneBarButtom.isEnabled = (newText.length > 0)
        
        return true
    }
    
}
