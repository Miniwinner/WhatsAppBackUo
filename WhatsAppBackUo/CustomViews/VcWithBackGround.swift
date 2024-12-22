import UIKit
import SnapKit

class VcWithBackGround: UIViewController {
    
    var lblTitle: String = ""
    
    var textFiledText: String {
        guard let text = search.textField.text else { return "" }
        return text
    }
    
    var topElement: TopElement!
    
    let backView: UIImageView = .init(image: UIImage(named: "back"))
    let noContentView = NoContentView() --> {
        $0.isHidden = true
    }
    
    lazy var linkToView: CustomTabBar?  = nil {
        didSet {
            print("view was set")
        }
    }
    
    lazy var loader = LoaderView(withLbl: false) --> {
        $0.isHidden = true
    }
    
    lazy var search = CustomSearch()
    lazy var collection = ChatList()
    
    
    lazy var lblNoResults = UILabel() --> {
        $0.text = "No results were found"
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 35: 20)
        $0.isHidden = true
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAll()
        addBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        linkToView?.isHidden = false
    }
    
   
    
    func searchEnter() {
        print("enter")
    }
    
    func clearText() {
        print("cleared")
    }
    
    func relodViewIFNeded(_ data: [DialogueModel],vc: VCType) {
        
        if data.count == 0 {
            self.noContentView.isHidden = false
        } else {
            self.noContentView.isHidden = true
            collection.putData(data,vc: vc)
            if !SceneManager.shared.firstLaunch {
                self.loader.isHidden = false
                DispatchQueue.main.async {
                    
                    self.loader.prepareAnimation(flow: true)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    self.load()
                }
            } else {
                self.loader.isHidden = true
                self.search.isHidden = false
                self.collection.isHidden = false
                self.uiWhenData()
            }
        }
    }
    
    private func load() {
        self.loader.isHidden = true
        self.search.isHidden = false
        self.collection.isHidden = false
        self.uiWhenData()
    }
    
    func uiWhenData() {
        view.addSubview(search)
        search.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(UIDevice.pad ? 40:20)
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:20)
            make.height.equalTo(UIDevice.pad ? 74:44)
        }
        view.addSubview(lblNoResults)
        lblNoResults.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:16)
            make.height.equalTo(UIDevice.pad ? 40:22)
            make.top.equalTo(search.snp.bottom).offset(UIDevice.pad ? 30:15)
        }
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.equalTo(search.snp.bottom).offset(UIDevice.pad ? 40:20)
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:16)
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
    
}

//MARK: - ACTIONS
extension VcWithBackGround {
    @objc func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func importChat() {
        if let url = URL(string: "whatsapp://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("WhatsApp не установлен на устройстве")
            }
        }
        search.isHidden = true
        collection.isHidden = true
    }
    
    @objc func ask() {
        let vc = OnboardingVC(fromFlow: true)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func call() {
        searchEnter()
    }
    
    @objc private func clearTextcall() {
        clearText()
    }
    
}

private extension VcWithBackGround {
    
    func prepareAll() {
        search.textField.addTarget(self, action: #selector(call), for: .editingChanged)
        search.clearBtn.addTarget(self, action: #selector(clearTextcall), for: .touchUpInside)
        navigationController?.setNavigationBarHidden(true, animated: false)
        topElement.backBtn.addTarget(self, action: #selector(pop), for: .touchUpInside)
        topElement.plusBtn.addTarget(self, action: #selector(importChat), for: .touchUpInside)
        topElement.askBtn.addTarget(self, action: #selector(ask), for: .touchUpInside)
        topElement.title = lblTitle
    }
    
    func addBack() {
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.pad ? -80:-60)
        }
        view.addSubview(topElement!)
        topElement!.snp.makeConstraints { make in
            make.height.equalTo(UIDevice.pad ? 88:52)
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:16)
            make.top.equalToSuperview().inset(UIDevice.pad ? 90:56)
        }
        
        view.addSubview(noContentView)
        noContentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:30)
        }
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        
    }
    
    
}
