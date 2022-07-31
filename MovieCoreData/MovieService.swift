//
//  MovieService.swift
//  MovieCoreData
//
//  Created by Apple on 31.07.2022.
//

import Foundation
import CoreData

struct MovieService {
    
    static func getMovies(moc: NSManagedObjectContext) -> NSFetchedResultsController<Movie> {
        let fetchedResultsController: NSFetchedResultsController<Movie>
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        let nameSort = NSSortDescriptor(key: "title", ascending: true)
        let raitingSort = NSSortDescriptor(key: "userRating", ascending: true)
        request.sortDescriptors = [nameSort, raitingSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            fatalError("Error in fetching records")
        }
        
        return fetchedResultsController
    }
    
}
