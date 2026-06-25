
import UIKit

protocol PlaceholderTextViewDelegate: AnyObject {
    func textDidChange()
}

class PlaceholderTextView: UITextView {
    
    weak var listener: PlaceholderTextViewDelegate?
    
    var placeholder = "Placeholder" {
        didSet {
            changeTextManually(placeholder)
        }
    }
    
    override var text: String? {
        didSet {
            if !inManualMode {
                inPlaceholderMode = text == ""
            }
        }
    }

    private var inManualMode = false
    
    private lazy var inPlaceholderMode = true {
        didSet {
            if inPlaceholderMode {
                changeTextManually(placeholder)
                textColor = .gray
            } else {
                textColor = .black
            }
        }
    }
    
    //MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        delegate = self
        
        inPlaceholderMode = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - methods
    func changeTextManually(_ text: String) {
        inManualMode = true
        self.text = text
        inManualMode = false
    }
}

extension PlaceholderTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        listener?.textDidChange()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if inPlaceholderMode {
            inPlaceholderMode = false
            changeTextManually("")
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text == "" {
            inPlaceholderMode = true
        }
    }
}
