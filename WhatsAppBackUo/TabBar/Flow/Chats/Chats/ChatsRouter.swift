import UIKit

protocol ChatsRouterLogic {
    
    func prepareToPushQR()
    func openDialogueLogic(_ model: DialogueModel)
}

final class ChatsRouter: ChatsRouterLogic {
    
    
    
    var viewController: ChatsVC?
    
    func openDialogueLogic(_ model: DialogueModel) {
        let from = viewController
        let to = DialogueVC()
        to.hidesBottomBarWhenPushed = true
        to.prepareData(model)
        pushDialogue(from: from!, to: to)
    }
    
    func prepareToPushQR() {
        let from = viewController
        let to = QrViewController()
        pushQR(from: from!, to: to)
    }
    
}

private extension ChatsRouter {
    
    func pushQR(from: UIViewController, to: UIViewController) {
        from.navigationController?.pushViewController(to, animated: true)
    }
    
    
    func pushDialogue(from: UIViewController, to: UIViewController) {
        from.navigationController?.pushViewController(to, animated: true)
    }
}
