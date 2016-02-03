//
//  TestViewController.swift
//  swiftSQLite
//
//  Created by Chao Xu on 2/1/16.
//  Copyright © 2016 Chao Xu. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var trydelegateLabel: UILabel!
    
    var name: String?
    var address: String?
    var phone: String?
    var trydelegate: String?
     var databasePath = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
 //       let storyboard = UIStoryboard(name: "Main", bundle: nil)
 //       let VC = storyboard.instantiateViewControllerWithIdentifier("viewcontroller") as! ViewController
 //       VC.delegate = self
        
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

    }

    
    override func viewWillAppear(animated: Bool) {
        addressLabel.text = address!
        phoneLabel.text = phone!
        trydelegateLabel.text = trydelegate
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loadDataFromSQLite(sender: AnyObject) {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT name FROM CONTACTS WHERE name = 'go'"
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                nameLabel.text = results!.stringForColumn("name")
                
            }else {
                addressLabel.text = "hello"
                phoneLabel.text = "word"
            }
            contactDB.close()
        }else {
            print("Error: \(contactDB.lastErrorMessage())")
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestViewController:viewControllerDelegate {
    func viewcontrollerdelegate(setviewcontrollerdelegate: ViewController) {
        self.trydelegate = setviewcontrollerdelegate.name.text!
    }
}
