import UIKit
import WebKit
import UserNotifications
import CoreLocation
import Network
import SnapKit

final class DualChatItemViewController: VcWithBackGround, WKUIDelegate, WKScriptMessageHandler,WKNavigationDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {

    private var webView: WKWebView!
    
    override func viewDidLoad() {
        topElement = TopElement(type: .back)
        super.viewDidLoad()
        
        prepareWebRest()
        prepapareWeb()
    }
    
    private func prepapareWeb() {
        let myURL = URL(string:"https://web.whatsapp.com")
        let myRequest = URLRequest(url: myURL!)
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1.2 Safari/605.1.15"
        webView.configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.bounces = false
        webView.allowsBackForwardNavigationGestures = true
        webView.load(myRequest)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if (message.name == "openDocument") {
            //future usage
        }
        else if (message.name == "jsError") {
            //future usage
        }
        else
        {
            var messageSender = "";
            var messageBody = "";

            var messageData = message.body as! String
            if let index = messageData.firstIndex(of: "|") {
                messageSender = String(messageData[..<index])
                let indexNext = messageData.index(after: index)
                messageBody = String(messageData[indexNext...])
            }

            let content = UNMutableNotificationContent()
            content.title = messageSender//"WhatsApp Message"
            content.body = messageBody//message.body as! String

            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: nil)

            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if error != nil {
                    NSLog(error.debugDescription)
                }
            }
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            injectInMainScreenNoAdvance()
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

    func prepareWebRest() {
        let userScriptURL = Bundle.main.url(forResource: "UserScript", withExtension: "js")!
        let userScriptCode = try! String(contentsOf: userScriptURL)
        let userScript = WKUserScript(source: userScriptCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)

        let webConfiguration = WKWebViewConfiguration()
        let pref = WKWebpagePreferences.init()

        pref.preferredContentMode = .mobile
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.defaultWebpagePreferences = pref
        webConfiguration.defaultWebpagePreferences.preferredContentMode = .mobile
        webConfiguration.userContentController.addUserScript(userScript)
        webConfiguration.userContentController.add(self, name: "notify")

        //For Content Blocker
        let blockRules = """
           [
               {
                   "trigger": {
                       "url-filter": ".*img/qr-video-.*",
                       "resource-type": ["image"]
                   },
                   "action": {
                       "type": "block"
                   }
               }
           ]
        """

        WKContentRuleListStore.default().compileContentRuleList(
            forIdentifier: "ContentBlockingRules",
            encodedContentRuleList: blockRules) { (contentRuleList, error) in

                if let error = error {
                    return
                }
                webConfiguration.userContentController.add(contentRuleList!)
            }

        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.allowsLinkPreview = true
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(topElement.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(UIDevice.pad ? 120:0)
        }
    }
    
    
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            reloadData()
        }
    }

    func reloadData()
    {
        webView.evaluateJavaScript("1+1", completionHandler: nil)
    }


    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }

  

    func removeCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        print("All cookies deleted")

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("Cookie ::: \(record) deleted")
            }
        }
    }

    @objc fileprivate func handleResetItem() {

        let alert = UIAlertController(title: "Reset/Reload",
                                      message: "If you encounter any error during login, try Reset: WARNING: You have login again once reset",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Reload Only", style: .default, handler: {(action: UIAlertAction!) in
            self.webView.reload()

        }))

        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: {(action: UIAlertAction!) in

            self.removeCookies()
            self.webView.reload()

        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in

        }))

        self.present(alert, animated: true, completion: nil)

    }

   
   

    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin,
                 initiatedByFrame frame: WKFrameInfo,type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }



    func injectInMainScreenNoAdvance() {
        Task {

            // Проверяем, загрузился ли главный екран с чатами
            let inMainScreenJS = """
                (function() {
                    if (document.getElementsByClassName('two _aigs').length > 0) {
                        return true;
                    } else {
                        return false;
                    }
                })();
            """

            awaitForResult(forJS: inMainScreenJS) {
                let setChatsListCSS = """
                    (function() {
                        document.getElementById('wa-popovers-bucket').style.display = 'none';
                    })();
                """

                self.webView.evaluateJavaScript(setChatsListCSS) { result, error in
                    if let error {
                        print("Some error: \(error)")
                    }
                }
            }
        }
    }

    func injectInMainScreen() {
        Task {

            // Проверяем, загрузился ли главный екран с чатами
            let inMainScreenJS = """
                (function() {
                    if (document.getElementsByClassName('two _aigs').length > 0) {
                        return true;
                    } else {
                        return false;
                    }
                })();
            """
            awaitForResult(forJS: inMainScreenJS) {
                let setChatsListCSS = """
                    (function() {

                        // Переменная для отслеживания недавнего скролла
                        var isScrolledChatsRecently = false;

                        // Делаем размер общего блока = размеру экрана
                        document.getElementsByClassName('two _aigs')[0].style.minWidth = 'auto';

                        // Делаем размер блока для чата = 0
                        document.getElementsByClassName('_aigv _aigz')[1].style.display = 'none';
                        document.getElementById('wa-popovers-bucket').style.display = 'none';

                        // Делаем размер блока со списком чатов = размеру экрана

                        document.getElementsByClassName('_aigv _aigw _aigx')[0].style.maxWidth = '\(UIScreen.main.bounds.width)px';
                        document.getElementsByClassName('_aigv _aigw _aigx')[0].style.flex = 'auto';

                        document.getElementsByClassName('_aigv _aigz')[0].style.flexGrow = 'inherit';


                        document.getElementsByClassName('_aigv _aig-')[0].style.maxWidth = '\(UIScreen.main.bounds.width)px';
                        // document.getElementsByClassName('_aigv _aig-')[0].style.flex = 'auto';

                        document.getElementsByClassName('_aigv _aigw')[1].style.maxWidth = '\(UIScreen.main.bounds.width)px';
                        document.getElementsByClassName('_aigv _aigw')[1].style.flex = 'auto';

                        // Назначение смены размеров елементов при клике на чат из списка
                        var chats = document.getElementsByClassName('_ak73');
                        for(var i = 0; i < chats.length; i++) {
                            var chat = chats[i];

                            chat.ontouchend = function (event) {
                                if (!isScrolledChatsRecently) {
                                    clickOnChatListItem(event);
                                }
                            }

                            chat.ontouchmove = function () {
                                isScrolledChatsRecently = true;
                                setTimeout(() => {
                                    isScrolledChatsRecently = false;
                                }, 500);
                            };
                        }
                    })();
                """

                self.webView.evaluateJavaScript(setChatsListCSS) { result, error in
                    if let error {
                        print("Some error: \(error)")
                    } else {
                        self.checkJSElements()
                    }
                }
            }

        }
    }

    private func checkJSElements() {

        let setChatsListAction = """
            function checkAndChange() {

                if (document.getElementsByClassName('_aigv _aigw')[1].style.display == 'none') {
                    document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.marginInlineStart = '0';
                } else {
                    document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.marginInlineStart = '60px';
                }

                if (document.getElementsByClassName('x5yr21d x17qophe x6ikm8r x10wlt62 x10l6tqk x13vifvy xh8yej3').length > 0) {
                    // Назначение смены размеров елементов при клике на чат из списка
                    var isScrolledContactsRecently = false;
                    var chats = document.getElementsByClassName('_ak73');
                    for(var i = 0; i < chats.length; i++) {
                        var chat = chats[i];

                        if (chat.classList.contains('x1v2jjsl')) {
                            continue;
                        }

                        if (chat.classList.contains('_ak8f')) {
                            continue;
                        }

                        chat.ontouchend = clickOnChatListItem;

                        chat.ontouchend = function (event) {
                            if (!isScrolledContactsRecently) {
                                if (document.getElementsByClassName('x10l6tqk x13vifvy xds687c x1ey2m1c x17qophe') == 1) {
                                    clickOnChatListItem(event);
                                } else {
                                    setTimeout(() => {
                                        clickOnChatListItem(event);
                                    }, 500);
                                }
                            }
                        };

                        chat.ontouchmove = function () {
                            isScrolledContactsRecently = true;
                            setTimeout(() => {
                                isScrolledContactsRecently = false;
                            }, 500);
                        };
                    }
                }
            
                if (document.getElementsByClassName('x1qlqyl8 x1pd3egz xcgk4ki')[0].textContent == 'New chat') {
                    document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.marginInlineStart = '0';
                    document.getElementsByClassName('xa1v5g2 x1n2onr6 x9f619 x78zum5 x6s0dn4 xl56j7k xbyj736 x5yr21d x1ye3gou xn6708d x1acz5yr xm81vs4 xu3j5b3 x1a0jr7w')[0].style.display = 'none';

                    setTimeout(() => {
                        document.getElementsByClassName('x1okw0bk x16dsc37 x1ypdohk xeq5yr9 xfect85')[0].onclick = function() {
                            document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.marginInlineStart = '60px';

                            document.getElementsByClassName('_aigv _aigz')[1].style.display = 'none';

                            document.getElementsByClassName('_aigv _aigw')[1].style.maxWidth = '\(UIScreen.main.bounds.width)px';
                            document.getElementsByClassName('_aigv _aigw')[1].style.flex = 'auto';

                            document.getElementsByClassName('_aigv _aigw')[1].style.display = 'block';
                            setTimeout(() => {
                                document.getElementsByClassName('xa1v5g2 x1n2onr6 x9f619 x78zum5 x6s0dn4 xl56j7k xbyj736 x5yr21d x1ye3gou xn6708d x1acz5yr xm81vs4 xu3j5b3 x1a0jr7w')[0].style.display = 'flex';
                            }, 500);
                        }
                    }, 500);
                }

                if (document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j x1nhvcw1 xdt5ytf x1qjc9v5 _ajwu _ajwv _ajwt').length > 0) {
                    document.getElementsByClassName('_aigv _aigz')[0].style.width = '\(UIScreen.main.bounds.width)px';
                    document.getElementsByClassName('_ajwz')[0].style.width = '\(UIScreen.main.bounds.width)px';
                    document.getElementsByClassName('_ajwz')[0].style.justifyContent = 'space-around';
                    document.getElementsByClassName('_amlw')[0].style.width = '\(UIScreen.main.bounds.width)px';
                    document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.marginInlineStart = '0';
                    document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k x1q0g3np x1cy8zhl _ajx0')[0].style.flex = 'none';
                    document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k xdt5ytf x6s0dn4 x9f619 x13crsa5 xdd2zcy x1rxj1xn x12p1mil x1mkayr0 x1q7yeco x1a2cdl4 xnhgr82 x1qt0ttw xgk8upj')[0].style.padding = '0';
                    document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k x1q0g3np x6s0dn4 x1n2onr6 xh8yej3 xic84rp xdj266r x1ap2d02 xat24cr x1xcg2w3')[0].style.margin = '0';
                }

                if (document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j x1nhvcw1 xdt5ytf x1qjc9v5 _ajwt').length > 0) {
                    if (document.getElementsByClassName('_ah9n').length > 0) {

                        document.getElementsByClassName('_aigv _aigz')[0].style.width = '\(UIScreen.main.bounds.width)px';
                        document.getElementsByClassName('_ajwz')[0].style.width = '\(UIScreen.main.bounds.width)px';
                        document.getElementsByClassName('_ajwz')[0].style.justifyContent = 'space-around';

                        document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.marginInlineStart = '0';
                        document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.flex = '1 1 auto';

                        document.getElementsByClassName('_ah9n')[0].style.width = '\(UIScreen.main.bounds.width)px';
                        document.getElementsByClassName('_ah9q')[0].style.width = '\(UIScreen.main.bounds.width)px';
                        document.getElementsByClassName('_ah9q')[0].style.margin = '0';

                        document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k x1q0g3np x1cy8zhl _ajx0')[0].style.flex = 'none';

                            setTimeout(() => {
                                document.getElementsByClassName('_ak4w')[0].style.right = '0';

                                if (document.getElementsByClassName('_ak4w _ak4-').length > 0) {
                                    document.getElementsByClassName('_ak4w _ak4-')[0].style.left = '20pt';
                                }
                                if (document.getElementsByClassName('_ak4w _ak4_').length > 0) {
                                    document.getElementsByClassName('_ak4w _ak4_')[0].style.left = '20pt';
                                }
                                if (document.getElementsByClassName('x9f619 x78zum5 x1q0g3np x6s0dn4 x1y1aw1k x1sxyh0 xwib8y2 xurb0ha x6prxxf x152skdk x1ypdohk x107yiy2 xv8uw2v x1tfwpuw x2g32xy x1ry1tff xyklrzc').length > 0) {
                                    document.getElementsByClassName('x9f619 x78zum5 x1q0g3np x6s0dn4 x1y1aw1k x1sxyh0 xwib8y2 xurb0ha x6prxxf x152skdk x1ypdohk x107yiy2 xv8uw2v x1tfwpuw x2g32xy x1ry1tff xyklrzc')[0].style.display = 'none';
                                }

                            }, 350);

                        if (document.getElementsByClassName('_ajwp').length > 0) {
                            document.getElementsByClassName('_ajwp')[0].style.margin = '0';
                        }
                        if (document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k x1q0g3np x6s0dn4 _ah9w').length > 0) {
                            document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k x1q0g3np x6s0dn4 _ah9w')[0].style.flexWrap = 'wrap';
                        }

                        document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k x1q0g3np x6s0dn4 x1n2onr6 xh8yej3 xic84rp xdj266r x1ap2d02 xat24cr x1xcg2w3')[0].style.margin = '0';
                        document.getElementsByClassName('x1c4vz4f xs83m0k xdl72j9 x1g77sc7 x78zum5 xozqiw3 x1oa3qoh x12fk4p8 xeuugli x2lwn1j xl56j7k x1q0g3np x6s0dn4 _ah9v')[0].style.width = '\(UIScreen.main.bounds.width)px';

                    }
                }

                if (document.getElementsByClassName('x9f619 x78zum5 xdt5ytf x6s0dn4 xl56j7k xh8yej3 xpb48g7 x1jn0hjm x1us19tq').length > 0) {
                        document.getElementsByClassName('x9f619 x78zum5 xdt5ytf x6s0dn4 xl56j7k xh8yej3 xpb48g7 x1jn0hjm x1us19tq')[0].style.width = '\(UIScreen.main.bounds.width)px';

                        document.getElementsByClassName('x9f619 x78zum5 xdt5ytf x6s0dn4 xl56j7k xh8yej3 xpb48g7 x1jn0hjm x1us19tq')[0].style.minWidth = 'auto';

                        if (document.getElementsByClassName('x9f619 x78zum5 xdt5ytf x1v8jjaa xkwfhqy x17e6fzg x15dh256 x1t7u3xy x1shw4ur x6ikm8r x10wlt62 x1n2onr6 x1iyjqo2 xs83m0k x1l7klhg xs8rnei xexx8yu x4uap5 x18d9i69 xkhd6sd x1coevs8 x11i5rnm xui9b5u x1mh8g0r xg3pqpk x5frtva x1a6k631 x9b845u x1n7bigs x180mg20 x12v3509 x14m7gzy').length > 0) {
                            document.getElementsByClassName('x9f619 x78zum5 xdt5ytf x1v8jjaa xkwfhqy x17e6fzg x15dh256 x1t7u3xy x1shw4ur x6ikm8r x10wlt62 x1n2onr6 x1iyjqo2 xs83m0k x1l7klhg xs8rnei xexx8yu x4uap5 x18d9i69 xkhd6sd x1coevs8 x11i5rnm xui9b5u x1mh8g0r xg3pqpk x5frtva x1a6k631 x9b845u x1n7bigs x180mg20 x12v3509 x14m7gzy')[0].style.width = '\(UIScreen.main.bounds.width)px';
                        }
                        if (document.getElementsByClassName('x9f619 x78zum5 x1c4vz4f x2lah0s xdl72j9 xdt5ytf x1v8jjaa xkwfhqy x17e6fzg x15dh256 x1t7u3xy x1shw4ur x6ikm8r x10wlt62 x1n2onr6 xvue9z x1egiwwb xexx8yu x4uap5 x18d9i69 xkhd6sd').length > 0) {
                            document.getElementsByClassName('x9f619 x78zum5 x1c4vz4f x2lah0s xdl72j9 xdt5ytf x1v8jjaa xkwfhqy x17e6fzg x15dh256 x1t7u3xy x1shw4ur x6ikm8r x10wlt62 x1n2onr6 xvue9z x1egiwwb xexx8yu x4uap5 x18d9i69 xkhd6sd')[0].style.width = '\(UIScreen.main.bounds.width)px';
                        }
                }

                if (document.getElementsByClassName('x78zum5 xdt5ytf x17qophe x6ikm8r x10wlt62 x67bb7w x13vifvy xm0mufa x1uoaltn x1itt0r x10l6tqk xh8yej3 _ahmw copyable-area').length > 0) {
                        document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.marginInlineStart = '0';
                        document.getElementsByClassName('_aohf _aigv _aigw _aigx')[0].style.flex = 'none';
                }

                setTimeout(() => {
                    checkAndChange();
                }, 250);
            }

            checkAndChange();

            """

        self.webView.evaluateJavaScript(setChatsListAction) { result, error in
            if let error {
                print("Some error: \(error)")
                self.checkJSElements()
            }
        }
    }

    private func awaitForResult(forJS: String, time: Double = 0.5, completion: @escaping () -> Void) {
        Task {
            do {
                let jsExecutionResult = try await webView.evaluateJavaScript(forJS)
                if let jsExecution = jsExecutionResult as? Bool, jsExecution {
                    completion()
                    return
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                        self.awaitForResult(forJS: forJS, completion: completion)
                    }
                }
            } catch {
                print("Some error: \(error)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.awaitForResult(forJS: forJS, completion: completion)
                }
            }
        }
    }

}

