//
//  Catalog.swift
//  Cambridge
//
//  Created by zhangxi on 05/05/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import UIKit

class Catalog: UITableViewController {

    
    static var dictionaryType : Int = 3
    
    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        
        Catalog.dictionaryType = sender.selectedSegmentIndex
    
    }
    
    @IBAction func showWrong(_ sender: Any) {
        let list = self.storyboard?.instantiateViewController(withIdentifier: "list") as! WordList
        //list.dontSave = true
        
        var w = [String]()
        for s in DictationHistory.allWrongWords().sorted(by: { (a, b) -> Bool in
            return a.1 > b.1
        })
        {
            w.append(s.0)
        }
        
        
        
        list.wrongWords = w
        self.navigationController?.pushViewController(list, animated: true)
    }
    
    
    
    
    @IBAction func history(_ sender: Any) {
        let list = self.storyboard?.instantiateViewController(withIdentifier: "list") as! WordList
        list.history = true
        self.navigationController?.pushViewController(list, animated: true)
    }
    
    
    
    
    @IBAction func random(_ sender: Any) {
        
        let path  = Bundle.main.path(forResource: String(5000), ofType: "txt")
        let file  = try! String(contentsOfFile: path!)

        let words = file.components(separatedBy: "\r\n")
        
        var randomWords = [String]()
        

        
        let dictation = self.storyboard?.instantiateViewController(withIdentifier: "dictation") as! Dictation
        dictation.words = words.random(count: 100)
        dictation.type = "Random"
        self.navigationController?.pushViewController(dictation, animated: true)

    }
    
    
    @IBAction func random10(_ sender: Any) {
        
        var w = [String]()
        for s in DictationHistory.allWrongWords().sorted(by: { (a, b) -> Bool in
            return a.1 > b.1
        })
        {
            if s.1 > 1
            {
                for _ in 0 ..< s.1
                {
                    w.append(s.0)
                }
            }
        }
        
        print(w)
        print(w.random(count: 10))
        let dictation = self.storyboard?.instantiateViewController(withIdentifier: "dictation") as! Dictation
        dictation.words = w.random(count: 10)
        dictation.type = "Random10"
        self.navigationController?.pushViewController(dictation, animated: true)
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source


    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 50
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.separatorInset.left = 0
        
        
        let label = cell.viewWithTag(2) as! UILabel
        let bg    = cell.viewWithTag(1) as! UIView
        
        let info = DictationHistory.finishCount(type: String(indexPath.row))
        
        if info.finishCount != 0
        {
            bg.frame.size.width = 44 + (UIScreen.main.bounds.size.width - 44) * CGFloat(100 - CGFloat(info.errorCount))/100
        }else
        {
            bg.frame.size.width = 44
        }
        
        if bg.frame.size.width <= UIScreen.main.bounds.size.width/2
        {
            bg.backgroundColor = ColorRed
        }else
        {
            bg.backgroundColor = ColorGreen
        }
        
        
        label.text = String(indexPath.row)
//        let info = DictationHistory.finishCount(type: String(indexPath.row))
        
        
//        if info.finishCount != 0
//        {
//            cell.detailTextLabel?.text = String(format:"%d次,上次错%d个",info.finishCount,info.errorCount)
//        }else
//        {
//            cell.detailTextLabel?.text = ""
//        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let list = self.storyboard?.instantiateViewController(withIdentifier: "list") as! WordList
        list.index = indexPath.row
        self.navigationController?.pushViewController(list, animated: true)
    }



}
extension Array where Iterator.Element == String  {
    func random(count:Int) -> [String] {
        var r = [String]()
        
        while r.count < 10 {
            
            let s = self[Int(arc4random_uniform(UInt32(self.count)))] as! String
            if r.contains(s)
            {
            }else
            {
                r.append(s)
            }
        }

        return r
    }
}
