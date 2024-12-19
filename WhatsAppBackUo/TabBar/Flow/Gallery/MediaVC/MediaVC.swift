import UIKit
import AVKit
import SnapKit


class MediaVC: VcWithBackGround {

    private var mediaData: DialogueModel?
    private var currentIndex: Int = 0
    
    let btnPrevious = UIButton() --> {
        $0.setImage(UIImage(named: "previousMedia"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 20
    }
    
    let btnNext = UIButton() --> {
        $0.setImage(UIImage(named: "nextMedia"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 20
    }
    
    let activity = UIButton() --> {
        $0.setImage(UIImage(named: "activity"), for: .normal)
        $0.makeWhite()
        $0.layer.cornerRadius = 20
    }
    
    let mediaDate = UILabel() --> {
        $0.makeWhite()
        $0.textAlignment = .center
        $0.layer.cornerRadius = 20
        $0.textColor = .white
        $0.font = .custom(type: .glSemiBold, size: 20)
        $0.clipsToBounds = true
    }
    
    var colletionMedia: MediaHorizontalCollection!
    
   
    
    override func viewDidLoad() {
        topElement = TopElement(type: .backTitleLogo)
        noContentView.isHidden = true
        super.viewDidLoad()
        prepareAll()
        
    }
   
  
    
    func prepareData(index: Int,data: DialogueModel) {
        
        mediaData = data
        colletionMedia = MediaHorizontalCollection(frame: .zero, collectionViewLayout: makeLayout())
        colletionMedia.fillMediaData(data: mediaData!)
        view.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(160)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.currentIndex = index
            self.setText()
            self.colletionMedia.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        }
        prepareSubviews()
    }
    
    
    
}

private extension MediaVC {
    @objc func activityShow() {
        let fileURL = URL(fileURLWithPath: getFilePath(path: mediaData?.mediaPaths[currentIndex] ?? "123"))
        presentShareSheet(with: fileURL, from: self)
         
    }
    
    @objc func scrollToNext() {
        currentIndex += 1
        guard let count = mediaData?.mediaPaths.count, currentIndex < count else {
            currentIndex -= 1
            return
        }
        setText()
        
        let indexPath = IndexPath(row: currentIndex, section: 0)
        colletionMedia.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc func scrollToPrevious() {
        currentIndex -= 1
        guard currentIndex >= 0 else {
            currentIndex = 0
            return
        }
        setText()
        let indexPath = IndexPath(row: currentIndex, section: 0)
        colletionMedia.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

}

private extension MediaVC {
    
    func setText() {
        lblTitle = "\(currentIndex+1)/\(mediaData!.mediaPaths.count) items"
        topElement.title = lblTitle
        let text = extractAndFormatDate(from: mediaData?.mediaPaths[currentIndex] ?? "null zero")
        mediaDate.text = text
    }
    
    
    
    func prepareAll() {
        
        activity.addTarget(self, action: #selector(activityShow), for: .touchUpInside)
        btnNext.addTarget(self, action: #selector(scrollToNext), for: .touchUpInside)
        btnPrevious.addTarget(self, action: #selector(scrollToPrevious), for: .touchUpInside)
    }
    
    func prepareSubviews() {
        view.addSubview(mediaDate)
        mediaDate.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview().inset(16)
            
        }
        
        view.addSubview(activity)
        activity.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
            make.bottom.equalToSuperview().inset(40)
            
        }
        view.addSubview(btnPrevious)
        btnPrevious.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.size.equalTo(40)
            make.bottom.equalTo(activity)
            
        }
        view.addSubview(btnNext)
        btnNext.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.size.equalTo(40)
            make.bottom.equalTo(activity)
            
        }
    }
    
    func makeLayout() -> UICollectionViewLayout {

        let topSectionItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(view.frame.width), heightDimension: .fractionalHeight(1))
        let topSectionItem = NSCollectionLayoutItem(layoutSize: topSectionItemSize)
        
        let topSectionGroupSize = NSCollectionLayoutSize(widthDimension: .absolute((view.frame.width - 32)*CGFloat(mediaData?.mediaPaths.count ?? 1)), heightDimension: .fractionalHeight(1))
        
        let topHorizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: topSectionGroupSize, subitem: topSectionItem, count: mediaData?.mediaPaths.count ?? 1)
        
        let tophorizontalSection = NSCollectionLayoutSection(group: topHorizontalGroup)
        tophorizontalSection.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        return UICollectionViewCompositionalLayout(section: tophorizontalSection)
    }
    
    
    func presentShareSheet(with fileURL: URL, from viewController: UIViewController) {
        // Создаём массив с объектами для передачи (в данном случае файл по URL)
        let activityItems: [Any] = [fileURL]
        
        // Создаём UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        // Настраиваем исключённые активности (если нужно)
        activityViewController.excludedActivityTypes = [
            .assignToContact, // Исключить назначение контакту
            .addToReadingList // Исключить добавление в список для чтения
        ]
        
        // Для iPad: Настраиваем PopoverPresentationController
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Показываем UIActivityViewController
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
