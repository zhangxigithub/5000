//
//  Visit.swift
//  Cambridge
//
//  Created by 张玺 on 06/05/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import UIKit
import WebKit
import hpple
import Alamofire
import SwiftyJSON
import SnapKit

import AVFoundation
import AudioToolbox
import RealmSwift


class Visit: UIViewController,WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource ,ZXWKWebViewDelegate {

    
    
    var index:Int = 5000
    var words = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var web : ZXWKWebView! //(frame: self.view.bounds)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        let path  = Bundle.main.path(forResource: String(index), ofType: "txt")
        let file  = try! String(contentsOfFile: path!)
        self.words = file.components(separatedBy: "\r\n")
        
        
        
        web = ZXWKWebView(frame: self.view.bounds)
        web.navigationDelegate = self
        self.view.addSubview(web)
        
        web.delegate = self
        
        
        web.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.tableView.snp.right)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-40)
            make.right.equalTo(self.view)
        }
        
        //web.frame.origin.x = 100
        //web.frame.size.width -= 100
        
        next()
        
        
    }
    
    var nextIndex = 0
    func next()
    {
        DispatchQueue.main.async {
            //self.tableView(self.tableView, didSelectRowAt: IndexPath(row: self.nextIndex, section: 0))
            self.tableView.selectRow(at: IndexPath(row: self.nextIndex, section: 0), animated: true, scrollPosition: .top)
            self.web.search(word: self.words[self.nextIndex])
            self.nextIndex += 1
        }

        
    }
    
    
    func didFinish() {
        if nextIndex < 5000
        {
            next()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        (cell.viewWithTag(1) as! UILabel).text = words[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        web.search(word: words[indexPath.row].lowercased())
        
    }
    
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    @IBAction func change(_ sender: UISlider) {
        
        widthConstraint.constant = self.view.frame.size.width * CGFloat(sender.value)
        //self.view.setNeedsLayout()
    }


}
