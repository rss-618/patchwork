import CoreData
import Foundation

@objc(BoardItem)
class BoardItem: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var moodboard: MoodboardModel?
    @NSManaged var zIndex: Double
    @NSManaged private var centerXStorage: Double
    @NSManaged private var centerYStorage: Double
    @NSManaged private var widthStorage: Double
    @NSManaged private var heightStorage: Double
    @NSManaged private var rotationRadiansStorage: Double
    @NSManaged var createdAt: Date?
    @NSManaged var updatedAt: Date?
    @NSManaged var deletedAt: Date?

    @nonobjc class func fetchRequest() -> NSFetchRequest<BoardItem> {
        NSFetchRequest<BoardItem>(entityName: "BoardItem")
    }

    var transform: ItemTransform {
        get {
            ItemTransform(
                centerX: centerXStorage,
                centerY: centerYStorage,
                width: widthStorage,
                height: heightStorage,
                rotationRadians: rotationRadiansStorage
            )
        }
        set {
            centerXStorage = newValue.centerX
            centerYStorage = newValue.centerY
            widthStorage = newValue.width
            heightStorage = newValue.height
            rotationRadiansStorage = newValue.rotationRadians
        }
    }

    func applyTransform(_ transform: ItemTransform, at timestamp: Date) {
        self.transform = transform
        self.updatedAt = timestamp
    }

    func markDeleted(at timestamp: Date) {
        deletedAt = timestamp
        updatedAt = timestamp
    }
}
