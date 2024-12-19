import UIKit
import SnapKit

enum MessageViewType {
    case sender
    case reciever
}

final class MessageView: UIView {

    let lblMessage = UILabel() --> {
        $0.font = .custom(type: .glSemiBold, size: 16)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    init(type: MessageViewType) {
        super.init(frame: .zero)
        setupView(type: type)
        prepareSubs()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupView(type: MessageViewType) {
        layer.cornerRadius = 15
        switch type {
        case .sender:
            lblMessage.textColor = .white
            backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
        case .reciever:
            lblMessage.textColor = .black
            backgroundColor = .white
        }
    }
    
    private func prepareSubs() {
        addSubview(lblMessage)
        lblMessage.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.verticalEdges.equalToSuperview().inset(10)
        }
    }
    
}
