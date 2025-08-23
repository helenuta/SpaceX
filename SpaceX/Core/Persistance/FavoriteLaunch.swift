//
//  FavoriteLaunch.swift
//  SpaceX
//
//  Created by Elena Anghel on 24.08.2025.
//

import Foundation
import CoreData

@objc(FavoriteLaunch)
public class FavoriteLaunch: NSManagedObject {}

extension FavoriteLaunch {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteLaunch> {
        NSFetchRequest<FavoriteLaunch>(entityName: "FavoriteLaunch")
    }

    @NSManaged public var id: String
    @NSManaged public var createdAt: Date
}
