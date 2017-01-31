//
//  ViewController.swift
//  itodo
//
//  Created by Chandrasekar Gobal on 25/01/17.
//  Copyright © 2017 Zoho Corp. All rights reserved.
//

import UIKit

class ChecklistsViewController: UITableViewController, AddItemViewControllerDelegate {
    
    var items : [ChecklistItem] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]()
        super.init(coder: aDecoder)
        loadChecklistItems()
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func configureText(with cell: UITableViewCell, for item: ChecklistItem){
        
        let lable = cell.viewWithTag(1000) as! UILabel
        lable.text = item.text
        
    }*/
    
    func configureText(for cell: UITableViewCell, with item : ChecklistItem){
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        
    }
    
    func checkMark(for cell: UITableViewCell, with item: ChecklistItem){

        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked{
            label.text = "✔️"
        }else{
            label.text = ""
        }
        
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        
        
        configureText(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            
            let item = items[indexPath.row]
            item.toggleChecked()
            checkMark(for : cell,  with: item)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
    }
 
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        
        print(" add finish")
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row:newRowIndex, section:0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
        
        dismiss(animated: true, completion: {() -> Void in print(" addItemViewController ")})
        
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishEditing item: ChecklistItem) {
        
        
        print(" CSK need print is here \(item.text)  ")
        
        if let idx = items.index(where: { $0.text == item.text }){
    
            let indexPath = IndexPath(row: idx, section: 0)
            
            
            if let cell = tableView.cellForRow(at: indexPath){
                
                configureText(for: cell, with: item)
                saveChecklistItems()
            }
            
        }
        
        dismiss(animated: true, completion: {() -> Void in print(" CSK edit finished ")})
    } 
    
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        
        print(" add cancel")
        
        controller.dismiss(animated: true, completion: {() -> Void in print(" CSK canceled here ")})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print(" itodo prerpare \(segue.identifier)")
        
        if segue.identifier == "AddItem" { 
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddItemViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem" {
            
            print(" Enters in the Edit Scope ")
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! AddItemViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    func documentsDirectory() -> URL{
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
            unarchiver.finishDecoding()
        }
    }
    
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }


}

