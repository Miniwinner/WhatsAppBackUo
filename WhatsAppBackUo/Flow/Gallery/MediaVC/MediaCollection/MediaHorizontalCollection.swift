
import UIKit

class MediaHorizontalCollection: UICollectionView {

    private var dataModel: DialogueModel?
  
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        prepareAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func prepareAll() {
        delegate = self
        dataSource = self
        isScrollEnabled = false
        bounces = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        register(MediaCell.self, forCellWithReuseIdentifier: MediaCell.identifier)
    }
    
    func fillMediaData(data: DialogueModel) {
        dataModel = data
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
}

extension MediaHorizontalCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel?.mediaPaths.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCell.identifier, for: indexPath) as! MediaCell
        cell.checkFileType(dataModel?.mediaPaths[indexPath.row] ?? "nourl")
        return cell
    }
    
    
}
