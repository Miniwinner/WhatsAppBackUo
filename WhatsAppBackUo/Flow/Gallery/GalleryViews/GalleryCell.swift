import UIKit

extension ChatListCell {
    func fillNewData(data: DialogueModel, vc: VCType) {
        switch vc {
            
        case .chat:
            break
        case .gallery:
            lastMessage.text = "\(data.mediaPaths.count) items"
        case .docs:
            lastMessage.text = "\(data.documentPaths.count) items"
        }
        nameLbl.text = data.participants[0]

        lastMessage.snp.remakeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(-10)
            make.height.equalTo(20)
            make.right.lessThanOrEqualTo(dialogueBtn.snp.left)
            make.centerY.equalToSuperview()
        }
    }
}
