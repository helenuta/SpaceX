//
//  FavoritesStore.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation
import Combine
import CoreData

@MainActor
public protocol FavoritesStoring: AnyObject {
    var ids: Set<String> { get }
    var publisher: AnyPublisher<Set<String>, Never> { get }

    func isFavorite(_ id: String) -> Bool
    func toggle(_ id: String)
    func add(_ id: String)
    func remove(_ id: String)
    func removeAll()
}

final class FavoritesStore: NSObject, ObservableObject, FavoritesStoring {
    @Published private(set) var ids: Set<String> = []

    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<FavoriteLaunch>!

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()

        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        let req: NSFetchRequest<FavoriteLaunch> = FavoriteLaunch.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        frc = NSFetchedResultsController(
            fetchRequest: req,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc.delegate = self

        try? frc.performFetch()
        ids = Set((frc.fetchedObjects ?? []).map { $0.id })
    }

    func isFavorite(_ id: String) -> Bool { ids.contains(id) }

    func toggle(_ id: String) {
        isFavorite(id) ? remove(id) : add(id)
    }

    func add(_ id: String) {
        context.perform {
            let fav = FavoriteLaunch(context: self.context)
            fav.id = id
            fav.createdAt = Date()
            do { try self.context.save() } catch {
                print("FavoritesStore add save error:", error)
            }
        }
    }

    func remove(_ id: String) {
        context.perform {
            let req: NSFetchRequest<FavoriteLaunch> = FavoriteLaunch.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", id)
            do {
                try self.context.fetch(req).forEach { self.context.delete($0) }
                try self.context.save()
            } catch {
                print("FavoritesStore remove save error:", error)
            }
        }
    }

    func removeAll() {
        context.perform {
            let req: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteLaunch")
            let batch = NSBatchDeleteRequest(fetchRequest: req)
            batch.resultType = .resultTypeObjectIDs
            do {
                if let result = try self.context.execute(batch) as? NSBatchDeleteResult,
                   let objectIDs = result.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(
                        fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                        into: [self.context]
                    )
                }
            } catch { print("FavoritesStore removeAll error:", error) }
        }
    }

    var publisher: AnyPublisher<Set<String>, Never> { $ids.eraseToAnyPublisher() }
}

extension FavoritesStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let objects = (controller.fetchedObjects as? [FavoriteLaunch]) ?? []
        let newIDs = Set(objects.map { $0.id })
        if Thread.isMainThread { self.ids = newIDs }
        else { DispatchQueue.main.async { self.ids = newIDs } }
    }
}
