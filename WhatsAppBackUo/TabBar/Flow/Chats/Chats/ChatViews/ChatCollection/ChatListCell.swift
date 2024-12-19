import UIKit
import SnapKit

protocol ListCellDelegate: AnyObject {
    func pushToDialogue(_ cell: UITableViewCell)
}

class ChatListCell: UITableViewCell {

    weak var cellDelegate: ListCellDelegate?
    
    let logo = UIImageView(image: UIImage(named: "logo"))
    
    let nameLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glBold, size: 20)
        $0.text = ""
    }
    
    let lastTimeMessage = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glRegular, size: 12)
        $0.text = ""
    }
    
    let lastMessage = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glRegular, size: 16)
        $0.text = ""
    }
    
    let dialogueBtn = UIButton() --> {
        $0.setImage(UIImage(named: "backAction"), for: .normal)
        $0.imageView?.transform = CGAffineTransform(rotationAngle: .pi)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeWhite()
        layer.cornerRadius = 72/2
        prepareSubs()
        dialogueBtn.addTarget(self, action: #selector(dialogueTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillWithData(data: DialogueModel) {
        nameLbl.text = data.participants[0]
        lastTimeMessage.text = timeAgoSinceDate(data.lastmessdate)
        lastMessage.text = data.lastMessage
    }
    
    @objc func dialogueTapped() {
        print("tapped")
        cellDelegate?.pushToDialogue(self)
    }
    
}

extension ChatListCell {
    
    private func prepareSubs() {
        contentView.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(38)
        }
        contentView.addSubview(dialogueBtn)
        dialogueBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.size.equalTo(24)
        }
        contentView.addSubview(lastMessage)
        lastMessage.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(-10)
            make.height.equalTo(20)
            make.right.lessThanOrEqualTo(dialogueBtn.snp.left)
            make.top.equalTo(logo)
        }
        contentView.addSubview(lastTimeMessage)
        lastTimeMessage.snp.makeConstraints { make in
            make.left.equalTo(lastMessage)
            make.top.equalTo(lastMessage.snp.bottom)
            make.height.equalTo(18)
            make.right.lessThanOrEqualTo(dialogueBtn.snp.left)
        }
        contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(logo.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.right.equalTo(lastMessage.snp.left)
        }
    }

    
}

extension ChatListCell {
    
    func fillWithDataSettings(data: SettingsData) {
        logo.image = data.photo
        nameLbl.text = data.text
        lastMessage.text = data.subText
        logo.contentMode = .scaleAspectFit
        selectionStyle = .none
        layer.cornerRadius = 56/2
        
        logo.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
        if data.need {
            dialogueBtn.isHidden = data.need
            nameLbl.snp.remakeConstraints { make in
                make.left.equalTo(logo.snp.right).offset(10)
                make.centerY.equalToSuperview()
                make.height.equalTo(22)
                make.width.lessThanOrEqualTo(80)
            }
            lastMessage.snp.remakeConstraints { make in
                make.centerY.equalToSuperview().offset(2)
                make.left.equalTo(nameLbl.snp.right).offset(5)
                make.right.equalToSuperview().inset(5)
                make.height.equalTo(22)
            }
        } else {
            dialogueBtn.isHidden = data.need
            nameLbl.snp.remakeConstraints { make in
                make.left.equalTo(logo.snp.right).offset(10)
                make.centerY.equalToSuperview()
                make.height.equalTo(22)
                make.right.equalToSuperview().inset(10)
            }
            
        }
    }
   
    
}
