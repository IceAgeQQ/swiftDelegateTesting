//
//  ViewController.swift
//  swiftSQLite
//
//  Created by Chao Xu on 1/29/16.
//  Copyright © 2016 Chao Xu. All rights reserved.
//

import UIKit

protocol viewControllerDelegate: class {
    func viewcontrollerdelegate(setviewcontrollerdelegate: ViewController)
}

class ViewController: UIViewController ,UITextFieldDelegate {
    weak var delegate: viewControllerDelegate?

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var status: UILabel!
    
    var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Creates an NSFileManager instance and subsequently uses it to detect if the database file already exists.
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0]
        databasePath = docsDir.stringByAppendingPathComponent("contacts.db")

        //If the file does not yet exist the code creates the database by creating an FMDatabase instance initialized with the database file path. If the database creation is successful it is then opened via a call to the open method of the new database instance.
        if !filemgr.fileExistsAtPath(databasePath as String) {
            let contactDB = FMDatabase(path: databasePath as String)
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            if contactDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)"
                if !contactDB.executeStatements(sql_stmt){
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close()
            }else {
                print("Error: \(contactDB.lastErrorMessage())")
            }
        }
        
        print("hello world")///commit 1
    }

    @IBAction func saveData(sender: AnyObject) {
        if ((name.text?.isEmpty ) != false || (address.text?.isEmpty) != false || (phone.text?.isEmpty != false)) {
            let alertController = UIAlertController(title: "Error", message: "Please Fill Up Every Textfield", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
    
            let insertSQL = "INSERT INTO CONTACTS (name, address, phone) VALUES ('\(name.text!)', '\(address.text!)', '\(phone.text!)')"
            
            let result = contactDB.executeUpdate(insertSQL,
                withArgumentsInArray: nil)
            
            if !result {
                status.text = "Failed to add contact"
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                status.text = "Contact Added"
                name.text = ""
                address.text = ""
                phone.text = ""
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        }
    }
    
    @IBAction func findContact(sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT address, phone FROM CONTACTS WHERE name = '\(name.text!)'"
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                address.text = results!.stringForColumn("address")
                phone.text = results!.stringForColumn("phone")
                status.text = "Record Found"
            }else {
                status.text = "Record not found"
                address.text = ""
                phone.text = ""
            }
            contactDB.close()
        }else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTestSegue" {
            if let testViewController = segue.destinationViewController as? TestViewController {
        
                testViewController.address = address.text!
                testViewController.phone = phone.text!
                self.delegate = testViewController
                self.delegate?.viewcontrollerdelegate(self)
            }
        }
    }

}

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}























