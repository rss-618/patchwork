import CoreData
import Foundation

@objc(ImageItem)
final class ImageItem: BoardItem {
    @NSManaged var imageLocalPath: String?
    @NSManaged var opacity: Double
    @objc(cropX) @NSManaged private var cropXStorage: NSNumber?
    @objc(cropY) @NSManaged private var cropYStorage: NSNumber?
    @objc(cropWidth) @NSManaged private var cropWidthStorage: NSNumber?
    @objc(cropHeight) @NSManaged private var cropHeightStorage: NSNumber?
    @NSManaged var assetIdentifier: String?

    @nonobjc class func fetchRequest() -> NSFetchRequest<ImageItem> {
        NSFetchRequest<ImageItem>(entityName: "ImageItem")
    }

    var cropX: Double? {
        get { cropXStorage?.doubleValue }
        set { cropXStorage = newValue.map { NSNumber(value: $0) } }
    }

    var cropY: Double? {
        get { cropYStorage?.doubleValue }
        set { cropYStorage = newValue.map { NSNumber(value: $0) } }
    }

    var cropWidth: Double? {
        get { cropWidthStorage?.doubleValue }
        set { cropWidthStorage = newValue.map { NSNumber(value: $0) } }
    }

    var cropHeight: Double? {
        get { cropHeightStorage?.doubleValue }
        set { cropHeightStorage = newValue.map { NSNumber(value: $0) } }
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
        imageLocalPath: String,
        opacity: Double,
        cropX: Double?,
        cropY: Double?,
        cropWidth: Double?,
        cropHeight: Double?,
        assetIdentifier: String?
    ) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ImageItem", in: context) else {
            fatalError("Missing Core Data entity description for ImageItem")
        }

        self.init(entity: entity, insertInto: context)
        self.id = id
        self.moodboard = moodboard
        self.zIndex = zIndex
        self.transform = transform
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
        self.imageLocalPath = imageLocalPath
        self.opacity = opacity
        self.cropX = cropX
        self.cropY = cropY
        self.cropWidth = cropWidth
        self.cropHeight = cropHeight
        self.assetIdentifier = assetIdentifier
    }
}
