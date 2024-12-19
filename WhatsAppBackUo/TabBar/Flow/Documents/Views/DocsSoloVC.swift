
import UIKit

final class DocsSoloVC: VcWithBackGround {

    lazy var videoHolder: MediaPlayerView = .init()
    
    lazy var imageHolder: UIImageView = .init()
    
    lazy var docsHolder = UIView() --> {
        $0.backgroundColor = UIColor(redc: 31, greenc: 26, bluec: 65, alphac: 1)
    }
    
    override func viewDidLoad() {
        topElement = TopElement(type: .backTitleLogo)
        super.viewDidLoad()

    }
    
    

}
