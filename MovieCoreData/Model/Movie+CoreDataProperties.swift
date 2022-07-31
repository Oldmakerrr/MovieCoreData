//
//  Movie+CoreDataProperties.swift
//  MovieCoreData
//
//  Created by Apple on 31.07.2022.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var format: String?
    @NSManaged public var image: Data?
    @NSManaged public var title: String?
    @NSManaged public var userRating: Int16

}

extension Movie : Identifiable {

}
