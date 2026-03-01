import CoreData
import Foundation

final class PersistenceController {
    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false, cloudKitContainerIdentifier: String? = nil) {
        container = NSPersistentCloudKitContainer(name: "Moodboard")

        guard let storeDescription = container.persistentStoreDescriptions.first else {
            fatalError("Missing persistent store description")
        }

        if inMemory {
            storeDescription.url = URL(fileURLWithPath: "/dev/null")
        }

        storeDescription.type = NSSQLiteStoreType
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldInferMappingModelAutomatically = true
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        storeDescription.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        if let cloudKitContainerIdentifier, !cloudKitContainerIdentifier.isEmpty {
            storeDescription.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: cloudKitContainerIdentifier
            )
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Could not load persistent stores: \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.transactionAuthor = "main"
    }
}
