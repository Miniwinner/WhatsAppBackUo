import UIKit

protocol GalleryRouterLogic {
    func procedToChatMedia(with model: DialogueModel, isDocs: Bool)
    func pushToPlayer(itemNumber: Int,data: DialogueModel)
}

class GalleryRouter: GalleryRouterLogic {
   
    
    
    weak var viewController: UIViewController?
    
    func procedToChatMedia(with model: DialogueModel, isDocs: Bool = false) {
        let source = viewController
        let destintaion = ChatMediaVC(isDocuments: isDocs)
        destintaion.hidesBottomBarWhenPushed = true
        destintaion.loadData(model: model)
        showChatMedia(source!, destintaion)
    }
    
    func pushToPlayer(itemNumber: Int, data: DialogueModel) {
        let source = viewController
        let destintaion = MediaVC()
        destintaion.hidesBottomBarWhenPushed = true
        destintaion.prepareData(index: itemNumber-1, data: data)
        showChatMedia(source!, destintaion)
    }
    
    func pushToSolo(path: String) {
        let source = viewController
        let destination = DocsSoloVC()
        destination.loadWithData(path: path)
        showChatMedia(source!, destination)
    }
    
}

private extension GalleryRouter {
    
    func showChatMedia(_ from: UIViewController, _ to: UIViewController) {
        from.navigationController?.pushViewController(to, animated: true)
    }
    
}
