import UIKit
import SnapKit

class ChatMediaVC: VcWithBackGround {
    
    private var dialogueData: DialogueModel?
    private var isDocumetns: Bool = false
    var router: GalleryRouter?
    
    
    
    
    lazy var collectionMedia = UICollectionView(frame: .zero, collectionViewLayout: makeLayout()) --> {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        
    }
    
  
    
    init(isDocuments: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isDocumetns = isDocuments
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        topElement = TopElement(type: .backTitleLogo)
        prepareManagers()
        super.viewDidLoad()
        prepareSubs()
        topElement.title = lblTitle
        if isDocumetns {
            collectionMedia.register(DocsCollectionCell.self, forCellWithReuseIdentifier: DocsCollectionCell.identifier)
        } else {
            collectionMedia.register(ChatMediaCell.self, forCellWithReuseIdentifier: ChatMediaCell.identifier)
        }
    }
    
    func prepareManagers() {
        let router = GalleryRouter()
        router.viewController = self
        self.router = router
    }

    func loadData(model: DialogueModel) {
        dialogueData = model
        if isDocumetns {
            countModel(count: model.documentPaths.count)
        } else {
            countModel(count: model.mediaPaths.count)
        }
    
        
       
    }
        
    func countModel(count: Int) {
            lblTitle = "\(count) items"
            if count != 0 {
                noContentView.isHidden = true
                
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            } else {
                noContentView.isHidden = false
            }
        }
    
}

private extension ChatMediaVC {
    
    func makeLayout() -> UICollectionViewLayout {

        let topSectionItemSize = NSCollectionLayoutSize(widthDimension: .estimated(UIDevice.pad ? 276:163),
                                                        heightDimension: .absolute(UIDevice.pad ? 231:136))
        let topSectionItem = NSCollectionLayoutItem(layoutSize: topSectionItemSize)
        
        let topSectionGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(view.frame.width-(UIDevice.pad ? 240:32)),
                                                         heightDimension: .absolute(UIDevice.pad ? 231:136))
        
        let topHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topSectionGroupSize, subitem: topSectionItem, count: 2)
        topHorizontalGroup.interItemSpacing = .fixed(UIDevice.pad ? 20:10)
        
        let tophorizontalSection = NSCollectionLayoutSection(group: topHorizontalGroup)
        tophorizontalSection.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: -16)
        tophorizontalSection.interGroupSpacing = UIDevice.pad ? 20:10
        return UICollectionViewCompositionalLayout(section: tophorizontalSection)
    }
    
  
    
    func prepareSubs() {
        view.addSubview(collectionMedia)
        collectionMedia.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
    }
    
}


extension ChatMediaVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDocumetns {
            dialogueData?.documentPaths.count ?? 0 }
        else {
            dialogueData?.mediaPaths.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDocumetns {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DocsCollectionCell.identifier, for: indexPath) as! DocsCollectionCell
            cell.updateWithData(path: dialogueData!.documentPaths[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatMediaCell.identifier, for: indexPath) as! ChatMediaCell
            cell.setupMedia(path: dialogueData!.mediaPaths[indexPath.row])
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDocumetns {
            router?.pushToSolo(path: dialogueData?.documentPaths[indexPath.row] ?? "no path")
        } else {
            router?.pushToPlayer(itemNumber: indexPath.row+1, data: dialogueData!)
        }
    }
    
}
