import UIKit
import SnapKit
import WebKit

final class QrViewController: VcWithBackGround {

    let instrustionView = WKWebView() --> {
        $0.backgroundColor = .green
        $0.scrollView.isScrollEnabled = true
        $0.configuration.preferences.javaScriptEnabled = true
        $0.configuration.websiteDataStore = WKWebsiteDataStore.default()


    }
    
    override func viewDidLoad() {
        topElement = TopElement(type: .back)
        super.viewDidLoad()
        prepareSubs()
//      /*  */let desktopUserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36"
        instrustionView.navigationDelegate = self
//        instrustionView.customUserAgent = desktopUserAgent
//        createURL()
    }
    
    func createURL()  {
        if let url = URL(string: "Попробуйте WhatsApp на компьютере") {
            let urlreq = URLRequest(url: url)
            instrustionView.load(urlreq)
        }
    }
    
}

private extension QrViewController {
    
    func prepareSubs() {
        view.addSubview(instrustionView)
        instrustionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(60)
        }
    }
    
}

extension QrViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // JavaScript для включения прокрутки
            let jsScrollEnable = """
            document.body.style.overflow = 'scroll';
            document.documentElement.style.overflow = 'scroll';
            document.body.style.touchAction = 'auto';
            """
            
            webView.evaluateJavaScript(jsScrollEnable) { result, error in
                if let error = error {
                    print("Error injecting JavaScript: \(error.localizedDescription)")
                } else {
                    print("Scroll enabled successfully.")
                }
            }
        }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if ((url?.absoluteString.hasPrefix("https://web.whatsapp.com")) != false)
        {
            decisionHandler(.allow)
        }
        else if ((url?.absoluteString.hasPrefix("blob:")) != false)
        {
            decisionHandler(.allow)
        }
        else
        {
            decisionHandler(.cancel)
            UIApplication.shared.openURL(url!)
        }
    }
    
}
