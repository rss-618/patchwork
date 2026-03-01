import CoreData
import Foundation

@MainActor
let sharedPersistenceController: PersistenceController = {
    let cloudKitContainerIdentifier = Bundle.main.object(
        forInfoDictionaryKey: "CloudKitContainerIdentifier"
    ) as? String

    return PersistenceController(
        inMemory: false,
        cloudKitContainerIdentifier: cloudKitContainerIdentifier
    )
}()

@MainActor
func makeBackgroundContext(
    transactionAuthor: String = "background"
) -> NSManagedObjectContext {
    let context = sharedPersistenceController.container.newBackgroundContext()
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    context.automaticallyMergesChangesFromParent = true
    context.transactionAuthor = transactionAuthor
    return context
}
