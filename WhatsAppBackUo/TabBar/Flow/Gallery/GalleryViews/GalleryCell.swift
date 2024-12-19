import UIKit

extension ChatListCell {
    func fillNewData(data: DialogueModel) {
        
        nameLbl.text = data.participants[0]
        lastMessage.text = "\(data.mediaCount) items"
        lastMessage.snp.remakeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(-10)
            make.height.equalTo(20)
            make.right.lessThanOrEqualTo(dialogueBtn.snp.left)
            make.centerY.equalToSuperview()
        }
    }
}
