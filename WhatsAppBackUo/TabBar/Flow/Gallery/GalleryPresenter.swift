import UIKit

enum MediaTypeMine {
   case photo
    case video
    case audio
}

final class GalleryPresenter {
    
    var view: GalleryVC?
    var data: [DialogueModel] = []
    var dataSearch: [DialogueModel] = []
    
  
    init(view: GalleryVC? = nil) {
        self.view = view
        self.data = SceneManager.shared.model
        print("gallery presenter inited")
        SceneManager.shared.dataLoadedGal = { [weak self] data in
            self?.data = data
            self?.view?.updateData(model: data)
        }
    }
    
    func loadData() {
        print("loading data")
        view?.updateData(model: data)
    }
    
    func filterData(text: String) {
        if text == "" {
            view?.updateWithFilterData(data: data)
        } else {
            for i in data {
                if i.participants[0].contains(text) {
                    dataSearch.append(i)
                }
            }
            view?.updateWithFilterData(data: dataSearch)
            dataSearch = []
        }
    }
    
    
}
