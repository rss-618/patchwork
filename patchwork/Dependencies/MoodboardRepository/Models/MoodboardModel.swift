import CoreData
import Foundation

@objc(MoodboardModel)
final class MoodboardModel: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var title: String?
    @NSManaged var canvasWidth: Double
    @NSManaged var canvasHeight: Double
    @NSManaged var createdAt: Date?
    @NSManaged var updatedAt: Date?
    @NSManaged var items: Set<BoardItem>?

    @nonobjc class func fetchRequest() -> NSFetchRequest<MoodboardModel> {
        NSFetchRequest<MoodboardModel>(entityName: "Moodboard")
    }

    var sortedItems: [BoardItem] {
        (items ?? [])
            .filter { $0.deletedAt == nil }
            .sorted { $0.zIndex < $1.zIndex }
    }

    convenience init(
        context: NSManagedObjectContext,
        id: UUID,
        title: String,
        canvasWidth: Double,
        canvasHeight: Double,
        createdAt: Date,
        updatedAt: Date
    ) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Moodboard", in: context) else {
            fatalError("Missing Core Data entity description for Moodboard")
        }

        self.init(entity: entity, insertInto: context)
        self.id = id
        self.title = title
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.items = []
    }

    func touch(_ timestamp: Date) {
        updatedAt = timestamp
    }
}
