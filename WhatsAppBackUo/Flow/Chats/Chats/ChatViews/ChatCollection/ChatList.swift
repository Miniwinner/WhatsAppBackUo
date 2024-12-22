import UIKit

protocol CollectionListDelegate: AnyObject {
    func reactToPush(_ model: DialogueModel)
}

class ChatList: UITableView {

    private var data: [DialogueModel] = []
    private var vc: VCType = .chat
    weak var collectionDelegate: CollectionListDelegate?
    
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
        register(ChatListCell.self, forCellReuseIdentifier: ChatListCell.identifier)
        backgroundColor = .clear
        separatorStyle = .none
        sectionHeaderTopPadding = 0
    }

    func putData(_ data: [DialogueModel], vc: VCType = .chat) {
        self.data = data
        self.vc = vc
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
}

extension ChatList: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: ChatListCell.identifier, for: indexPath) as! ChatListCell
        cell.selectionStyle = .none
        if vc == .chat {
            cell.fillWithData(data: data[indexPath.section])
        } else {
            cell.fillNewData(data: data[indexPath.section], vc: vc)
        }
        cell.cellDelegate = self

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIDevice.pad ? 122:72
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return UIDevice.pad ? 30:10
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

extension ChatList: ListCellDelegate {
    func pushToDialogue(_ cell: UITableViewCell) {
        guard let indexPath = indexPath(for: cell) else { return }
        collectionDelegate?.reactToPush(data[indexPath.section])
    }
    
   
    
}
