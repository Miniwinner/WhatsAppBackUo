import UIKit
import SnapKit

class DialogueVC: VcWithBackGround {
    
    let collectionDialogue = DialogueCollection()
    
    private var data: DialogueModel?
    
    let btnUP = UIButton() --> {
        $0.setTitle("UP", for: .normal)
        $0.layer.cornerRadius = 25
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .custom(type: .glSemiBold, size: 14)
        $0.makeWhite()
    }
    
    let btnDown = UIButton() --> {
        $0.setTitle("Down", for: .normal)
        $0.layer.cornerRadius = 25
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .custom(type: .glSemiBold, size: 14)
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
        collection.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func scrollDown() {
        let indexPath = IndexPath(row: 0, section: (data?.messages.count ?? 1) - 1)
        collection.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}

private extension DialogueVC {
    
    func prepareAll() {
        topElement.title = dialogueTitle
        topElement.titleLbl.textAlignment = .center
        btnUP.addTarget(self, action: #selector(scrollUP), for: .touchUpInside)
        btnDown.addTarget(self, action: #selector(scrollDown), for: .touchUpInside)
    }
    
    func prepareSubs() {
        view.addSubview(collection)
        
        
        view.addSubview(btnUP)
        btnUP.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(50)
            make.width.equalTo(102)
        }
        
        collection.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(10)
        }
        
        view.addSubview(btnDown)
        btnDown.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(50)
            make.width.equalTo(102)
        }
    }
}
