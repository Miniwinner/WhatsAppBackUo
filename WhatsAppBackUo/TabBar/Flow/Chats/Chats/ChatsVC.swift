import UIKit
import SnapKit

protocol DisplayLogic {
    func load(_ data: [DialogueModel])
    func filterData(_ data: [DialogueModel])
}

class ChatsVC: VcWithBackGround {
    
    private var router: ChatsRouterLogic?
    private var presenter: ChatsPresenter?
    
    override func viewDidLoad() {
        topElement = TopElement(type: .title3btn)
        prepareManagers()
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "dataLoaded") as! Bool == true {
            uiWhenData()
        }
        presenter?.loadData()
        prepareScreen()
        
    }
    
    @objc func pushQr() {
        router?.prepareToPushQR()
    }
    
    override func searchEnter() {
        super.searchEnter()
        guard let text = search.textField.text else { return }
        presenter?.filterData(text: text)
    }
    
    override func clearText() {
        super.clearText()
        presenter?.filterData(text: "")
    }
    
}

private extension ChatsVC {
    
    func prepareManagers() {
        let router = ChatsRouter()
        router.viewController = self
        self.router = router
        
        let presenter = ChatsPresenter()
        presenter.view = self
        self.presenter = presenter
    }
    
    func prepareScreen() {
        topElement.title = locApp(for: "Chats")
        topElement.qrcodeBtn.addTarget(self, action: #selector(pushQr), for: .touchUpInside)
        collection.collectionDelegate = self
    }
}

extension ChatsVC: DisplayLogic {
    func filterData(_ data: [DialogueModel]) {
        collection.putData(data)
        lblNoResults.isHidden = !data.isEmpty
    }
    
    func load(_ data: [DialogueModel]) {
        relodViewIFNeded(data)
    }
    
}
extension ChatsVC: CollectionListDelegate {
    func reactToPush(_ model: DialogueModel) {
        router?.openDialogueLogic(model)
        search.textField.resignFirstResponder()
    }
}
