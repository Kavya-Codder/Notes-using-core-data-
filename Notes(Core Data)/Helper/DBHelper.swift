//
//  DBHelper.swift
//  Notes(Core Data)
//
//  Created by Sunil Developer on 13/01/23.
//

import Foundation
import CoreData
import UIKit

class DBHelper {
    func insertData(object: [String: Any]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // create an entity with user
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        
        //create new record with this user entity.
        let notesManagedObjet = NSManagedObject(entity: entity!, insertInto: context) as! Notes
        
        // set values for the records
        
        notesManagedObjet.id = object["id"] as? Int32 ?? 0
        notesManagedObjet.title = object["title"] as? String ?? ""
        notesManagedObjet.date = object["date"] as? String ?? ""
        notesManagedObjet.status = object["status"] as? String ?? ""
        notesManagedObjet.priority = object["priority"] as? String ?? ""
        notesManagedObjet.descraption = object["descraption"] as? String ?? ""
        
        // save the manage object to the core data.
        
        do {
            try context.save()
        } catch (let error){
            print(error.localizedDescription)
        }
        
    }
    
    func fetchStoredData() -> [Notes] {
        var notesArray: [Notes] = []
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        do {
            let fetchedRequest = try context.fetch(request) as! [Notes]
            notesArray = fetchedRequest
//            for data in fetchedRequest {
//                print(data.id)
//                print(data.title)
//            }
        } catch (let error) {
            print(error.localizedDescription)
        }
        return notesArray
    }
    
    // delete object fron core data
    
    func deleteRecord(id: Int32, index: Int){
        // get the object of appdelegate
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // create a context fron the container
        
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                
                let obj = results.first as! NSManagedObject
                context.delete(obj)
            }
            try context.save()
            self.fetchStoredData()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    //updateRecord
    
    func updateRecord(id: Int32, title: String, date: String, priority: String, status: String, discraption: String)  {
        
        //get the object of app delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //we need to create a context from the container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        let predicate = NSPredicate(format: "id == %@", "\(id)")
        
        fetchRequest.predicate = predicate
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            if !results.isEmpty {
                let Obj = results.first as! NSManagedObject
                Obj.setValue(status, forKeyPath: "status")
                Obj.setValue(title, forKey: "title")
                Obj.setValue(date, forKeyPath: "date")
                Obj.setValue(priority, forKey: "priority")
                Obj.setValue(discraption, forKeyPath: "descraption")
                
            }
            try managedContext.save()
            self.fetchStoredData()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
    
    func filter(text: String) -> [Notes]{
        var notesArray: [Notes] = []
         let appdelegate = UIApplication.shared.delegate as! AppDelegate
        // create a context fron the container

        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Notes>(entityName: "Notes")
        let predicate = NSPredicate(format: "(status=%@) OR (date=%@) OR (priority=%@)", text, text, text)
        fetchRequest.predicate = predicate

        do
        {
            let results = try context.fetch(fetchRequest)
            notesArray = results

            print(notesArray)
            try context.save()
           // self.fetchStoredData()
        } catch(let error) {
            print(error.localizedDescription)
        }
        return notesArray
    }

    
}



