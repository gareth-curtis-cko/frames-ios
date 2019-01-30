import UIKit

/// Method that you can use to handle the card number changes.
public protocol CardNumberInputViewDelegate: class {

    /// Called when the card number changed.
    ///
    /// - parameter cardType: Type of the card number.
    func onChangeCardNumber(cardType: CardType?)

    /// Tells the delegate that editing stopped for the text field in the specified view.
    ///
    /// - parameter view: View containing the text field
    func textFieldDidEndEditing(view: UIView)
}

/// Card Number Input View containing a label and an input field.
/// Handles the formatting of the text field.
@IBDesignable public class CardNumberInputView: StandardInputView, UITextFieldDelegate {

    // MARK: - Properties

    let cardsUtils = CardUtils()

    /// Text field delegate
    public weak var delegate: CardNumberInputViewDelegate?

    private var previousTextCount = 0

    // MARK: - Initialization

    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// Returns an object initialized from data in a given unarchiver.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        textField.keyboardType = .default
        textField.textContentType = .creditCardNumber
        textField.font = CheckoutTheme.font
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }

    // MARK: - UITextFieldDelegate

    /// Tells the delegate that editing began in the specified text field.
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        hideError()
    }

    /// Asks the delegate if the specified text should be changed.
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        // Card Number Formatting
        guard let text = textField.text else { return false }

        let cardNumber = cardsUtils.standardize(cardNumber: "\(text)\(string)")
        let cardType = cardsUtils.getTypeOf(cardNumber: cardNumber)
        guard let cardTypeUnwrap = cardType, let lastValidLength = cardTypeUnwrap.validLengths.last else { return true }
        guard cardNumber.count <= lastValidLength else {
            return false
        }
        return true
    }

    /// Called when the text changed.
    @objc public func textFieldDidChange(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }

        guard let text = textField.text else { return }

        let cardNumber = cardsUtils.standardize(cardNumber: text)
        let cardType = cardsUtils.getTypeOf(cardNumber: cardNumber)
        guard let cardTypeUnwrap = cardType else { return }
        delegate?.onChangeCardNumber(cardType: cardType)
        let cardNumberFormatted = cardsUtils.format(cardNumber: cardNumber, cardType: cardTypeUnwrap)
        textField.text = cardNumberFormatted

        if var targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            if targetCursorPosition != 0 {
                let lastChar = cardNumberFormatted
                    .substring(fromRange: NSRange(location: targetCursorPosition - 1, length: 1))
                if lastChar == " " && previousTextCount < cardNumberFormatted.count {
                    targetPosition = textField
                        .position(from: textField.beginningOfDocument, offset: targetCursorPosition + 1)!
                }
            }
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
        previousTextCount = cardNumberFormatted.count
    }

    /// Tells the delegate that editing stopped for the specified text field.
    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(view: self)
    }
}
