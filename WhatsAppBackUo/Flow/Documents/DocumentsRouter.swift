import UIKit
import AVKit

final class DocumentsRouter {
    
    weak var viewController: DocsSoloVC?
    weak var fromVC: UIViewController?
    
    func showFullScreen(url: URL, router: DocumentsRouter, rate: Float, time: CMTime) {
        guard let from = viewController else { return }
        let destination = FullScreenVideo()
        destination.modalPresentationStyle = .overFullScreen
        destination.loadVideo(url: url, manager: self, rate: rate, time: time)
        push(from, destiantion: destination)
    }
    
   
    
    func returnToPreviuos(time: CMTime, rate: Float) {
        guard let from = fromVC else { return }
        guard let vc = viewController else { return }
        vc.playerSetTime(time: time, rate: rate)
        hide(from)
    }
    
    
}


private extension DocumentsRouter {
    
    func push(_ from: UIViewController, destiantion to: UIViewController) {
        from.present(to, animated: true)
    }
    
    func hide(_ from: UIViewController) {
        from.dismiss(animated: true)
    }
    
}
