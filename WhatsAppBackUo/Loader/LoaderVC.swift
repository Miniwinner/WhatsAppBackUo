import UIKit
import SnapKit

protocol LoaderDidLoaded: AnyObject {
    func pushToPass(_ viewController: UIViewController)
}

final class LoaderVC: UIViewController {
    
    let backView: UIImageView = .init(image: UIImage(named: "back"))
    
    var timer: Timer?
    var progress: Int = 0
    
    weak var delegate: LoaderDidLoaded?
    let loaderView = LoaderView()
    lazy var noReach = NoReachView() --> {
        $0.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBack()
        checkValue()
        startLoadingAnimation()
        

    }
    
    func checkValue() {
        if let value = UserDefaults.standard.value(forKey: "applocked") as? Bool {} else {
            UserDefaults.standard.setValue(false, forKey: "applocked")}
        
        if let value = UserDefaults.standard.value(forKey: "dataLoaded") as? Bool {} else {
            UserDefaults.standard.setValue(false, forKey: "dataLoaded")
        }
        noReach.btnNext.addTarget(self, action: #selector(makeAgain), for: .touchUpInside)
    }
    
    func procced() {
        delegate?.pushToPass(self)
    }
    
    
    
    func startLoadingAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.progress = 0
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.03, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
        }
    }
       
    func setText() {
        loaderView.percentLbl.text = "\(self.progress)%..."
    }
    
    func start() {
        progress = 0
        setText()
        noReach.isHidden = true
        loaderView.isHidden = false
        startLoadingAnimation()
    }
    
    @objc func updateProgress() {
        if progress < 100 {
            progress += 1
            setText()
        } else {
            timer?.invalidate()
            loaderView.bigCircleLayer.strokeColor = UIColor.white.cgColor
            loaderView.smallCircleLayer.backgroundColor = UIColor.clear.cgColor
            loaderView.smallCircleLayer.removeAllAnimations()
            if StarFashionFoldQuestion.shared.isReachable() {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.procced()
                }
            } else {
                loaderView.isHidden = true
                noReach.isHidden = false
            }
        }
    }
    
    @objc func makeAgain() {
        UIView.animate(withDuration: 0.1, animations: {
            self.noReach.btnNext.backgroundColor = .lightGray
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.noReach.btnNext.backgroundColor = .white
                self.start()
            })
        }
    }
    
}

private extension LoaderVC {
    
    func addBack() {
        view.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(-60)
        }
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(190)
        }
        view.addSubview(noReach)
        noReach.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
}
