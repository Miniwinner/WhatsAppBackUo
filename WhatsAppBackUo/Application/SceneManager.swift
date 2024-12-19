import UIKit

func getFilePath(path: String) -> String {
    let manager = FileManager.default
    guard let documentsURL = manager.urls(for: .documentDirectory, in: .userDomainMask).first else { return "" }
    return documentsURL.appendingPathComponent(path).path
    
}

final class SceneManager {
    
    private init() {}
    
    static let shared = SceneManager()
    var model: [DialogueModel] = [DialogueModel(id: UUID(),
                                                participants: ["Папа","SELF"],
                                                messages: [],
                                                mediaPaths: [],
                                                mediaCount: 0,
                                                lastmessdate: Date(),
                                                lastMessage: "nope"),
                                  DialogueModel(id: UUID(),
                                                             participants: ["Мама","SELF"],
                                                             messages: [],
                                                             mediaPaths: [],
                                                             mediaCount: 0,
                                                             lastmessdate: Date(),
                                                             lastMessage: "давай"),
                     ]
    
    var completion: ((URL) -> Void)?
    var dataLoaded: (([DialogueModel])->Void)?
    var dataLoadedGal: (([DialogueModel])->Void)?
    
    func loadData(completion: @escaping ([DialogueModel])-> Void ) {
        DispatchQueue.main.async {
            let db = DbRequests(parent: "SCENEMANAGER")
            let data = db.fetchAllDialogues()
//            self.model = data
            self.dataLoaded?(self.model)
            self.dataLoadedGal?(self.model)
            completion(self.model)
        }
    }
}
