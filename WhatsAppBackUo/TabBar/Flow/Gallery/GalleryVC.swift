import SnapKit
import UIKit

protocol DisplayLogicGallery {
    func updateData(model: [DialogueModel])
    func updateWithFilterData(data: [DialogueModel])
}

final class GalleryVC: VcWithBackGround {
    
    var presenter: GalleryPresenter?
    var router: GalleryRouter?
    
    
    override func viewDidLoad() {
        topElement = TopElement(type: .title2btn)
        prepareManagers()
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "dataLoaded") as! Bool == true {
            uiWhenData()
        }
        prepareView()
        presenter?.loadData()
        
    }
    
    
    override func searchEnter() {
        super.searchEnter()
        presenter?.filterData(text: textFiledText)
    }
    
    override func clearText() {
        super.clearText()
        presenter?.filterData(text: "")
    }
    
}

private extension GalleryVC {
    
    func prepareManagers() {
        let presenter = GalleryPresenter()
        presenter.view = self
        self.presenter = presenter
        
        let router = GalleryRouter()
        router.viewController = self
        self.router = router
    }
    
    func prepareView() {
        noContentView.isHidden = true
        topElement.title = "Gallery"
        collection.collectionDelegate = self
    }
    
   
    
    
}

extension GalleryVC: DisplayLogicGallery {
   
    func updateData(model: [DialogueModel]) {
        relodViewIFNeded(model)
    }
    
    func updateWithFilterData(data: [DialogueModel]) {
        collection.putData(data)
        lblNoResults.isHidden = !data.isEmpty
    }
}

extension GalleryVC: CollectionListDelegate {
    func reactToPush(_ model: DialogueModel) {
        router?.procedToChatMedia(with: model)
    }
}
