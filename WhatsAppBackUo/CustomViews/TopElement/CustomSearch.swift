import UIKit
import SnapKit

final class CustomSearch: UIView {
   
    let textField = UITextField() --> {
        $0.textColor = .black
        $0.font = .custom(type: .glBlack, size: 20)
        $0.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [
                            .foregroundColor: UIColor.black,
                            .font: UIFont.custom(type: .glBlack, size: 20)])
    }
    
    let searchImage: UIImageView = .init(image: UIImage(named: "search"))
    let clearBtn = UIButton() --> {
        $0.setImage(UIImage(named: "close"), for: .normal)
        $0.isHidden = true

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareAll()
        prepareSubs()
        prepareKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func textChangedM() {
        
        guard let text = textField.text else { return }
       
        if text == "" {
            clearBtn.isHidden = true
        } else {
            clearBtn.isHidden = false
        }
    }
    
    @objc func clearText() {
        textField.text = ""
        clearBtn.isHidden = true
        
    }
    
    @objc func hideSearch() {
        textField.resignFirstResponder()
    }
    
}

private extension CustomSearch {
    
    func prepareKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(hideSearch))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    func prepareAll() {
        layer.cornerRadius = 22
        backgroundColor = .white
        textField.delegate = self
        textField.addTarget(self, action: #selector(textChangedM), for: .editingChanged)
        clearBtn.addTarget(self, action: #selector(clearText), for: .touchUpInside)
    }
    
    func prepareSubs() {
        addSubview(searchImage)
        searchImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
            make.left.equalToSuperview().inset(10)
        }
        addSubview(clearBtn)
        clearBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalTo(searchImage.snp.right).offset(5)
            make.right.equalTo(clearBtn.snp.left).offset(5)
            make.verticalEdges.equalToSuperview().inset(2)
        }
    }
    
}

extension CustomSearch: UITextFieldDelegate {
    
    
    
}
