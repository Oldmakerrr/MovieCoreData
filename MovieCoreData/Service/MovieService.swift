//
//  MovieService.swift
//  MovieCoreData
//
//  Created by Apple on 31.07.2022.
//

import Foundation
import CoreData
import UIKit

struct MovieService {
    
    private var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func getMovies() -> NSFetchedResultsController<Movie> {
        let fetchedResultsController: NSFetchedResultsController<Movie>
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let nameSort = NSSortDescriptor(key: "title", ascending: true)
        let raitingSort = NSSortDescriptor(key: "userRating", ascending: true)
        request.sortDescriptors = [nameSort, raitingSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: managedObjectContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            fatalError("Error in fetching records")
        }
        
        return fetchedResultsController
    }
    
    func updateRating(for movie: Movie, with newRating: Int) {
        movie.userRating = Int16(newRating)
        do {
            try managedObjectContext.save()
        } catch let error {
            print("Failed updating movie rating with error: \(error.localizedDescription)")
        }
    }
    
    func resetAllRatings(completion: (Bool) -> Void) {
        // A request to Core Data to do a batch update of data in a persistent store without loading data
        let batchUpdateRequest = NSBatchUpdateRequest(entityName: "Movie")
        batchUpdateRequest.propertiesToUpdate = ["userRating": 0]
        batchUpdateRequest.resultType = .updatedObjectIDsResultType
        
        do {
            if let batchUpdateResult = try managedObjectContext.execute(batchUpdateRequest) as? NSBatchUpdateResult {
                //We get array of objectId and then we will try to get managedObject
                if let objectId = batchUpdateResult.result as? [NSManagedObjectID] {
                    objectId.forEach {
                        let managedObject = managedObjectContext.object(with: $0)
                        /*
                         Managed objects typically represent data held in a persistent store. In some situations a managed object may be a fault—an object whose property values haven’t yet been loaded from the external data store. When you access persistent property values, the fault “fires” and the data is retrieved from the store automatically.
                         */
                        if !managedObject.isFault {
                            managedObjectContext.stalenessInterval = 0
                            managedObjectContext.refresh(managedObject, mergeChanges: true)
                        }
                    }
                    
                    completion(true)
                }
            }
              
        } catch {
            completion(false)
        }
    }
    
}
