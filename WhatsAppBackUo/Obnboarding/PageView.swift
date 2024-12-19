import UIKit
import SnapKit

final class PageView: UIView {
    
    var views: [UIView] = []
    var currentIndex: Int = 0
    let stack = UIStackView() --> {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        prepareSubs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func nextStep(count: Int) {
        guard currentIndex < count - 1 else { return }
        let prevStepView = views[currentIndex]
        prevStepView.backgroundColor = .gray
        
        UIView.animate(withDuration: 0.3) {
            prevStepView.constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = 9
                }
            }
        }
        self.layoutIfNeeded()
        currentIndex += 1
        let currentStepView = views[currentIndex]
        currentStepView.backgroundColor = .white
        UIView.animate(withDuration: 0.3) {
            currentStepView.constraints.forEach { constraint in
                if constraint.firstAttribute == .width {
                    constraint.constant = 55
                }
            }
            self.layoutIfNeeded()
        }
    }
    
}

private extension PageView {
    
    func createViews() {
        for item in 0..<4 {
            let view  = UIView()
            view.backgroundColor = item == currentIndex ? .white: .gray
            view.layer.cornerRadius = 9/2
            view.translatesAutoresizingMaskIntoConstraints = false
            views.append(view)
            stack.addArrangedSubview(view)
            let width = item == currentIndex ? 55:9
            view.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        }
    }
    
    
    
    func prepareSubs() {
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
