import UIKit
import SnapKit

protocol OnBoardingDelegate: AnyObject {
    func pushToFlow(_ viewController: UIViewController)
}

class OnboardingVC: UIViewController {

    private let onboardingPages: [OnboardingModel] = [OnboardingModel(image: "stepOne", text: locApp(for: "OnBoardOne")),
                                                      OnboardingModel(image: "stepTwo", text: locApp(for:"OnBoardTwo")),
                                                      OnboardingModel(image: "stepThree", text: locApp(for:"OnBoardThree")),
                                                      OnboardingModel(image: "stepFour", text: locApp(for:"OnBoardFour"))]
    
    private var fromFlow: Bool = false
    
    private var widthCollection: CGFloat = 0
    private var heightCollection: CGFloat = 0
    
    let pageView = PageView()
    
    let  back: UIImageView = .init(image: UIImage(named: "back"))
    
    private var currentIndex: Int = 0
    
    weak var delegate: OnBoardingDelegate?
    
    lazy var collection = UICollectionView(frame: .zero, collectionViewLayout: makeLayout()) --> {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.register(BoardCell.self, forCellWithReuseIdentifier: BoardCell.identifier)
        $0.isScrollEnabled = false
        
    }
    
    let btnNext = UIButton() --> { button in
        button.setImage(UIImage(named: "next"), for: .normal)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .custom(type: .glRegular, size: UIDevice.pad ? 30:20)
        button.layer.cornerRadius = UIDevice.pad ? 74/2:22
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIDevice.pad ? 100:60)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: UIDevice.pad ? 100:80, bottom: 0, right: 0)
    }

    let btnSkip = UIButton() --> {
        $0.setTitle("Skip", for: .normal)
        $0.titleLabel?.font = .custom(type: .glSemiBold, size: UIDevice.pad ? 40:20)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightGray, for: .selected)
    }
    
    init(fromFlow: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.fromFlow = fromFlow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStuff()
        prepareSubs()
        view.backgroundColor = .red
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        widthCollection = collection.frame.width - 240
        heightCollection = collection.frame.height - 240
        collection.collectionViewLayout = makeLayout()
    }
    
    
    @objc func skipOnBoard() {
        checkFromFlow()
    }

    @objc func nextStepAction() {
        animateStepBtn()
        let nextIndex = currentIndex + 1
        if nextIndex < onboardingPages.count {
            let indexPath = IndexPath(item: nextIndex, section: 0)
            collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            currentIndex = nextIndex
            pageView.nextStep(count: onboardingPages.count)
        } else {
            checkFromFlow()
        }
    }
    
    
    
}


private extension OnboardingVC {
    
    func checkFromFlow() {
        if fromFlow {
//            dismiss(animated: true)
            navigationController?.popViewController(animated: true)
        } else {
            delegate?.pushToFlow(self)
        }
    }
    
    func animateStepBtn() {
        UIView.animate(withDuration: 0.1, animations: {
            self.btnNext.backgroundColor = .lightGray
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.btnNext.backgroundColor = .white
            })
        }
    }

    
    func prepareStuff() {
        btnNext.addTarget(self, action: #selector(nextStepAction), for: .touchUpInside)
        btnSkip.addTarget(self, action: #selector(skipOnBoard), for: .touchUpInside)
    }
    
    func prepareSubs() {
        view.addSubview(back)
        back.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIDevice.pad ? -80:-60)
            
        }
        
        view.addSubview(collection)

        
        view.addSubview(btnSkip)
        btnSkip.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(UIDevice.pad ? 120:20)
            make.top.equalToSuperview().inset(UIDevice.pad ? 80:60)
            make.height.equalTo(UIDevice.pad ? 40:24)
            make.width.equalTo(UIDevice.pad ? 80:40)
        }
        
        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.top.equalTo(btnSkip)
            make.left.equalToSuperview().inset(UIDevice.pad ? 120:20)
            make.height.equalTo(UIDevice.pad ? 15:9)
            make.width.equalTo(UIDevice.pad ? 182:97)
        }
        
        collection.snp.makeConstraints { make in
            make.top.equalTo(pageView.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
//
        }
        
        view.addSubview(btnNext)
        btnNext.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).offset(UIDevice.pad ? 40:10)
            make.bottom.equalToSuperview().inset(UIDevice.pad ? 80:60)
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:16)
            make.height.equalTo(UIDevice.pad ? 74:44)
        }
    }
    func makeLayout() -> UICollectionViewLayout {
  
        let topSectionItemSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width-32),
                                                        heightDimension: .fractionalHeight(1))
        let topSectionItem = NSCollectionLayoutItem(layoutSize: topSectionItemSize)
        
        let topSectionGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width*CGFloat(onboardingPages.count)), heightDimension: .fractionalHeight(1))
        
        let topHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topSectionGroupSize, subitem: topSectionItem, count: 4)
        
        let tophorizontalSection = NSCollectionLayoutSection(group: topHorizontalGroup)
        tophorizontalSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return UICollectionViewCompositionalLayout(section: tophorizontalSection)
    }
}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCell.identifier, for: indexPath) as! BoardCell
        cell.backgroundColor = .clear
        cell.prepareView(type: .textOnBottom, model: onboardingPages[indexPath.row])
        return cell
    }
    
    
    
}
