import UIKit
import SnapKit

enum TimeLineType {
    case player
    case chat
    case docs
}

final class TImeLineView: UIView {

    let leftLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 16)
        $0.text = "00:00"
    }
    
    private var widthCalculated: CGFloat = 0
    
    let rightLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 16)
        $0.text = "00:00"
        $0.textAlignment = .right
    }
    
    let timeLineEmpty = UIView() --> {
        $0.backgroundColor = .white.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
    }
    
    let timeLineFilled = UIView() --> {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 6
    }
   
    init(type: TimeLineType) {
        super.init(frame: .zero)
        prepareAll()
        prepareSubs(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        widthCalculated = timeLineEmpty.frame.width
    }
    
    func setReciever() {
        timeLineEmpty.backgroundColor = .gray
        timeLineFilled.backgroundColor = UIColor(redc: 148, greenc: 148, bluec: 245, alphac: 1)
        leftLbl.textColor = .black
        rightLbl.textColor = .black
    }
    
    func setSender() {
        timeLineEmpty.backgroundColor = .gray
        timeLineFilled.backgroundColor = .white
        leftLbl.textColor = .white
        rightLbl.textColor = .white
    }
    
//    func updateFillFrame(currentTime: Float, duration: Double) {
//        let width = widthCalculated * CGFloat(currentTime) / (CGFloat(duration))
//        
//        UIView.animate(withDuration: 0.3) {
//            self.leftLbl.text = formattedTime(from: Double(currentTime))
//            self.timeLineFilled.snp.remakeConstraints { make in
//                make.verticalEdges.left.equalToSuperview()
//                make.width.equalTo(width)
//            }
//            self.layoutIfNeeded()
//            
//        }
//    }
    
    func updateFillFrame(currentTime: Float, duration: Double, forceFullWidth: Bool = false) {
        let width: CGFloat
        if forceFullWidth {
            width = widthCalculated
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.timeLineFilled.snp.remakeConstraints { make in
                    make.verticalEdges.left.equalToSuperview()
                    make.width.equalTo(0)
                }
                self.layoutIfNeeded()
            }
        } else {
            width = widthCalculated * CGFloat(currentTime) / CGFloat(duration)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.leftLbl.text = formattedTime(from: Double(currentTime))
            self.timeLineFilled.snp.remakeConstraints { make in
                make.verticalEdges.left.equalToSuperview()
                make.width.equalTo(width)
            }
            self.layoutIfNeeded()
        }
    }

}

private extension TImeLineView {
    
    func prepareAll() {
        layer.cornerRadius = 20
        makeWhite()
    }
    
    func prepareSubs(type: TimeLineType) {
        addSubview(leftLbl)
        addSubview(rightLbl)
        addSubview(timeLineEmpty)
        timeLineEmpty.addSubview(timeLineFilled)
        
        switch type {
        case .docs:
            
            leftLbl.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(10)
                make.height.equalTo(18)
                make.centerY.equalToSuperview()
                make.width.equalTo(50)
            }
            
            rightLbl.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(10)
                make.height.equalTo(18)
                make.centerY.equalToSuperview()
                make.width.equalTo(50)
            }
            
            timeLineEmpty.snp.makeConstraints { make in
                make.left.equalTo(leftLbl.snp.right).offset(5)
                make.height.equalTo(12)
                make.right.equalTo(rightLbl.snp.left).inset(-5)
                make.centerY.equalToSuperview()
            }
            
            timeLineFilled.snp.makeConstraints { make in
                make.verticalEdges.left.equalToSuperview()
                make.width.equalTo(0)
            }
        case .chat:
            timeLineEmpty.layer.cornerRadius = 3
            timeLineEmpty.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(6)
            }
            timeLineFilled.layer.cornerRadius = 3
            timeLineFilled.snp.makeConstraints { make in
                make.verticalEdges.left.equalToSuperview()
                make.width.equalTo(0)
            }
            leftLbl.font = .custom(type: .glSemiBold, size: 12)
            leftLbl.snp.makeConstraints { make in
                make.top.equalTo(timeLineEmpty.snp.bottom).offset(5)
                make.width.equalTo(40)
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            rightLbl.font = .custom(type: .glSemiBold, size: 12)
            rightLbl.snp.makeConstraints { make in
                make.top.equalTo(leftLbl)
                make.width.equalTo(40)
                make.right.equalToSuperview().inset(8)
                make.bottom.equalToSuperview()
            }
        case .player:
            break
            
        }
        
    }
    
}
