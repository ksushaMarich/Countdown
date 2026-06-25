import UIKit
import SnapKit

protocol NoteTableViewCellDelegate: AnyObject {
    func newRequiredHeight(_ height: CGFloat)
    func textDidChange(with text: String)
}

class NoteTableViewCell: RoundedTableViewCell {
    
    //MARK: - Naming
    
    weak var delegate: NoteTableViewCellDelegate?
    
    static let identifier = "NoteTableViewCell"
    
    private lazy var textView: PlaceholderTextView = {
        let textView = PlaceholderTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.listener = self
        textView.placeholder = "Text some notes"
        textView.font = InterFont.regular.of(size: 16)
        return textView
    }()
    
    //MARK: - Life cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setup() {
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    func configure(with note: String) {
        textView.text = note
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegate?.newRequiredHeight(self.textView.requiredHeight())
        }
    }
}

extension NoteTableViewCell: PlaceholderTextViewDelegate {
    
    func textDidChange() {
        delegate?.textDidChange(with: textView.text ?? "")
        delegate?.newRequiredHeight(textView.requiredHeight())
    }
}




