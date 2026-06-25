
import UIKit

protocol TimeTextFieldListener: AnyObject {
    func timePickerDidChange(hours: Int, minutes: Int)
    func timePickerDidSelectTextField()
}

class TimeTextField: UITextField {
    
    //MARK: - Naming
    
    weak var listener: TimeTextFieldListener?
    
    //MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        attributedPlaceholder = NSAttributedString(
            string: "00 : 00",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: InterFont.regular.of(size: 20),
            ]
        )
        font = InterFont.regular.of(size: 20)
        keyboardType = .numberPad
        addTarget(self, action: #selector(timeDidChange), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func formatIncompleteTimeString(for text: String?) -> String {
        let string: String
        
        guard let text else { return "00 : 00"}
        if text.count <= 4 {
            string = "00 : 00"
        } else if text.count == 5 {
            if let number = Int(String(text.first ?? "0")), number < 3 {
                string = text + "00"
            } else {
                string = text + "0"
            }
        } else if text.count == 6, let number = Int(String(text.first ?? "0")), number < 3 {
            return text + "0"
        } else {
            string = text
        }
        return string
    }
    
    @objc private func timeDidChange() {
        if let eventTime = formatIncompleteTimeString(for: text).asEventTime {
            listener?.timePickerDidChange(hours: eventTime.hour, minutes: eventTime.minute)
        }
    }
    
    func setupTime(time: EventTime) {
        var timeString: String = ""
        timeString += time.hour > 9 ? "\(time.hour)" : "0\(time.hour)"
        if time.minute < 10 {
            timeString.append(" : 0\(time.minute)")
        } else {
            timeString.append(" : \(time.minute)")
        }
        text = timeString
    }
}

extension TimeTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text, let textRange = Range(range, in: text) {
            let newText = text.replacingCharacters(in: textRange, with: string)
            
            if newText == "" {
                return true
            }
            
            let validity = Validity(text: newText)
            if validity.shouldAddColon {
                textField.text = "\(newText) : "
                timeDidChange()
                return false
            } else if validity.shouldRemoveColon {
                textField.text = String(newText.dropLast(3))
                timeDidChange()
                return false
            } else {
                return validity.allows
            }
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.text = formatIncompleteTimeString(for: textField.text)
        
        if let eventTime = textField.text?.asEventTime {
            listener?.timePickerDidChange(hours: eventTime.hour, minutes: eventTime.minute)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        listener?.timePickerDidSelectTextField()
        DispatchQueue.main.async {
            let endPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: endPosition, to: endPosition)
        }
    }
}
