//
//  ViewController.swift
//  webview-to-javascript
//
//  Created by Saul on 2023/06/11.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    // css 변수 선언:
    let css = """
    html, body {
      overflow-x: hidden;
    }

    body {
      background-color: #333333;
      line-height: 1.5;
      color: white;
      padding: 10;
      font-weight: 600;
      font-family: -apple-system;
    }
    """

    // css를 한 줄로 변경:
    let cssString = css.replacingOccurrences(of: "\n", with: "")

    // css를 로드하는 자바스크립트:
    let javascript = """
      var element = document.createElement('style');
      element.innerHTML = '\(cssString)';
      document.head.appendChild(element);
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        // 자바스크립트를 웹뷰에 주입하는 코드:
        let userScript = WKUserScript(source: javascript,
                                      injectionTime: .atDocumentEnd, // HTML 로딩이 끝난 후
                                      forMainFrameOnly: true)

        // user script 설정하고, configuration 객체에 추가, 웹뷰에 주입:
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
    }

    // 웹뷰에 로드:
    DispatchQueue.global().async {
        let link = "https://swiftsenpai.com/wp-content/uploads/2022/01/plainHtmlSample.html"
        guard let url = URL(string: link), let htmlContent = try? Sting(contentsOf: url, encoding: .utf8) else { 
            assertionFailure("Failed to load HTML file from URL: \(link)")
            return
        }

        DispatchQueue.main.async {
          // HTML string을 메인 스레드의 웹뷰에 로드:
          webView.loadHTMLString(htmlContent, baseURL: url)
        }
    }
}
