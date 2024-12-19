import Foundation
import CoreData


extension Dialogue {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dialogue> {
        return NSFetchRequest<Dialogue>(entityName: "Dialogue")
    }
    
    public func addToMessages(_ message: Message) {
        let messages = self.mutableSetValue(forKey: "messages")
        messages.add(message)
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var mediaCount: Int32
    @NSManaged public var participants: String?
    @NSManaged public var messages: NSSet?
    @NSManaged public var paths: String?
    @NSManaged public var date: Date?
    @NSManaged public var lastmess: String?
    
    
}

extension Dialogue : Identifiable {
    
}


