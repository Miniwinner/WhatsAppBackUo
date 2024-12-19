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
        topElement = TopElement(type: .title2btn)
        prepareManagers()
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "dataLoaded") as! Bool == true {
            uiWhenData()
        }
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
    
    
    func prepareSubs(data: [DialogueModel]) {
        view.addSubview(collection)
        if data.count != 0 {
//            addSearch(view)
        }
        collection.snp.makeConstraints { make in
            if data.count != 0 {
                make.top.equalTo(search.snp.bottom).offset(15)
            } else {
                make.top.equalTo(topElement.snp.bottom).offset(15)
            }
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(60)
        }
     }
    
    
  
    
}

extension DocumentsVC: DocumentsDisplayLogic {
    func updateWithData(_ data: [DialogueModel]) {
        relodViewIFNeded(data)
    }
    
    func updateWithFilterData(_ data: [DialogueModel]) {
        collection.putData(data)
        lblNoResults.isHidden = !data.isEmpty
    }
    
    
}

extension DocumentsVC: CollectionListDelegate {
    func reactToPush(_ model: DialogueModel) {
        router?.procedToChatMedia(with: model,isDocs: true)

    }
}


