import UIKit
import WebKit

/// Methods to handle the response in the 3ds web view
public protocol ThreedsWebViewControllerDelegate: class {

    /// Called if the response is successful
    func onSuccess3D()

    /// Called if the response is unsuccesful
    func onFailure3D()
}

/// A view controller to manage 3ds
public class ThreedsWebViewController: UIViewController {

    // MARK: - Properties

    let webView: WKWebView
    let successUrl: String
    let failUrl: String

    /// Delegate
    public weak var delegate: ThreedsWebViewControllerDelegate?

    /// Url
    public var url: String?

    // MARK: - Initialization

    /// Initializes a web view controller adapted to handle 3dsecure.
    public init(successUrl: String, failUrl: String) {
        self.successUrl = successUrl
        self.failUrl = failUrl
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        super.init(nibName: nil, bundle: nil)
    }

    /// Returns a newly initialized view controller with the nib file in the specified bundle.
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        successUrl = ""
        failUrl = ""
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Returns an object initialized from data in a given unarchiver.
    required public init?(coder aDecoder: NSCoder) {
        successUrl = ""
        failUrl = ""
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        super.init(coder: aDecoder)
    }

    // MARK: - Lifecycle

    /// Creates the view that the controller manages.
    public override func loadView() {
        view = webView
    }

    /// Called after the controller's view is loaded into memory.
    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = url, let authUrl = URL(string: url) else { return }
        let myRequest = URLRequest(url: authUrl)
        webView.navigationDelegate = self
        webView.load(myRequest)
    }

    private func shouldDismiss(absoluteUrl: URL) {
        // get URL conforming to RFC 1808 without the query
        let url = "\(absoluteUrl.scheme ?? "https")://\(absoluteUrl.host ?? "localhost")\(absoluteUrl.path)"

        if url == successUrl {
            // success url, dismissing the page with the payment token
            dismiss(animated: true) {
                self.delegate?.onSuccess3D()
            }
        } else if url == failUrl {
            // fail url, dismissing the page
            dismiss(animated: true) {
                self.delegate?.onFailure3D()
            }
        }
    }
}

extension ThreedsWebViewController: WKNavigationDelegate {

    /// Called when the web view begins to receive web content.
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation) {
        guard let url = webView.url else { return }
        shouldDismiss(absoluteUrl: url)
    }

    /// Called when a web view receives a server redirect.
    public func webView(_ webView: WKWebView,
                        didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation) {
        guard let url = webView.url else { return }
        // stop the redirection
        webView.stopLoading()
        shouldDismiss(absoluteUrl: url)
    }

}
