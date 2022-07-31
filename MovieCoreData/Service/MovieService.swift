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
    
}
