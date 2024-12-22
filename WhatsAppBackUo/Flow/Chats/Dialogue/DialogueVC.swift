import UIKit
import SnapKit

class DialogueVC: VcWithBackGround {
    
    let collectionDialogue = DialogueCollection()
    
    private var data: DialogueModel?
    
    let btnUP = UIButton() --> {
        $0.setTitle("UP", for: .normal)
        $0.layer.cornerRadius = UIDevice.pad ? 85/2:25
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 25:14)
        $0.makeWhite()
    }
    
    let btnDown = UIButton() --> {
        $0.setTitle("Down", for: .normal)
        $0.layer.cornerRadius = UIDevice.pad ? 85/2:25
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 25:14)
        $0.makeWhite()
    }
    
    private var dialogueTitle: String = ""
    
    override func viewDidLoad() {
        topElement = TopElement(type: .backTitleLogo)
        noContentView.isHidden = true
        super.viewDidLoad()
        prepareAll()
        prepareSubs()
        
    }
    
    func prepareData(_ model: DialogueModel) {
        collectionDialogue.fillWithData(model.messages, sender: (model.participants[0]))
        dialogueTitle = model.participants[0]
        self.data = model
    }

    
    
}

private extension DialogueVC {
    
    @objc func scrollUP() {
        let indexPath = IndexPath(row: 0, section: 0)
        collectionDialogue.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func scrollDown() {
        let indexPath = IndexPath(row: 0, section: (data?.messages.count ?? 1) - 1)
        collectionDialogue.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}

private extension DialogueVC {
    
    func prepareAll() {
        topElement.title = dialogueTitle
        topElement.titleLbl.textAlignment = .center
        btnUP.addTarget(self, action: #selector(scrollUP), for: .touchUpInside)
        btnDown.addTarget(self, action: #selector(scrollDown), for: .touchUpInside)
        collectionDialogue.collectionDelegate = self
    }
    
    func prepareSubs() {
        
        view.addSubview(btnUP)
        btnUP.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(UIDevice.pad ? 140:16)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(UIDevice.pad ? 85:50)
            make.width.equalTo(UIDevice.pad ? 170:102)
        }
        view.addSubview(collectionDialogue)
        
        collectionDialogue.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 80:16)
            make.top.equalTo(topElement.snp.bottom).offset(UIDevice.pad ? 40:20)
            make.bottom.equalToSuperview().inset(10)
        }
        
        view.addSubview(btnDown)
        btnDown.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(UIDevice.pad ? 140:16)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(UIDevice.pad ? 85:50)
            make.width.equalTo(UIDevice.pad ? 170:102)
        }
    }
}

extension DialogueVC: DialogueCollectionDelegate {
    func procedToCotroller(url: URL) {
        let vc = FullScreenVideo()
        vc.loadViaURL(url: url)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
}
