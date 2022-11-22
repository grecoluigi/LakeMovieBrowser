//
//  Genre+CoreDataProperties.swift
//  MovieBrowser
//
//  Created by Luigi on 20/11/2022.
//
//

import Foundation
import CoreData


extension Genre {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Genre> {
        return NSFetchRequest<Genre>(entityName: "Genre")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var movie: NSSet?

}

// MARK: Generated accessors for movie
extension Genre {

    @objc(addMovieObject:)
    @NSManaged public func addToMovie(_ value: Movie)

    @objc(removeMovieObject:)
    @NSManaged public func removeFromMovie(_ value: Movie)

    @objc(addMovie:)
    @NSManaged public func addToMovie(_ values: NSSet)

    @objc(removeMovie:)
    @NSManaged public func removeFromMovie(_ values: NSSet)

}

extension Genre : Identifiable {

}
