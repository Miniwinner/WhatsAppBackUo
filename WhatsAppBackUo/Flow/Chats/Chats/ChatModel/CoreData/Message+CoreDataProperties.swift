import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var sender: String?
    @NSManaged public var content: String?
    @NSManaged public var contentType: String?
    @NSManaged public var timeStamp: Date?
    @NSManaged public var dialogue: Dialogue?

}

extension Message : Identifiable {

}
