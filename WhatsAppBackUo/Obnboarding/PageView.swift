import SnapKit
import UIKit

final class PageView: UIView {
    var views: [UIView] = []
    var currentIndex: Int = 0
    private let spacing: CGFloat = UIDevice.pad ? 15 : 5

    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func nextStep(count: Int) {
        guard currentIndex < count - 1 else { return }
        let prevStepView = views[currentIndex]
        prevStepView.backgroundColor = .gray

        UIView.animate(withDuration: 0.3) {
            prevStepView.snp.updateConstraints { make in
                make.width.equalTo(UIDevice.pad ? 15 : 9)
            }
            self.layoutIfNeeded()
        }
   
        self.currentIndex += 1
        let currentStepView = self.views[self.currentIndex]
        currentStepView.backgroundColor = .white

        UIView.animate(withDuration: 0.3) {
            currentStepView.snp.updateConstraints { make in
                make.width.equalTo(UIDevice.pad ? 93 : 55)
            }
            self.layoutIfNeeded()
        }
    }
    
}

private extension PageView {
    func createViews() {
        let count = 4
        var previousView: UIView? = nil

        for item in 0..<count {
            let view = UIView()
            view.backgroundColor = item == currentIndex ? .white : .gray
            view.layer.cornerRadius = (UIDevice.pad ? 15 : 9) / 2
            addSubview(view)
            views.append(view)

            view.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(item == currentIndex ? (UIDevice.pad ? 93 : 55) : (UIDevice.pad ? 15 : 9))
                make.height.equalTo(UIDevice.pad ? 15 : 9)

                if let previous = previousView {
                    make.leading.equalTo(previous.snp.trailing).offset(spacing)
                } else {
                    make.leading.equalToSuperview()
                }
            }

            previousView = view
        }

        previousView?.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
    }
}

