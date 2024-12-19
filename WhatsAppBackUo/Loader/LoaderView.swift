import UIKit
import SnapKit



final class LoaderView: UIView {
    
    let bigCircleLayer = CAShapeLayer()
    let smallCircleLayer = CALayer()
    
    let percentLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 24)
        $0.text = "0%..."
        $0.textAlignment = .left
    }
    
    let loadingLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 24)
        $0.text = "Loading"
        $0.textAlignment = .left
    }
    
    let cirlceView = UIView()
    
   
    override init(frame: CGRect) {
        super.init(frame: .zero)
        prepareSubs()
        prepareAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareSubs() {
        addSubview(percentLbl)
        addSubview(loadingLbl)
        loadingLbl.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(10)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        percentLbl.snp.makeConstraints { make in
            make.left.equalTo(loadingLbl.snp.right)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(30)
        }
        
        addSubview(cirlceView)
        cirlceView.snp.makeConstraints { make in
            make.top.equalTo(percentLbl.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.size.equalTo(100)
        }
    }
    
    func prepareAnimation() {
        let bigCircleRadius: CGFloat = 100/2
        let bigCircleCenter = CGPoint(x: cirlceView.center.x+50, y: cirlceView.center.y+50)
        
        let bigCirclePath = UIBezierPath(
            arcCenter: bigCircleCenter,
            radius: bigCircleRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        bigCircleLayer.path = bigCirclePath.cgPath
        bigCircleLayer.strokeColor = UIColor.gray.cgColor
        bigCircleLayer.lineWidth = 8
        bigCircleLayer.fillColor = UIColor.clear.cgColor
        cirlceView.layer.addSublayer(bigCircleLayer)
        
        let smallCircleRadius: CGFloat = 24/2
        
        smallCircleLayer.frame = CGRect(
            x: bigCircleCenter.x - smallCircleRadius,
            y: bigCircleCenter.y - bigCircleRadius - smallCircleRadius,
            width: smallCircleRadius * 2,
            height: smallCircleRadius * 2
        )
        smallCircleLayer.backgroundColor = UIColor.white.cgColor
        smallCircleLayer.cornerRadius = smallCircleRadius
        cirlceView.layer.addSublayer(smallCircleLayer)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = bigCirclePath.cgPath
        animation.duration = 2.0
        animation.repeatCount = .infinity
        animation.calculationMode = .paced
        
        smallCircleLayer.add(animation, forKey: "animationCirlce")
        
    }
    
}
