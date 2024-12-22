import UIKit
import SnapKit

protocol UserInteredValid: AnyObject {
    func callCoo(_ viewController: UIViewController)
}

class LockScreenVC: UIViewController {

    private var flow: Bool = false
    weak var delegate: UserInteredValid?
    
    lazy var topElement = TopElement(type: .backTitle)
    let lockView = LockView()
    let backView = UIImageView() --> {
        $0.image = UIImage(named: "back")
    }
    
    init(flow: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.flow = flow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        addTopElement()
        prepareTextField()
        prepareKeyboard()
    }
    
    @objc func boxTapped() {
        lockView.textField.becomeFirstResponder()
    }
    
    @objc func userIntered() {
        if flow { userInteredFlow() } else { userLogging() }
    }
    
    @objc func pop() {
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonTapped() {
        if flow {
            guard let text = lockView.textField.text else { return }
            if text == "" {} else {
                UserDefaults.standard.setValue(text, forKey: "password")
                UserDefaults.standard.setValue(true, forKey: "applocked")
                lockView.textField.resignFirstResponder()
                navigationController?.popViewController(animated: true)
            }
        } else {
            guard var text = lockView.textField.text else { return }
            if text == UserDefaults.standard.value(forKey: "password") as? String {
                print("gotcha")
                lockView.textField.resignFirstResponder()
                delegate?.callCoo(self)
            } else {
                lockView.clearBoxes()
                lockView.textField.text = ""
                lockView.textField.resignFirstResponder()
            }
        }
    }
}

private extension LockScreenVC {
    
    func userInteredFlow() {
        guard let text = lockView.textField.text else { return }
        print(text)
        if text.count > 4 {
            lockView.textField.text = String(text.prefix(4))
        }
        
        lockView.updateTextBoxes(with: lockView.textField.text ?? "")
        
        if lockView.textField.text?.count == 4 {
//            UserDefaults.standard.setValue(true, forKey: "applocked")
//            UserDefaults.standard.setValue(text, forKey: "password")
        }
    }
    
    func userLogging() {
        guard let text = lockView.textField.text else { return }
        print(text)
        if text.count > 4 {
            lockView.textField.text = String(text.prefix(4))
        }
        
        lockView.updateTextBoxes(with: lockView.textField.text ?? "")
        
        if lockView.textField.text?.count == 4 {
            if lockView.textField.text == UserDefaults.standard.value(forKey: "password") as? String {
                print("user logged in")
                delegate?.callCoo(self)
                   
            }
        }
    }
    
    func prepareKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        lockView.textField.inputAccessoryView = toolbar
    }
    
    func prepareTextField() {
        lockView.textField.becomeFirstResponder()
        lockView.textField.delegate = self
        lockView.textField.addTarget(self, action: #selector(userIntered), for: .editingChanged)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(boxTapped))
        topElement.backBtn.addTarget(self, action: #selector(pop), for: .touchUpInside)
        lockView.addGesture(gesture)
    }
    
    func prepareView() {
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.pad ? -80:-60)
        }
        view.addSubview(lockView)
        lockView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 60:16)
        }
    }
    
    func addTopElement() {
        if flow {
            topElement.title = "Enable Password"
            view.addSubview(topElement)
            topElement.snp.makeConstraints { make in
                make.height.equalTo(UIDevice.pad ?  88:52)
                make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:16)
                make.top.equalToSuperview().inset(UIDevice.pad ? 80:56)
            }
        }
    }
    
}

extension LockScreenVC: UITextFieldDelegate {
  
}
