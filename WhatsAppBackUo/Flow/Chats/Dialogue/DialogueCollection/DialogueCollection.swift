import UIKit
import SnapKit

protocol DialogueCollectionDelegate: AnyObject {
    func procedToCotroller(url: URL)
}

final class DialogueCollection: UITableView {

    
    weak var collectionDelegate: DialogueCollectionDelegate?
    private var data: [MessageModel] = []
    private var sender: String = ""
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        prepareCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func prepareCollection() {
        delegate = self
        dataSource = self
        register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifier)
        backgroundColor = .clear
        bounces = false
        separatorStyle = .none
        estimatedRowHeight = UIDevice.pad ? 74:44
        separatorInset = .zero
        layoutMargins = .zero
        sectionHeaderTopPadding = 0
        showsVerticalScrollIndicator = false
        
    }
    
    func fillWithData(_ data: [MessageModel], sender: String) {
        self.data = data
        self.sender = sender
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
}

private extension DialogueCollection {
    func setDate(index: Int) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .custom(type: .glRegular, size: UIDevice.pad ? 24:14)
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(UIDevice.pad ? 24:14)
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        let date = data[index].timestamp
        label.text = formatMessageDate(date: date)
        return view
    }
}

extension DialogueCollection: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: MessageCell.identifier, for: indexPath) as! MessageCell
        let message = data[indexPath.section]
        if message.sender == self.sender {
            cell.setMessageViews(type: .sender, model: message)
        } else { cell.setMessageViews(type: .reciever, model: message) }
        cell.cellDelegate = self
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section+1 < data.count {
            if compareDays(date1: data[section].timestamp, date2: data[section+1].timestamp) {
                return 40
            } else { return UIDevice.pad ? 30:14 }
        } else { return UIDevice.pad ? 30:14 }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections-1{
               return 120 
           } else {
               return 0
           }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        if section+1 < data.count {
            if compareDays(date1: data[section].timestamp, date2: data[section+1].timestamp) {
                return setDate(index: section)
            } else { return view }
        } else { return view }
        
    }
   
}

extension DialogueCollection: MessageCellDelegate {
    func procedTapToCollection(_ cell: UITableViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        let content = data[indexPath.section].content
        
        let path = getFilePath(path: content)
        
        let url = URL(fileURLWithPath: path)
        collectionDelegate?.procedToCotroller(url: url)
    }
}
