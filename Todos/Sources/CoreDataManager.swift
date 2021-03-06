//
//  CoreDataManager.swift
//  Todos
//
//  Created by Ador on 2020/12/17.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    @discardableResult
    func insertTask(taskName: String, dueDate: Date, completion: (() -> Void)?) -> Bool { // Task stuct 활용할수도
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        if let entity = entity {
            let task = NSManagedObject(entity: entity, insertInto: context)
            task.setValue(taskName, forKey: Task.Key.name.rawValue)
            task.setValue(dueDate, forKey: Task.Key.dueDate.rawValue)
            do {
                try context.save()
                completion?()
            } catch {
                print(error.localizedDescription)
                return false
            }
        }
        return true
    }
    
    @discardableResult
    func deleteTask(object: NSManagedObject, completion: (() -> Void)?) -> Bool {
        self.context.delete(object)
        do{
            try self.context.save()
            completion?()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func updatetask(id: String, taskName: String, dueDate: Date, completion: (() -> Void)?) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: Task.Key.dueDate.rawValue)
        fetchRequest.predicate = NSPredicate(format: "name = %@", NSString(string: id))
        print("updating: \(fetchRequest)")
        
        do {
            let fetchData = try context.fetch(fetchRequest)
            let task = fetchData[0] as! NSManagedObject
            task.setValue(taskName, forKey: Task.Key.name.rawValue)
            task.setValue(dueDate, forKey: Task.Key.dueDate.rawValue)
            do {
                try context.save()
                completion?()
            } catch {
                print(error.localizedDescription)
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
}

