//
//  Movie+CoreDataProperties.swift
//  MovieBrowser
//
//  Created by Luigi on 20/11/2022.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var overview: String?
    @NSManaged public var runtime: Int32
    @NSManaged public var poster: Data?
    @NSManaged public var genres: NSSet?

}

// MARK: Generated accessors for genres
extension Movie {

    @objc(addGenresObject:)
    @NSManaged public func addToGenres(_ value: Genre)

    @objc(removeGenresObject:)
    @NSManaged public func removeFromGenres(_ value: Genre)

    @objc(addGenres:)
    @NSManaged public func addToGenres(_ values: NSSet)

    @objc(removeGenres:)
    @NSManaged public func removeFromGenres(_ values: NSSet)

}

extension Movie : Identifiable {

}
