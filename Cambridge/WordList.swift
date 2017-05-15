//
//  List.swift
//  Cambridge
//
//  Created by zhangxi on 05/05/2017.
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

class Word : Object
{
    dynamic var word:String = ""
    dynamic var html:String = ""
    dynamic var uk:String = ""
    dynamic var us:String = ""
    
    dynamic var type = 0
    
    
    //dynamic var sound:Data?
    
//    func getSound()
//    {
//        //let url = URL(string:.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!)
//        
//        Alamofire.request(String(format:"http://dict.youdao.com/dictvoice?audio=%@&type=1",word)).responseData(queue: DispatchQueue.main) { (data) in
//         
//            ZXRealm.shared.realm().write {
//                self.sound = data.data
//            }
//            
//        }
//    }
}

class WordList: UIViewController,WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource {

    var history = false
    
    var wrongWords : [String]?
    
    var index:Int = 49
    var words = [String]()
    
    var canDictate = true
    
    @IBOutlet weak var tableView: UITableView!
    
    var web : ZXWKWebView! //(frame: self.view.bounds)
    
    var dicView : UIView?
    var dic :UIReferenceLibraryViewController?
    
    @IBAction func next(_ sender: Any) {
        
        if let index = self.tableView.indexPathForSelectedRow
        {
            if index.row < words.count - 1
            {
                let nextIndexPath = IndexPath(row: index.row + 1, section: 0)
                self.tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .top)
                self.tableView(self.tableView, didSelectRowAt: nextIndexPath)
            }
        }else{
            let nextIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .top)
            self.tableView(self.tableView, didSelectRowAt: nextIndexPath)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.white
        
        if wrongWords != nil
        {
            self.title = "Wrong Words"
            self.words = self.wrongWords!
        }else
        {
            self.title = String(index)
            
            if history == false
            {
                let path  = Bundle.main.path(forResource: String(5000), ofType: "txt")
                let file  = try! String(contentsOfFile: path!)
                
                let i = index*100
                self.words = Array(file.components(separatedBy: "\r\n")[i ..< i+100])
            }else
            {
                words = SearchWord.words()
            }
        }
        
        
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        

        
        

        if Catalog.dictionaryType == 3
        {
            
        }else
        {
        web = ZXWKWebView(frame: self.view.bounds)
        web.navigationDelegate = self
        self.view.addSubview(web)
            web.snp.makeConstraints { (make) in
                
                make.left.equalTo(self.tableView.snp.right).offset(10)
                make.top.equalTo(self.view).offset(64)
                make.bottom.equalTo(self.view).offset(-40)
                make.right.equalTo(self.view)
            }
        }
        
        
        
        if canDictate == false
        {
            self.navigationItem.rightBarButtonItem = nil
        }
    }


    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        (cell.viewWithTag(1) as! UILabel).text = words[indexPath.row]
        
        cell.separatorInset.left = 0
        return cell
    }
    //var player : AVPlayer?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if Catalog.dictionaryType == 3
        {
            self.dic = UIReferenceLibraryViewController(term: words[indexPath.row])
            
            dicView?.removeFromSuperview()
            dicView = self.dic?.view
            self.view.addSubview(dicView!)
            dicView?.snp.makeConstraints { (make) in
                
                make.left.equalTo(self.tableView.snp.right).offset(1)
                make.top.equalTo(self.view).offset(20)
                make.bottom.equalTo(self.view).offset(0)
                make.right.equalTo(self.view)
            }
            
        }else
        {
            web.search(word: words[indexPath.row].lowercased())
        }
        
        Sound.shared.speak(word: words[indexPath.row])
        
    }
    
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    @IBAction func change(_ sender: UISlider) {
        
        widthConstraint.constant = self.view.frame.size.width * CGFloat(sender.value)
        //self.view.setNeedsLayout()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "dictate"
        {
            let vc = segue.destination as! Dictation
            vc.type = String(self.index)
            
            if self.wrongWords != nil
            {
                vc.dontSave = true
            }
            
            
            vc.words = self.words.sorted(by: { (s1, s2) -> Bool in
                return arc4random_uniform(2) == 0
            })
        }
    }
    
    
}

protocol ZXWKWebViewDelegate
{
    func didFinish()
}

class ZXWKWebView : WKWebView,WKNavigationDelegate
{
    var delegate : ZXWKWebViewDelegate?
    let hideWeb = WKWebView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    
    var key:String!
    var word:Word?
    
    var player : AVPlayer!
    
    func get(word:String) -> Word?
    {
        
        let puppies = ZXRealm.shared.realm().objects(Word.self).filter(String(format:"word == '%@' && type == %d",word,Catalog.dictionaryType))
        
        return puppies.first
    }
    

    
    func load(word:Word)
    {
        let path    = Bundle.main.path(forResource: "content" , ofType: "html")
        let content = try! String(contentsOfFile: path!)
        
        let html = content.replacingOccurrences(of: "[body]", with: word.html)
        
        self.loadHTMLString(html, baseURL: nil)
    }
    
    
    func search(word:String)
    {
        switch Catalog.dictionaryType {
        case 0:
            self.search(cambridge: word)
        case 1:
            self.search(youdao: word)
        case 2:
            self.search(mw: word)
        default:
            break
        }
    }
    func search(cambridge word:String)
    {
        self.key = word
        print("search \(word)")
        print("http://dictionary.cambridge.org/dictionary/english-chinese-simplified/"+word)
        
        if let cache = get(word: word)
        {
            DispatchQueue.main.async {
                //self.loadHTMLString(cache.html, baseURL: nil)
                self.word = cache
                self.load(word: cache)
                //self.play()
                self.delegate?.didFinish()
            }
            
        }else
        {
            self.hideWeb.navigationDelegate = self
            self.hideWeb.stopLoading()
            
            
            self.hideWeb.load(URLRequest(url: URL(string: "http://dictionary.cambridge.org/dictionary/english-chinese-simplified/"+word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!))
        }
    }
    
    func search(youdao word:String)
    {
        self.key = word
        print("search \(word)")
        print("http://dict.youdao.com/w/"+word)
        
        if let cache = get(word: word)
        {
            DispatchQueue.main.async {
                //self.loadHTMLString(cache.html, baseURL: nil)
                self.word = cache
                self.load(word: cache)
                //self.play()
                self.delegate?.didFinish()
            }
            
        }else
        {
            self.hideWeb.navigationDelegate = self
            self.hideWeb.stopLoading()
            
            
            self.hideWeb.load(URLRequest(url: URL(string: "http://dict.youdao.com/w/"+word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!))
        }
    }
    func search(mw word:String)
    {
        self.key = word
        print("search \(word)")
        print("https://www.merriam-webster.com/dictionary/"+word)
        
        if let cache = get(word: word)
        {
            print("cache")
            
            DispatchQueue.main.async {
                //self.loadHTMLString(cache.html, baseURL: nil)
                self.word = cache
                self.load(word: cache)
                //self.play()
                self.delegate?.didFinish()
            }
            
        }else
        {
            print("no cache")
            self.hideWeb.navigationDelegate = self
            self.hideWeb.stopLoading()
            
            
            self.hideWeb.load(URLRequest(url: URL(string: "https://www.merriam-webster.com/dictionary/"+word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!))
        }
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish")

        switch Catalog.dictionaryType {
        case 0:
            self.handleCambridge(webView)
        case 1:
            self.handleYoudao(webView)
        case 2:
            self.handleMW(webView)
        default:
            break
        }
    }
    
    
    
    
    func handleCambridge(_ webView:WKWebView)
    {
        let path = Bundle.main.path(forResource: "inject", ofType: "js")
        let js = try! String(contentsOfFile: path!)
        
        webView.evaluateJavaScript(js) { (result, error) in
            
            print(result)
            print(error)
            
            if let r = result as? String
            {
                
                let array = r.components(separatedBy: "@@@@")
                //print(array)
                
                
                let w = Word()
                w.word = array[1]
                w.html = array[0]
                w.uk   = array[2]
                w.us   = array[3]
                w.type = 0
                
                let realm = ZXRealm.shared.realm()
                try! realm.write {
                    realm.add(w)
                }
                
                self.word = w
                //self.play()
                
                DispatchQueue.main.async {
                    self.load(word: w)
                    //self.loadHTMLString(w.html, baseURL: nil)
                    self.delegate?.didFinish()
                }
                
            }else
            {
                DispatchQueue.main.async {
                    self.loadHTMLString("<html><body><h1>没查到</h1></body></html>", baseURL: nil)
                    self.delegate?.didFinish()
                }
                
            }
        }
    }
    func handleYoudao(_ webView:WKWebView)
    {
        let path = Bundle.main.path(forResource: "youdao", ofType: "js")
        let js = try! String(contentsOfFile: path!)
        
        webView.evaluateJavaScript(js) { (result, error) in
            
            print(result)
            print(error)
            
            if let r = result as? String
            {
                
                let array = r.components(separatedBy: "@@@@")
                //print(array)
                
                
                let w = Word()
                w.word = array[1]
                w.html = array[0]
                w.us = String(format: "http://dict.youdao.com/dictvoice?audio=%@&type=1", w.word)
                //w.getSound()
                
                w.type = 1
                
                let realm = ZXRealm.shared.realm()
                try! realm.write {
                    realm.add(w)
                }
                
                self.word = w
                //self.play()
                
                DispatchQueue.main.async {
                    self.load(word: w)
                    //self.loadHTMLString(w.html, baseURL: nil)
                    self.delegate?.didFinish()
                }
                
            }else
            {
                DispatchQueue.main.async {
                    self.loadHTMLString("<html><body><h1>没查到</h1></body></html>", baseURL: nil)
                    self.delegate?.didFinish()
                }
                
            }
        }
    }
    func handleMW(_ webView:WKWebView)
    {
        let path = Bundle.main.path(forResource: "mw", ofType: "js")
        let js = try! String(contentsOfFile: path!)
        
        webView.evaluateJavaScript(js) { (result, error) in
            
            print(result)
            print(error)
            
            if let r = result as? String
            {
                
                
                let array = r.components(separatedBy: "@@@@")
                
                let w = Word()
                w.word = array[1]
                w.html = array[0]
                w.type = 2
                
                let realm = ZXRealm.shared.realm()
                try! realm.write {
                    realm.add(w)
                }
                
                self.word = w
                //self.play()
                
                DispatchQueue.main.async {
                    //self.load(word: w)
                    self.loadHTMLString(w.html, baseURL: nil)
                    self.delegate?.didFinish()
                }
                
            }else
            {
                DispatchQueue.main.async {
                    self.loadHTMLString("<html><body><h1>没查到</h1></body></html>", baseURL: nil)
                    self.delegate?.didFinish()
                }
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}









