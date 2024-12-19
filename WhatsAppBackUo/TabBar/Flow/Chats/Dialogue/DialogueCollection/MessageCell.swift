import UIKit
import SnapKit

class MessageCell: UITableViewCell {

    private var messView: MessageView?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messView?.removeFromSuperview()
        messView = nil
    }
    
    func setMessageViews(type: MessageViewType, model: MessageModel) {
        messView?.removeFromSuperview()
        
        let newMessView = MessageView(type: type)
        newMessView.lblMessage.text = model.content
        self.messView = newMessView

        addSubview(newMessView)
        
        switch type {
        case .sender:
            newMessView.snp.makeConstraints { make in
                make.left.verticalEdges.equalToSuperview()
                make.right.lessThanOrEqualTo(self).inset(60)
            }
        case .reciever:
            newMessView.snp.makeConstraints { make in
                make.right.verticalEdges.equalToSuperview()
                make.width.lessThanOrEqualTo(self.frame.width - 60)
            }
        }
    }
}
