import UIKit
import SnapKit

protocol DocumentsDisplayLogic {
    func updateWithData(_ data: [DialogueModel])
    func updateWithFilterData(_ data: [DialogueModel])
}

final class DocumentsVC: VcWithBackGround {

    var presenter: DocumentsPresenter?
    var router: GalleryRouter?
    
    
    
   
    
    override func viewDidLoad() {
        topElement = TopElement(type: .title3btn)
        prepareManagers()
        super.viewDidLoad()
        prepareAll()
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

private extension DocumentsVC {
    
    func prepareManagers() {
        let presenter = DocumentsPresenter()
        presenter.view = self
        self.presenter = presenter
        
        let router = GalleryRouter()
        router.viewController = self
        self.router = router
    }
    
    func prepareAll() {
        noContentView.isHidden = true
        topElement.title = "Documents"
        collection.collectionDelegate = self
    }
}

extension DocumentsVC: DocumentsDisplayLogic {
    func updateWithData(_ data: [DialogueModel]) {
        relodViewIFNeded(data,vc: .docs)
    }
    
    func updateWithFilterData(_ data: [DialogueModel]) {
        collection.putData(data,vc: .docs)
        lblNoResults.isHidden = !data.isEmpty
    }
    
    
}

extension DocumentsVC: CollectionListDelegate {
    func reactToPush(_ model: DialogueModel) {
        router?.procedToChatMedia(with: model,isDocs: true)
        linkToView?.isHidden = true
    }
}


