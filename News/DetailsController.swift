import UIKit
import Foundation
import WebKit

class DetailsController: UIViewController, UIWebViewDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
        if Reachability.isConnectedToNetwork() == true {
            let url = URL (string: UserDefaults.standard.string(forKey: "ArticleUrl")!)
            let requestObj = URLRequest(url: url!)
            self.webView.load(requestObj)
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
