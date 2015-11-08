//
//  ViewController.swift
//  Core Data
//
//  Created by LAURA LUCRECIA SANCHEZ PADILLA on 15/10/15.
//  Copyright © 2015 LAURA LUCRECIA SANCHEZ PADILLA. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    @IBOutlet var lineFields:[UITextField]!
    private let lineEntityName = "Line"
    private let lineNumerKey = "lineNumber"
    private let lineTextKey = "lineText"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: lineEntityName)
        

        do{
            let objectList = try context.executeFetchRequest(request) as! [NSObject]
            
                for oneObject in objectList{
                    let lineNum = oneObject.valueForKey(lineNumerKey)!.integerValue
                    let lineText = oneObject.valueForKey(lineTextKey)as! String
                    let textField = lineFields[lineNum]
                    textField.text = lineText
                    
                }
            
        }catch let error as NSError{
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: app)
        
    }
    
    func applicationWillResignActive(notification: NSNotification){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        do{
            for var i=0; i < lineFields.count; i++ {
                let textField = lineFields[i]
                let request = NSFetchRequest(entityName: lineEntityName)
                let pred = NSPredicate(format: "%K = %d", lineNumerKey, i)
                request.predicate = pred
                
                let objectList = try context.executeFetchRequest(request) as! [NSObject]
                var theLine : NSManagedObject! = nil
                if objectList.count > 0{
                    theLine = objectList[0] as! NSManagedObject
                    
                }else{
                    theLine = NSEntityDescription.insertNewObjectForEntityForName(lineEntityName, inManagedObjectContext: context)
                }
                theLine.setValue(i, forKey: lineNumerKey)
                theLine.setValue(textField.text, forKey: lineTextKey)
            }
        }catch let error as NSError{
            print("Fetch failed: \(error.localizedDescription)")
        }
        appDelegate.saveContext()
    }


}

