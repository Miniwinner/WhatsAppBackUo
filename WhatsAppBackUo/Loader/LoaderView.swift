import UIKit
import SnapKit



final class LoaderView: UIView {
    
    let bigCircleLayer = CAShapeLayer()
    let smallCircleLayer = CALayer()
    
    let percentLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 40:24)
        $0.text = "0%..."
        $0.textAlignment = .left
    }
    
    let loadingLbl = UILabel() --> {
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size:UIDevice.pad ?40:24)
        $0.text = "Loading"
        $0.textAlignment = .left
    }
    
    let cirlceView = UIView()
    
   
    init(withLbl:Bool = true) {
        super.init(frame: .zero)
        prepareSubs(withLbl: withLbl)
        
        if !withLbl {
            loadingLbl.text = "Importing chat..."
            loadingLbl.textAlignment = .center
        } else {
            prepareAnimation()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareSubs(withLbl: Bool) {
        if withLbl {
            addSubview(percentLbl)
            addSubview(loadingLbl)
            loadingLbl.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().inset(UIDevice.pad ?50:10)
                make.height.equalTo(UIDevice.pad ?40:30)
                make.width.equalTo(UIDevice.pad ?180:100)
            }
            percentLbl.snp.makeConstraints { make in
                make.left.equalTo(loadingLbl.snp.right)
                make.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(UIDevice.pad ?40:30)
            }
            
            addSubview(cirlceView)
            cirlceView.snp.makeConstraints { make in
                make.top.equalTo(percentLbl.snp.bottom).offset(UIDevice.pad ?80:40)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.size.equalTo(UIDevice.pad ?250:100)
            }
        } else {
            addSubview(loadingLbl)
            loadingLbl.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(UIDevice.pad ?40:30)
                make.horizontalEdges.equalToSuperview()
            }
           
            addSubview(cirlceView)
            cirlceView.snp.makeConstraints { make in
                make.top.equalTo(loadingLbl.snp.bottom).offset(UIDevice.pad ?80:40)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
                make.size.equalTo(UIDevice.pad ?250:100)
            }
        }
    }
    
    func prepareAnimation(flow: Bool = false) {
        let bigCircleRadius: CGFloat = UIDevice.pad ? 250/2 : 100/2
        var bigCircleCenter: CGPoint!
        if flow {
            bigCircleCenter = CGPoint(x: cirlceView.center.x - (UIDevice.pad ?115:40), y: cirlceView.center.y - (UIDevice.pad ?155:80))
        } else {
            bigCircleCenter = CGPoint(x: cirlceView.center.x + (UIDevice.pad ?125:50), y: cirlceView.center.y + (UIDevice.pad ?125:50))
        }
        let bigCirclePath = UIBezierPath(
            arcCenter: bigCircleCenter,
            radius: bigCircleRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        bigCircleLayer.path = bigCirclePath.cgPath
        bigCircleLayer.strokeColor = UIColor.gray.cgColor
        bigCircleLayer.lineWidth = UIDevice.pad ?16:8
        bigCircleLayer.fillColor = UIColor.clear.cgColor
        cirlceView.layer.addSublayer(bigCircleLayer)
        
        let smallCircleRadius: CGFloat = UIDevice.pad ?40/2:24/2
        
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
