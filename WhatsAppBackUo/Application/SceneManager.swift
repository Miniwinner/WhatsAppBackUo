import UIKit

func getFilePath(path: String) -> String {
    let manager = FileManager.default
    guard let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
    return documentsURL.appendingPathComponent(path).path
    
}

func getFilePathDest(path: String,dialogueName:String) -> String {
    let sc = "WhatsUPUnzipped/\(dialogueName)/\(path)"
    let manager = FileManager.default
    guard let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
    return documentsURL.appendingPathComponent(sc).path
}

func formatAttachedPath(from input: String) -> String? {
    if let range = input.range(of: "<attached: ") {
        let start = input.index(range.upperBound, offsetBy: 0)
        let result = String(input[start..<input.endIndex])
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ">", with: "")
    }
    return nil
}


final class SceneManager {
    
    private init() {}
    
    static let shared = SceneManager()
    var model: [DialogueModel] = []
    var firstLaunch: Bool = true
    var completion: ((URL) -> Void)?
    var dataLoaded: (([DialogueModel])->Void)?
    var dataLoadedGal: (([DialogueModel])->Void)?
    
    
    
    func loadData(completion: @escaping ([DialogueModel])-> Void ) {
        DispatchQueue.main.async {
            let db = DbRequests(parent: "SCENEMANAGER")
            let data = db.fetchAllDialogues()
            self.model
            self.dataLoaded?(self.model2)
            self.dataLoadedGal?(self.model2)
            completion(self.model2)
        }
    }
    
    private let model2: [DialogueModel] = [
    DialogueModel(id: UUID(),
                  participants: ["MINE", "SELF"],
                  messages: [MessageModel(id: UUID(), sender: "MINE", content: "жfsdfdsfgsdfgsfdgsfdgsdfgsfdgsfdgdsfgsfdgfdsgfsdgsdfgdfsgfdsgdfsgsdfgsdfgsdfgdsfgdfsgdfsgdsfgdsfgsfdgdfsgsdfgsfdgfdsgsdfg gsfsggопа", contentType: .text, timestamp: Date()),
                             MessageModel(id: UUID(), sender: "MINE", content: "жопа", contentType: .text, timestamp: Date()),
                             MessageModel(id: UUID(), sender: "MINE", content: "жопа", contentType: .text, timestamp: Date()),
                             MessageModel(id: UUID(), sender: "MINE", content: "жопа", contentType: .text, timestamp: Date())],
                  mediaPaths: [],
                  documentPaths: [],
                  lastmessdate: Date(),
                  lastMessage: "привет петух"),
    DialogueModel(id: UUID(),
                  participants: ["MINE", "SELF"],
                  messages: [MessageModel(id: UUID(), sender: "MINE", content: "жопа", contentType: .text, timestamp: Date()),
                             MessageModel(id: UUID(), sender: "MINE", content: "жопа", contentType: .text, timestamp: Date()),
                             MessageModel(id: UUID(), sender: "MINE", content: "жопа", contentType: .text, timestamp: Date()),
                             MessageModel(id: UUID(), sender: "MINE", content: "жопа", contentType: .text, timestamp: Date())],
                  mediaPaths: [],
                  documentPaths: [],
                  lastmessdate: Date(),
                  lastMessage: "привет петух")
    ]
    
}
