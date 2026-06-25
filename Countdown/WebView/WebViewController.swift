import SnapKit
import WebKit

final class WebViewController: UIViewController {
    
    private let urlString: String
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.bounds)
        
        return webView
    }()
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupView() {
        view.addSubview(webView)
    }
}
