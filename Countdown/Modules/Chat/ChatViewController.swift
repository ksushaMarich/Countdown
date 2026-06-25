import SnapKit
import ToastViewSwift

protocol ChatViewInput: AnyObject {
    func setupProfileImage(link: String)
    func update()
    func showError(text: String)
    func setTextField(text: String)
    func openPayWall(subscriptionPurchasedHandler: @escaping (Bool) -> Void)
    func closePayWall()
    func showKeyboard()
}

class ChatViewController: UIViewController {
    enum Constans {
        static let profileImageSide: CGFloat = 30
    }
    
    private let presenter: ChatPresenter
    private lazy var keyboardObserver = KeyboardObserver()
    
    private lazy var profileImageView: UIImageView = .imageView("").contentMode(.scaleAspectFill).backgroundColor(.init(hex: 0x232627)).cornerRadius(Constans.profileImageSide / 2, clipsToBounds: true)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.backgroundColor = .clear
        tableView.contentInset.top = 16-4
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MessageViewCell.self, forCellReuseIdentifier: MessageViewCell.reuseIdentifier)
        tableView.register(WritingViewCell.self, forCellReuseIdentifier: WritingViewCell.reuseIdentifier)
        return tableView
    }()
    
    private lazy var textFieldView: ChatTextFieldView = {
        let view = ChatTextFieldView() { [weak self] sendableText in
            self?.presenter.sendMessage(text: sendableText)
        }
        return view
    }()
    
    private var textFieldViewConstraint: Constraint?
    
    init(listModel: ListModel) {
        presenter = .init(listModel: listModel)
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        setupView()
        hidesBottomBarWhenPushed = true
        title = listModel.name
        
//        profileImageView.addTapGesture { [weak self] in
//            self?.push(ModelProfileViewController(model: listModel, showWriteButton: false))
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollToFirstCell()
        presenter.viewDidLoad()
        
        keyboardObserver.add { [weak self] height in
            guard let self = self else { return }
            let bottomInset = self.view.layoutMargins.bottom
            let inset: CGFloat = 8
            self.textFieldViewConstraint?.update(inset: height - bottomInset + inset)
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } hideHandler: { [weak self] in
            self?.textFieldViewConstraint?.update(inset: 16)
            UIView.animate(withDuration: 0.3) {
                self?.view.layoutIfNeeded()
            }
        }
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    private func setupView() {
        setBackButton()
        addRightButton()
        
        view.backgroundColor(.init(hex: 0x141718))
        view.addSubview(tableView)
        view.addSubview(textFieldView)
        
        tableView.addTapGesture { [weak self] in
            self?.view.endEditing(true)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(textFieldView.snp.top)
        }
        
        textFieldView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            textFieldViewConstraint = make.bottom.equalTo(view.snp.bottomMargin).inset(16).constraint
        }
    }
    
    private func scrollToFirstCell() {
        guard presenter.messages.isEmpty == false else { return }
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func addRightButton() {
        let containView = UIView()
        containView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(Constans.profileImageSide)
        }
        let rightBarButton = UIBarButtonItem(customView: containView)
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

extension ChatViewController: ChatViewInput {
    func setupProfileImage(link: String) {
//        profileImageView.set(link: link)
    }
    
    func update() {
        tableView.reloadData()
        scrollToFirstCell()
    }
    
    func showError(text: String) {
        let toast = Toast.text(text, config: .init(direction: .top, attachTo: tableView))
        toast.show(haptic: .error)
        toast.view.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    func setTextField(text: String) {
        textFieldView.setText(text)
    }
    
    func openPayWall(subscriptionPurchasedHandler: @escaping (Bool) -> Void) {
//        let vc = SubscriptionViewController(
//            subscriptionPurchasedHandler: subscriptionPurchasedHandler
//        )
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
    }
    
    func closePayWall() {
        self.dismiss(animated: true)
    }
    
    func showKeyboard() {
        textFieldView.showKeyboard()
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.showWriting {
            return presenter.messages.count + 1
        } else {
            return presenter.messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if presenter.showWriting, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: WritingViewCell.reuseIdentifier,
                for: indexPath
            ) as? WritingViewCell
            
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MessageViewCell.reuseIdentifier,
                for: indexPath
            ) as? MessageViewCell
            
            let row = presenter.showWriting ? indexPath.row - 1 : indexPath.row
            let message = presenter.messages[(presenter.messages.count - 1) - row]
            cell?.configure(with: message)
            cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell ?? UITableViewCell()
        }
    }
}

extension ChatViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
