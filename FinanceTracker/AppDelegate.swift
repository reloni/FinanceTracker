//
//  AppDelegate.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 13/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import UIKit
import CoreData



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSFetchedResultsControllerDelegate {
    
    let request: NSFetchRequest<CloudAccount> = {
       let r = NSFetchRequest<CloudAccount>(entityName: "CloudAccount")
        r.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        r.includesPropertyValues = true
//        r.propertiesToFetch = ["title"]
        return r
    }()

    lazy var frc = NSFetchedResultsController(fetchRequest: self.request,
                                              managedObjectContext: persistentContainer.viewContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        self.frc.delegate = self
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//            let request = try! NSFetchRequest<CloudAccount>(entityName: "CloudAccount")
//            let c = NSFetchedResultsController(fetchRequest: request, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//            let result = try! self.persistentContainer.viewContext.execute(request)
            
            
//            print(self.frc.object(at: IndexPath(item: 0, section: 0)))
            
            try! self.frc.performFetch()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            
                print(self.frc.sections?.count)
                print(self.frc.sections?[0].numberOfObjects)
                print(self.frc.fetchedObjects?.first?.title)
                print(self.frc.object(at: IndexPath(item: 0, section: 0)))
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "FinanceTracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: NSFetchedResultsController Delegate methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerWillChangeContent")
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("controllerDidChangeContent")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        print("didChange")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        print("didChange sectionInfo")
    }
}

