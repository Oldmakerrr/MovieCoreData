//
//  MovieTableViewController.swift
//  MovieCoreData
//
//  Created by Apple on 31.07.2022.
//

import UIKit
import CoreData

class MovieTableViewController: UITableViewController {
    
   
    private var coreData = CoreDataStack()
    private var fetchedResultController: NSFetchedResultsController<Movie>?
    private var movieService: MovieService?

    override func viewDidLoad() {
        super.viewDidLoad()
        movieService = MovieService(managedObjectContext: coreData.persistentContainer.viewContext)
        loadData()
        tableView.allowsSelection = false
        fetchedResultController?.delegate = self
    }
    
    //MARK: - Selectors
    
    @IBAction func resetRatingsAction(_ sender: UIBarButtonItem) {
        movieService?.resetAllRatings(completion: { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultController?.sections else { return 0 }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        if let movie = fetchedResultController?.object(at: indexPath) {
            cell.configureCell(movie)
            cell.userRatingHandler = { [weak self] newRating in
                self?.movieService?.updateRating(for: movie, with: newRating)
            }
        }
        return cell
    }
    
    //MARK: - Private functions
    
    private func loadData() {
        fetchedResultController = movieService?.getMovies()
    }
    
 }

//MARK: - NSFetchedResultsControllerDelegate

extension MovieTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .update:
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
