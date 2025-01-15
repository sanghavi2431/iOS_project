//
//  AboutVC.swift
//  Woloo
//
//  Created on 25/04/21.
//

import UIKit
import WebKit

class AboutVC: UIViewController , WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let url = URL(string: UserDefaultsManager.fetchAppConfigData()?.URLS?.about_url ?? "")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            DELEGATE.rootVC?.tabBarVc?.showTabBar()
            DELEGATE.rootVC?.tabBarVc?.showPopUpVC(vc: self)
            DELEGATE.rootVC?.tabBarVc?.showFloatingButton()
    
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
