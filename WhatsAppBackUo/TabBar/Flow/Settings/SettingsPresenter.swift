import UIKit

class SettingsPresenter {
    
    private var date: String {
        guard let d = UserDefaults.standard.value(forKey: "lastVisitDate") else { return "Just Now" }
        return "\(timeAgoSinceDate(d as! Date))"
    }
    
    weak var view: SettingsVC?
    private lazy var data: [SettingsData] = [SettingsData(photo: UIImage(named: "logo")!, text: "Name", subText: "Last sync:\(date)", need: true),
                                             SettingsData(photo: UIImage(named: "lock")!, text: "Lock app", subText: "", need: false),
                                             SettingsData(photo: UIImage(named: "sync")!, text: "Sync on Google Drive", subText: "", need: false),
                                             SettingsData(photo: UIImage(named: "info")!, text: "How to import?", subText: "", need: false)
                                        
    ]
    
    func loadData() {
        view?.loadData(data)
    }
    
}
