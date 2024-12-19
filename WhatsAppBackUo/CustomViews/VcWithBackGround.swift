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
    
    lazy var search = CustomSearch()
    lazy var collection = ChatList()
    
    
    lazy var lblNoResults = UILabel() --> {
        $0.text = "No results were found"
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 20)
        $0.isHidden = true
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAll()
        addBack()
    }
    
    func searchEnter() {
        print("enter")
    }
    
    func clearText() {
        print("cleared")
    }
    
    func relodViewIFNeded(_ data: [DialogueModel]) {
        print("value for dataLoaded - \(UserDefaults.standard.value(forKey: "dataLoaded") as! Bool)")
        if data.count == 0 {
            self.noContentView.isHidden = false
        } else {
            DispatchQueue.main.async {
                if UserDefaults.standard.value(forKey: "dataLoaded") as! Bool == true {
                    self.noContentView.isHidden = true
                    self.collection.putData(data)
                } else {
                    if data.count != 0 {
                        self.noContentView.isHidden = true
                        self.collection.putData(data)
                        self.uiWhenData()
                        self.view.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func uiWhenData() {
        noContentView.isHidden = true
        view.addSubview(search)
        search.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        view.addSubview(lblNoResults)
        lblNoResults.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(22)
            make.top.equalTo(search.snp.bottom).offset(15)
        }
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.equalTo(search.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
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
        UserDefaults.standard.setValue(true, forKey: "dataLoaded")
        print(UserDefaults.standard.value(forKey: "dataLoaded") as! Bool)
        if let url = URL(string: "whatsapp://") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("WhatsApp не установлен на устройстве")
            }
        }
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
            make.bottom.equalToSuperview().inset(-60)
        }
        view.addSubview(topElement!)
        topElement!.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(56)
        }
        
        view.addSubview(noContentView)
        noContentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(30)
        }
        
    }
}
