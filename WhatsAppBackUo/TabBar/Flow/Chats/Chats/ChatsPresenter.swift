import UIKit

protocol PresentLogic: AnyObject {
    func presentNewData()
}

class ChatsPresenter {
    
    weak var view: ChatsVC?
    private var db: DbRequests?
    private var parser: DataFromWhatsUP?
    
    private var data: [DialogueModel] = []
    private var searchData: [DialogueModel] = []
    
    init(view: ChatsVC? = nil) {
        self.view = view
        print("presenter chats inited")
        SceneManager.shared.completion = { url in
            DispatchQueue.main.async {
                self.reactWhenExport(url: url)
            }
        }
    }
    
    deinit { print("presenter deinited") }
    
    func loadData() {
        SceneManager.shared.loadData { data in
            self.data = data
            self.view?.load(self.data)
        }
    }
    
   
    private func reactWhenExport(url: URL) {
        db =  DbRequests(presenter: self, parent: "ChatsPresenter")
        parser = DataFromWhatsUP(db: db)
        parser?.startData(url)
        parser = nil
        db = nil
    }
    
    
    func filterData(text: String) {
        if text == "" {
            view?.filterData(data)
        } else {
            for i in data {
                if i.participants[0].contains(text) {
                    searchData.append(i)
                }
            }
            view?.filterData(searchData)
            searchData = []
        }
    }
    
    
}

extension ChatsPresenter: PresentLogic {
    func presentNewData() {
        loadData()
    }
}
