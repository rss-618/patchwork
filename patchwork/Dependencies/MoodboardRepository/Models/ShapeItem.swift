import CoreData
import Foundation

@objc(ShapeItem)
final class ShapeItem: BoardItem {
    @NSManaged var shapeKindRaw: String?
    @NSManaged var fillColorHex: String?
    @NSManaged var strokeColorHex: String?
    @NSManaged var strokeWidth: Double
    @objc(cornerRadius) @NSManaged private var cornerRadiusStorage: NSNumber?

    @nonobjc class func fetchRequest() -> NSFetchRequest<ShapeItem> {
        NSFetchRequest<ShapeItem>(entityName: "ShapeItem")
    }

    var shapeKind: ShapeKind {
        get {
            shapeKindRaw.flatMap(ShapeKind.init(rawValue:)) ?? .rectangle
        }
        set {
            shapeKindRaw = newValue.rawValue
        }
    }

    var cornerRadius: Double? {
        get { cornerRadiusStorage?.doubleValue }
        set { cornerRadiusStorage = newValue.map { NSNumber(value: $0) } }
    }

    var shapeStyle: ShapeStyle {
        get {
            ShapeStyle(
                fillColorHex: fillColorHex ?? "#FFFFFF",
                strokeColorHex: strokeColorHex ?? "#000000",
                strokeWidth: strokeWidth,
                cornerRadius: cornerRadius
            )
        }
        set {
            fillColorHex = newValue.fillColorHex
            strokeColorHex = newValue.strokeColorHex
            strokeWidth = newValue.strokeWidth
            cornerRadius = newValue.cornerRadius
        }
    }

    convenience init(
        context: NSManagedObjectContext,
        id: UUID,
        moodboard: MoodboardModel?,
        zIndex: Double,
        transform: ItemTransform,
        createdAt: Date,
        updatedAt: Date,
        deletedAt: Date?,
        shapeKind: ShapeKind,
        shapeStyle: ShapeStyle
    ) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ShapeItem", in: context) else {
            fatalError("Missing Core Data entity description for ShapeItem")
        }

        self.init(entity: entity, insertInto: context)
        self.id = id
        self.moodboard = moodboard
        self.zIndex = zIndex
        self.transform = transform
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.shapeKind = shapeKind
        self.shapeStyle = shapeStyle
    }
}
