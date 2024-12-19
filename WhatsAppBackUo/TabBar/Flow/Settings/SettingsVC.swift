import UIKit
import SnapKit

final class SettingsVC: VcWithBackGround {
    
    
    var router: SettingsRouter?
    var presenter: SettingsPresenter?
    let collectionSettings = SettingsTable()
    
    override func viewDidLoad() {
        topElement = TopElement(type: .title)
        noContentView.isHidden = true
        createManagers()
        super.viewDidLoad()
        prepareSubs()
        prepareScreen()
        presenter?.loadData()
    }
    
    func loadData(_ data: [SettingsData]) {
        collectionSettings.reloadView(data)
    }
    
}

private extension SettingsVC {
    
    func createManagers() {
        let router = SettingsRouter()
        router.controller = self
        self.router = router
        
        let presenter = SettingsPresenter()
        presenter.view = self
        self.presenter = presenter
    }
    
    func prepareSubs() {
        topElement.title = "Settings"
        topElement.titleLbl.textAlignment = .left
        collectionSettings.collectionDelegate = self
    }
    
    func prepareScreen() {
        view.addSubview(collectionSettings)
        collectionSettings.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(60)
            
        }
    }
}


extension SettingsVC: SettingsFeatureDelegate {
    func guideAction() {
        router?.showGuide()
    }
    
    func passwordAction() {
        router?.showPass()
    }
    
    
}
