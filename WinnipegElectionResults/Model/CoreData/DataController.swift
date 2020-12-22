//
//  DataController.swift
//  WinnipegElectionResults
//
//  Created by Cédric Morier-Roy on 2020-12-13.
//

//
//  DataController.swift
//  VirtualTourist-UdacityProject5
//
//  Created by Cédric Morier-Roy on 2020-11-16.
//

import Foundation
import CoreData

class DataController
{
    let persistenContainer:NSPersistentContainer
    var viewContext:NSManagedObjectContext
    {
        return persistenContainer.viewContext
    }
    
    var backgroundContext: NSManagedObjectContext!
    
    init(modelName:String)
    {
        persistenContainer = NSPersistentContainer(name: modelName)
    }
    
    func configureContexts()
    {
        backgroundContext = persistenContainer.newBackgroundContext()
        
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load(completion: (()->Void)? = nil)
    {
        persistenContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else
            {
                fatalError(error!.localizedDescription)
            }
            self.configureContexts()
            completion?()
        }
    }
    
    func saveContext()
    {
        try? viewContext.save()
    }
    
    static let shared = DataController(modelName: "WinnipegElectionResults")
}

