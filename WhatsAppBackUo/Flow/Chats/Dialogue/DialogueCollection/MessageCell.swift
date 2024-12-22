import UIKit
import SnapKit

protocol MessageCellDelegate: AnyObject {
    func procedTapToCollection(_ cell: UITableViewCell)
}

class MessageCell: UITableViewCell {

    weak var cellDelegate: MessageCellDelegate?
    private var messView: MessageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.isHidden = true
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
        
        messView = MessageView(type: type, model: model)
        messView.viewDelegate = self
        addSubview(messView)
        switch type {
        case .sender:
            messView.snp.makeConstraints { make in
                make.left.verticalEdges.equalToSuperview()
                make.right.lessThanOrEqualTo(self).inset(UIDevice.pad ? 120:60)
            }
        case .reciever:
            messView.snp.makeConstraints { make in
                make.right.verticalEdges.equalToSuperview()
                make.width.lessThanOrEqualTo(self.frame.width - (UIDevice.pad ? 120:60))
            }
        }
    }
}

extension MessageCell: MessageViewTapped {
    func procedTapToCell() {
        cellDelegate?.procedTapToCollection(self)
    }
}
