//
//  ViewController.swift
//  Cambridge
//
//  Created by zhangxi on 05/05/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController,UITextFieldDelegate,WKNavigationDelegate {

    
    
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var input: UITextField!
    
    
    var web : WKWebView! //(frame: self.view.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        web = WKWebView(frame: self.view.bounds)
        
        
        //web.frame.size.height -= 44
        self.view.addSubview(web)
        
        web.navigationDelegate = self
        
        
        web.load(URLRequest(url: URL(string: "http://dictionary.cambridge.org/dictionary/english-chinese-simplified/")!))
    }

    


    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    
        var js = "var word = document.body.getElementsByClassName(\"hw\")[1].innerText;document.getElementsByClassName(\"contain cdo-tpl cdo-tpl-main cdo-tpl--entry\")[0].innerHTML = document.getElementsByClassName(\"di-body\")[0].innerHTML;"

        js += "var shares = document.getElementsByClassName(\"share rounded js-share\");"
        
        

        js += "for (var i=0; i < shares.length; i++){"
        js += "shares[i].innerHTML = \"\";"
        js += "shares[i].style.visibility='hidden';"
        js += "}"
        js += "document.getElementsByClassName(\"cdo-promo\")[0].remove();"
        js += "document.getElementById(\"footer\").remove();"
    
        js += "document.body.removeChild(document.body.children[5]);"
        
        js += "document.getElementsByClassName(\"circle circle-btn sound audio_play_button us\")[0].click();"

        js += "word"
        
        webView.evaluateJavaScript(js) { (result, error) in
            print(result)
            print(error)
            
            if (result as? String) != nil
            {
                SearchWord.add(word: result as! String)
            }
        }
    }
}

