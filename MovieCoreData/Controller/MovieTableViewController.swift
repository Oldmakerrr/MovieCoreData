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

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        }
        return cell
    }
    
    //MARK: - Private functions
    
    private func loadData() {
        fetchedResultController = MovieService.getMovies(moc: coreData.persistentContainer.viewContext)
    }
 }
