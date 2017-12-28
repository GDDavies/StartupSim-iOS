import UIKit

@objc protocol MembershipTextFieldDelegate: NSObjectProtocol {
    @objc optional func textFieldDidReturn(_ textField: MembershipTextField)
    @objc optional func textFieldDidChange(_ textField: MembershipTextField)
}

class MembershipTextField: UIView, UITextFieldDelegate {

    enum FieldType {
        case email
        case password
        case name
        case startupName
        case standard
    }

    // MARK: - Properties

    weak var delegate: MembershipTextFieldDelegate?

    var contentView: UIView?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    @IBInspectable var placeholder: String? {
        didSet {
            textField.placeholder = placeholder
            titleLabel.text = placeholder
        }
    }

    @IBInspectable var errorMessage: String? {
        didSet {
            messageLabel.text = errorMessage
        }
    }

    var fieldType: FieldType = .standard {
        didSet {
            switch fieldType {
            case .email:
                textField.keyboardType = .emailAddress
                textField.textContentType = .emailAddress
            case .password:
                textField.keyboardType = .default
                textField.isSecureTextEntry = true
            default:
                textField.keyboardType = .default
            }
        }
    }

    var returnKeyType: UIReturnKeyType = .next {
        didSet {
            textField.returnKeyType = returnKeyType
        }
    }

    var isValid: Bool {
        switch fieldType {
        case .email:
            let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: text)
        case .password:
            return text.count > 7
        default:
            return !text.isEmpty
        }
    }

    var text: String {
        get {
            return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        set {
            textField.text = newValue
            titleLabel.isHidden = newValue.isEmpty
        }
    }

    var isOptional: Bool = false {
        didSet {
            textField.enablesReturnKeyAutomatically = !isOptional
        }
    }

    // MARK: - Initialisation

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialise()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        initialise()
        contentView?.prepareForInterfaceBuilder()
    }

    private func initialise() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view

        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MembershipTextField", bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }

    // MARK: - TextField delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        underlineView.backgroundColor = UIColor(red: 0, green: 0.38, blue: 0.6, alpha: 1)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        titleLabel.isHidden = textField.text?.isEmpty ?? true
        delegate?.textFieldDidChange?(self)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        validate()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.textFieldDidReturn?(self)
        return false
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
        return super.resignFirstResponder()
    }

    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return super.becomeFirstResponder()
    }

    // MARK: - Validation

    func validate() {
        if isValid || (text.isEmpty && isOptional) {
            messageLabel.isHidden = true
            underlineView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        } else {
            messageLabel.isHidden = false
            underlineView.backgroundColor = UIColor.red
        }
    }

}
