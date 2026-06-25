import UIKit
import ToastViewSwift

protocol ChatsViewInput: AnyObject {
    func update()
    func showError(text: String)
}

class ChatsViewController: UIViewController {
    private lazy var presenter = ChatsPresenter(view: self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset.top = 16-4
        tableView.register(ChatViewCell.self, forCellReuseIdentifier: ChatViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var emptyChatsView: EmptyChatsView = {
        let view = EmptyChatsView() { [weak self] in
            self?.tabBarController?.selectedIndex = 0
        }
        return view
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupView()
        hidesBottomBarWhenPushed = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        presenter.viewWillAppear()
    }
    
    private func setupView() {
        title = "Chats"

        view.backgroundColor(.init(hex: 0x141718))
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).inset(16)
        }
        
        view.addSubview(emptyChatsView)
        emptyChatsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ChatsViewController: ChatsViewInput {
    func update() {
        emptyChatsView.isHidden = !presenter.chats.isEmpty
        tableView.reloadData()
    }
    
    func showError(text: String) {
        let toast = Toast.text(text, config: .init(direction: .top, attachTo: tableView))
        toast.show(haptic: .error)
    }
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatViewCell.reuseIdentifier,
            for: indexPath
        ) as? ChatViewCell
        
        let chat = presenter.chats[indexPath.row]
        cell?.configure(with: chat)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(ChatViewController(listModel: presenter.getChatModel(for: indexPath)))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteChat(for: indexPath)
        }
    }
}
