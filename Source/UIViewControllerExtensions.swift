import Foundation
import UIKit

extension UIViewController {

    @objc func scrollViewOnKeyboardWillShow(notification: NSNotification, scrollView: UIScrollView,
                                            activeField: UITextField?) {
        let additionalSpace = CGFloat(80.0)
        let textField = activeField ?? UIResponder.current as? UITextField
        guard let activeField = textField else { return }
        if let size = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0,
                                                           left: 0.0,
                                                           bottom: size.height + additionalSpace,
                                                           right: 0.0)

            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets

            // If active text field is hidden by keyboard, scroll it so it's visible
            // Your app might not need or want this behavior.
            var aRect: CGRect = view.frame
            aRect.size.height -= size.height
            if !aRect.contains(activeField.frame.origin) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func scrollViewOnKeyboardWillHide(notification: NSNotification, scrollView: UIScrollView) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    func registerKeyboardHandlers(notificationCenter: NotificationCenter,
                                  keyboardWillShow: Selector,
                                  keyboardWillHide: Selector) {
        notificationCenter.addObserver(self,
                                       selector: keyboardWillShow,
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: keyboardWillHide,
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }

    func deregisterKeyboardHandlers(notificationCenter: NotificationCenter) {
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
