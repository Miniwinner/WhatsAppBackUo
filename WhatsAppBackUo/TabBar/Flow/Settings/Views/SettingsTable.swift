import UIKit

protocol SettingsFeatureDelegate: AnyObject {
    func passwordAction()
    func guideAction()
}


final class SettingsTable: UITableView {
    
    private var data: [SettingsData] = []
     
    weak var collectionDelegate: SettingsFeatureDelegate?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        prepareCollection()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func reloadView(_ data: [SettingsData]) {
        self.data = data
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
}

private extension SettingsTable {
    
    func prepareCollection() {
        delegate = self
        dataSource = self
        register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
        backgroundColor = .clear
        separatorStyle = .none
        isScrollEnabled = false
        
    }
    
}

extension SettingsTable : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as! ChatListCell
        cell.fillWithDataSettings(data: data[indexPath.section])
        cell.selectionStyle = .none
        cell.cellDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 72
        }
        else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    
}

extension SettingsTable: ListCellDelegate {
    func pushToDialogue(_ cell: UITableViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        switch indexPath.section {
        case 1:
            collectionDelegate?.passwordAction()
        case 3:
            collectionDelegate?.guideAction()
        default:
            break
        }
    }
    
    
}
