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
        $0.font = .custom(type: .glBold, size: UIDevice.pad ? 40:20)
        $0.text = ""
    }
    
    let lastTimeMessage = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glRegular, size: UIDevice.pad ? 24:12)
        $0.text = ""
    }
    
    let lastMessage = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 34:16)
        $0.text = ""
    }
    
    let dialogueBtn = BtnMine() --> {
        $0.imageViewMine.image = UIImage(named: "backAction")
        $0.imageViewMine.transform = CGAffineTransform(rotationAngle: .pi)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeWhite()
        layer.cornerRadius = UIDevice.pad ? 122/2:72/2
        prepareSubs()
        dialogueBtn.addTarget(self, action: #selector(dialogueTapped), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillWithData(data: DialogueModel) {
       
        nameLbl.text = data.participants[0]
        lastTimeMessage.text = timeAgoSinceDate(data.lastmessdate)
        if data.lastMessage.starts(with: "WhatsUPUnzipped") {
            let placeholder = "Media File"
            lastMessage.text = placeholder
        } else {
            lastMessage.text = data.lastMessage
        }
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
            make.left.equalToSuperview().inset(UIDevice.pad ? 30:20)
            make.size.equalTo(UIDevice.pad ? 54:38)
        }
        contentView.addSubview(dialogueBtn)
        dialogueBtn.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(UIDevice.pad ? 25:15)
            make.size.equalTo(UIDevice.pad ? 44:24)
        }
        contentView.addSubview(lastMessage)
        lastMessage.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(-10)
            make.height.equalTo(UIDevice.pad ? 30:20)
            make.right.lessThanOrEqualTo(dialogueBtn.snp.left)
            make.top.equalTo(logo)
        }
        contentView.addSubview(lastTimeMessage)
        lastTimeMessage.snp.makeConstraints { make in
            make.left.equalTo(lastMessage)
            make.top.equalTo(lastMessage.snp.bottom)
            make.height.equalTo(UIDevice.pad ? 30:18)
            make.right.lessThanOrEqualTo(dialogueBtn.snp.left)
        }
        contentView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(logo.snp.right).offset(UIDevice.pad ? 20:10)
            make.centerY.equalToSuperview()
            make.height.equalTo(UIDevice.pad ? 40:22)
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
        layer.cornerRadius = UIDevice.pad ? 94/2:56/2
        
        logo.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(UIDevice.pad ? 54:38)
        }
        dialogueBtn.isHidden = data.need
        if data.need {
            
            nameLbl.snp.remakeConstraints { make in
                make.left.equalTo(logo.snp.right).offset(UIDevice.pad ? 20:10)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ? 40:22)
                make.width.lessThanOrEqualTo(UIDevice.pad ? 160:80)
            }
            lastMessage.snp.remakeConstraints { make in
                make.centerY.equalToSuperview().offset(UIDevice.pad ? 5:2)
                make.left.equalTo(nameLbl.snp.right).offset(UIDevice.pad ? 15:5)
                make.right.equalToSuperview().inset(5)
                make.height.equalTo(UIDevice.pad ? 40:22)
            }
        } else {
            nameLbl.snp.remakeConstraints { make in
                make.left.equalTo(logo.snp.right).offset(UIDevice.pad ? 20:10)
                make.centerY.equalToSuperview()
                make.height.equalTo(UIDevice.pad ? 40:22)
                make.right.equalToSuperview().inset(10)
            }
            
        }
    }
   
    
}
