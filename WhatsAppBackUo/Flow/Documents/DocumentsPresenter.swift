import UIKit

final class DocumentsPresenter {
    
    weak var view: DocumentsVC?
    private var data: [DialogueModel] = []
    private var dataSearch: [DialogueModel] = []
    
    
    init(view: DocumentsVC? = nil) {
        self.view = view
        self.data = SceneManager.shared.model
        SceneManager.shared.dataLoaded = { [weak self] data in
            self?.data = data
            self?.view?.updateWithData(data)
            
        }
    }
    
    func loadData() {
        view?.updateWithData(data)
    }
    
    func filterData(text: String) {
        if text == "" {
            view?.updateWithFilterData(data)
        } else {
            for i in data {
                if i.participants[0].contains(text) {
                    dataSearch.append(i)
                }
            }
            view?.updateWithFilterData(dataSearch)
            dataSearch = []
        }
    }
    
}
