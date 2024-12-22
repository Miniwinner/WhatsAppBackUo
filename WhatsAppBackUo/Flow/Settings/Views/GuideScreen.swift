import UIKit
import SnapKit

class GuideScreen: VcWithBackGround {
    
    private let onboardingPages: [OnboardingModel] = [OnboardingModel(image: "stepOne", text: "1. \(locApp(for: "OnBoardOne"))"),
                                                      OnboardingModel(image: "stepTwo", text: "2. \(locApp(for:"OnBoardTwo"))"),
                                                      OnboardingModel(image: "stepThree", text: "3. \(locApp(for:"OnBoardThree"))"),
                                                      OnboardingModel(image: "stepFour", text: "4. \(locApp(for:"OnBoardFour"))")]
    
    let scroll = UIScrollView() --> {
        $0.showsVerticalScrollIndicator = false
    }
    
    let stack = UIStackView() --> {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = UIDevice.pad ? 40:25
        
    }
    
    let lblEnd = UILabel() --> {
        $0.text = locApp(for: "OnBoardFive")
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 27:18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        topElement = TopElement(type: .backTitle)
        noContentView.isHidden = true
        super.viewDidLoad()
        topElement.title = "How to import?"
        prepareGuideStuff()
    }
    
    private func prepareGuideStuff() {
        
        view.addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
        }
        topElement.removeFromSuperview()
        scroll.addSubview(topElement)
        topElement.snp.makeConstraints { make in
            make.height.equalTo(UIDevice.pad ? 88:52)
            make.width.equalTo(view.frame.width - (UIDevice.pad ? 240:32))
            make.top.equalToSuperview().inset(UIDevice.pad ? 80:56)
            make.centerX.equalToSuperview()
        }
        
        scroll.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topElement.snp.bottom).offset(40)
            make.width.equalTo(view.frame.width - (UIDevice.pad ? 240 : 32))
        }
        
        for step in 0..<onboardingPages.count {
            let view = BoardView(type: .textOnTop, model: onboardingPages[step])
            stack.addArrangedSubview(view)
        }
        
        scroll.addSubview(lblEnd)
        lblEnd.snp.makeConstraints { make in
            make.top.equalTo(stack.arrangedSubviews.last!.snp.bottom).offset(UIDevice.pad ? 40:20)
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width - (UIDevice.pad ? 240:32))
        }
    }
}
