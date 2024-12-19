import UIKit
import SnapKit

class LockView: UIView {
    
    var boxes: [LockTab] = []
    
    let lblTitle = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glBold, size: 20)
        $0.textAlignment = .center
        $0.text = "Enter your password"
    }
  
    
    let textField = UITextField() --> {
        $0.keyboardType = .numberPad
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let stack = UIStackView() --> {
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        createViews()
        prepareSubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGesture(_ gesture: UITapGestureRecognizer) {
        stack.addGestureRecognizer(gesture)
    }
    
    
    
    func updateTextBoxes(with text: String) {
            for (index, box) in boxes.enumerated() {
                if index < text.count {
                    let charIndex = text.index(text.startIndex, offsetBy: index)
                    box.setText(String(text[charIndex]))
                } else {
                    box.setText("") 
                }
            }
        }
    
    func clearBoxes() {
        for (index, box) in boxes.enumerated() {
            
                box.setText("")
            
        }
    }
    
}


private extension LockView {
    
    func prepareSubs() {
        
        addSubview(textField)
        
        
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(30)
        }
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.top.equalTo(lblTitle.snp.bottom).offset(40)
            make.height.equalTo(40)
        }
    }
    
    func createViews() {
        
        for _ in 0...3 {
            let textBox = LockTab(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            boxes.append(textBox)
            stack.addArrangedSubview(textBox)
        }
        
    }
    
}
