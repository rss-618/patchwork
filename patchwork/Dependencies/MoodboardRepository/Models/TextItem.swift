import CoreData
import Foundation

@objc(TextItem)
final class TextItem: BoardItem {
    @NSManaged var text: String?
    @NSManaged var fontName: String?
    @NSManaged var fontSize: Double
    @NSManaged var fontWeight: String?
    @NSManaged var textColorHex: String?
    @NSManaged var alignmentRaw: String?

    @nonobjc class func fetchRequest() -> NSFetchRequest<TextItem> {
        NSFetchRequest<TextItem>(entityName: "TextItem")
    }

    var textStyle: TextStyle {
        get {
            TextStyle(
                fontName: fontName ?? "",
                fontSize: fontSize,
                fontWeight: fontWeight ?? "",
                textColorHex: textColorHex ?? "#000000",
                alignment: alignmentRaw.flatMap(TextAlignmentKind.init(rawValue:)) ?? .leading
            )
        }
        set {
            fontName = newValue.fontName
            fontSize = newValue.fontSize
            fontWeight = newValue.fontWeight
            textColorHex = newValue.textColorHex
            alignmentRaw = newValue.alignment.rawValue
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
        text: String,
        textStyle: TextStyle
    ) {
        guard let entity = NSEntityDescription.entity(forEntityName: "TextItem", in: context) else {
            fatalError("Missing Core Data entity description for TextItem")
        }

        self.init(entity: entity, insertInto: context)
        self.id = id
        self.moodboard = moodboard
        self.zIndex = zIndex
        self.transform = transform
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.text = text
        self.textStyle = textStyle
    }
}
