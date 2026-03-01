import CoreData
import Foundation

actor LiveMoodboardRepository: MoodboardRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    @MainActor
    static func live() -> LiveMoodboardRepository {
        LiveMoodboardRepository(
            context: makeBackgroundContext(
                transactionAuthor: "moodboard-repository"
            )
        )
    }

    func fetchMoodboardSummaries() throws -> [MoodboardSummary] {
        try performOnContext {
            let request = NSFetchRequest<NSDictionary>(entityName: "Moodboard")
            request.resultType = .dictionaryResultType
            request.propertiesToFetch = [
                "objectID", "id", "title", "canvasWidth", "canvasHeight", "updatedAt"
            ]
            request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
            request.fetchBatchSize = 50

            let rows = try context.fetch(request)

            return rows.compactMap { row in
                guard
                    let id = row["id"] as? UUID,
                    let title = row["title"] as? String,
                    let canvasWidth = doubleValue(row["canvasWidth"]),
                    let canvasHeight = doubleValue(row["canvasHeight"]),
                    let updatedAt = row["updatedAt"] as? Date
                else {
                    return nil
                }

                return MoodboardSummary(
                    id: id,
                    title: title,
                    canvasWidth: canvasWidth,
                    canvasHeight: canvasHeight,
                    updatedAt: updatedAt
                )
            }
        }
    }

    func fetchMoodboard(id: UUID) throws -> MoodboardDetail? {
        try performOnContext {
            let request = MoodboardModel.fetchRequest()
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.relationshipKeyPathsForPrefetching = ["items"]

            guard let moodboard = try context.fetch(request).first else {
                return nil
            }

            return MoodboardDetail(moodboard)
        }
    }

    @discardableResult
    func createMoodboard(
        title: String,
        canvasWidth: Double,
        canvasHeight: Double
    ) throws -> MoodboardDetail {
        try performOnContext {
            let moodboard = MoodboardModel(
                context: context,
                id: .init(),
                title: title,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
                createdAt: .init(),
                updatedAt: .init()
            )

            if context.hasChanges {
                try context.save()
            }

            guard let detail = MoodboardDetail(moodboard) else {
                throw MoodboardError.invalidData
            }

            return detail
        }
    }

    func saveChanges() throws {
        try performOnContext {
            if context.hasChanges {
                try context.save()
            }
        }
    }

    private func doubleValue(_ value: Any?) -> Double? {
        if let value = value as? Double {
            return value
        }
        if let value = value as? NSNumber {
            return value.doubleValue
        }
        return nil
    }

    private func performOnContext<T>(
        _ work: () throws -> T
    ) throws -> T {
        var result: Result<T, Error>!
        context.performAndWait {
            result = Result {
                try work()
            }
        }
        return try result.get()
    }
}
