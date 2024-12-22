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
        topElement = TopElement(type: .title3btn)
        prepareManagers()
        super.viewDidLoad()
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
        relodViewIFNeded(model,vc: .gallery)
    }
    
    func updateWithFilterData(data: [DialogueModel]) {
        collection.putData(data,vc: .gallery)
        lblNoResults.isHidden = !data.isEmpty
    }
}

extension GalleryVC: CollectionListDelegate {
    func reactToPush(_ model: DialogueModel) {
        router?.procedToChatMedia(with: model)
        linkToView?.isHidden = true
    }
}
