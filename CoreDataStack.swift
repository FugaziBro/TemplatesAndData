//
//  CoreDataStack.swift
//  DogWalk
//
//  Created by Бакулин Семен Александрович on 23.10.2020.
//  Copyright © 2020 Razeware. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Fast coreDataStack with container's private context

final class CoreDataStack {
  
  private let modelName: String
  
  lazy private var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    container.loadPersistentStores { (decs, err) in
      if let err = err {
        fatalError("could not load persistent store")
      }
    }
    return container
  }()
  
  public lazy var managedContext: NSManagedObjectContext = {
    return self.container.viewContext
  }()
  
  public lazy var privateContext: NSManagedObjectContext = {
    return container.newBackgroundContext()
  }()
  
  public func saveContext(){
    guard self.managedContext.hasChanges == true else { return }
    
    do{
      try managedContext.save()
    }catch let err as NSError {
      fatalError("could not save context \(err)")
    }
  }
  
  init(modelName:String){
    self.modelName = modelName
  }
}

//MARK: Old with parent-child context custom Coordinator url

final class oldCoreDataStack {
  private let modelName: String
  private lazy var storeUrl: URL = {
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documents.appendingPathComponent("\(self.modelName).sqlite")
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    let momUrl = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
    let mom = NSManagedObjectModel(contentsOf: momUrl)
    return mom!
  }()
  
  private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    do{
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
    }catch let err as NSError{
      fatalError("Could not load persistentStore: \(err)")
    }
    return psc
  }()
  
  public lazy var masterContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.persistentStoreCoordinator = self.persistentStoreCoordinator
    context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
    return context
  }()
  
  public lazy var mainContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.parent = self.masterContext
    context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
    return context
  }()
  
  public lazy var saveContext: NSManagedObjectContext = {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.parent = self.mainContext
    context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
    context.automaticallyMergesChangesFromParent = true
    return context
  }()
  
  public func saveContext(context: NSManagedObjectContext){
    guard context.hasChanges == true else { return }
    
    do{
      try context.save()
    }catch let err as NSError{
      fatalError("Could not save context: \(err)")
    }
    
    guard let parent = context.parent else { return }
    guard parent.hasChanges == true else { return }
    saveContext(context: parent)
  }
  
  init(modelName: String){
    self.modelName = modelName
  }
}

//MARK: - Container with custom url
 
final class UpdatedCoreDataStack {
  
  private let modelName: String
  
  private lazy var storeUrl: URL = {
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    return documents.appendingPathComponent("\(self.modelName).sqlite")
  }()
  
  lazy private var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: self.modelName)
    do{
        try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeUrl, options: nil)
    } catch let err as NSError{
      fatalError("Could not load stores")
    }
    
    container.loadPersistentStores { (decs, err) in
      if let err = err {
        fatalError("could not load persistent store")
      }
    }
    return container
  }()
  
  public lazy var managedContext: NSManagedObjectContext = {
    return self.container.viewContext
  }()
  
  public lazy var privateContext: NSManagedObjectContext = {
    return container.newBackgroundContext()
  }()
  
  public func saveContext(){
    guard self.managedContext.hasChanges == true else { return }
    
    do{
      try managedContext.save()
    }catch let err as NSError {
      fatalError("could not save context \(err)")
    }
  }
  init(modelName:String){
    self.modelName = modelName
  }
}
