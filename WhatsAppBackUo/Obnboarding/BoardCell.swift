import UIKit
import SnapKit

final class BoardCell: UICollectionViewCell {
    
    var view: BoardView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("inited")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        view.removeFromSuperview()
        view = nil
    }
    
    func prepareView(type: BoardType, model: OnboardingModel) {
        view = BoardView(type: type, model: model)
        addSubview(view)
        view.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.center.equalToSuperview()
        }
        layoutIfNeeded()
    }
    
    
}
