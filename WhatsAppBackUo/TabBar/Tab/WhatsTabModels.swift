@frozen
enum TabBarTitles: String {
    case chats
    case gallery
    case documents
    case settings
    
    var text: String {
        switch self {
        case .chats:
            return locApp(for: "Chats")
        case .gallery:
            return locApp(for: "Gallery")
        case .documents:
            return locApp(for: "Documents")
        case .settings:
            return locApp(for: "Settings")
            
        }
    }
    var tabBarPhoto: String {
        return self.rawValue
    }
}

