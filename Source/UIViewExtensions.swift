import Foundation
import UIKit

extension UIView {

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.layoutMarginsGuide.topAnchor
        }
    }

    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        } else {
            return self.leftAnchor
        }
    }

    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        } else {
            return self.rightAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leadingAnchor
        } else {
            return self.leadingAnchor
        }
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.trailingAnchor
        } else {
            return self.trailingAnchor
        }
    }

    func addScrollViewContraints(scrollView: UIScrollView, contentView: UIView) -> NSLayoutConstraint {
        // Content View Constraints
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0).isActive = true
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: heightAnchor,
                                                                              multiplier: 1.0)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
        // Scroll View Constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: safeTopAnchor).isActive = true

        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: safeBottomAnchor)
        scrollViewBottomConstraint.isActive = true
        // return scrollView bottom anchor constraint, used to manage the keyboard
        return scrollViewBottomConstraint
    }

    func addKeyboardToolbarNavigation(textFields: [UITextField]) {
        // create the toolbar
        for (index, textField) in textFields.enumerated() {
            let toolbar = UIToolbar()
            let prevButton = UIBarButtonItem(image: "keyboard-previous".image(forClass: CardUtils.self),
                                             style: .plain, target: nil, action: nil)
            prevButton.width = 30
            let nextButton = UIBarButtonItem(image: "keyboard-next".image(forClass: CardUtils.self),
                                             style: .plain, target: nil, action: nil)
            let flexspace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                            target: nil, action: nil)

            var items = [prevButton, nextButton, flexspace]
            // first text field
            if index == 0 {
                prevButton.isEnabled = false
            } else {
                prevButton.target = textFields[index - 1]
                prevButton.action = #selector(UITextField.becomeFirstResponder)
            }

            // last text field
            if index == textFields.count - 1 {
                nextButton.isEnabled = false
                let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                                 target: textField,
                                                 action: #selector(UITextField.resignFirstResponder))
                items.append(doneButton)
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
                let downButton = UIBarButtonItem(image: "keyboard-down".image(forClass: CardUtils.self),
                                                 style: .plain,
                                                 target: textField,
                                                 action: #selector(UITextField.resignFirstResponder))
                items.append(downButton)
            }
            toolbar.items = items
            toolbar.sizeToFit()
            textField.inputAccessoryView = toolbar
        }
    }

}
