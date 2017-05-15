//
//  DictationHistoryVC.swift
//  Cambridge
//
//  Created by zhangxi on 11/05/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import UIKit
import RealmSwift

class DictationHistoryVC: UITableViewController {

    
    var data = DictationHistory.historys()
    let f = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        f.dateFormat = "MM-dd HH:mm"
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = data[indexPath.row].type + " - "  + String(data[indexPath.row].words.count) + "个"
        cell.detailTextLabel?.text = f.string(from: data[indexPath.row].date)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if data[indexPath.row].words.count == 0
        {
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "dictation") as! Dictation
        vc.type = data[indexPath.row].type
        vc.dontSave = true
        vc.words = data[indexPath.row].words.sorted(by: { (s1, s2) -> Bool in
            return arc4random_uniform(2) == 0
        })
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     
        print(indexPath)
        
        let record = data[indexPath.row]
        
        record.delete()
        data.remove(at: indexPath.row)
        
        tableView.reloadData()
        //tableView.reloadRows(at: [indexPath], with: .automatic)
    }


}

class DictationHistory : Object
{
    dynamic var type : String = ""
    dynamic var date = Date()
    dynamic var wordString = ""
    var words : [String]
    {
        if wordString == ""
        {
            return [String]()
        }else
        {
            return wordString.components(separatedBy: ",")
        }
    }
    
    
    static func history(type:String) -> DictationHistory
    {
        let h = DictationHistory()
        h.type = type

        return h
    }
    func save()
    {
        try! ZXRealm.shared.realm().write {
            ZXRealm.shared.realm().add(self)
        }
    }
    func delete()
    {
        try! ZXRealm.shared.realm().write {
            ZXRealm.shared.realm().delete(self)
        }
    }
    
    func add(word:String)
    {
        try! ZXRealm.shared.realm().write {
            if wordString == ""
            {
                wordString = word
            }else
            {
                wordString = wordString.appending("," + word)
            }
        }
    }
    
    static func historys() -> [DictationHistory]
    {
        let puppies = ZXRealm.shared.realm().objects(DictationHistory.self)
        
        var r = [DictationHistory]()
        
        for i in puppies
        {
            r.insert(i, at: 0)
        }
        
        return r
    }
    
    static func finishCount(type:String) -> (finishCount:Int,errorCount:Int)
    {
        let puppies = ZXRealm.shared.realm().objects(DictationHistory.self).filter(String(format:"type = '%@'",type))
        print("type:\(type)  \(puppies.count)")
        
        let count = puppies.last?.words.count ?? 0
        

        return (finishCount:puppies.count,errorCount: count)
    }
    
    static func allWrongWords() -> [(String,Int)]
    {
        var result = [(String,Int)]()
        
        let puppies = ZXRealm.shared.realm().objects(DictationHistory.self)
        
        for word in puppies
        {
            for w in word.words
            {
                print(w)
                
                var target : (String,Int)?
                var index = 0
                for (i,t) in result.enumerated()
                {
                    if t.0 == w
                    {
                        target = t
                        index  = i
                        break
                    }
                }
                if target != nil
                {
                    result.remove(at: index)
                    target!.1 += 1
                    result.append(target!)
                }else
                {
                    result.append((w,1))
                }
            }
        }
        //print(result)
        return  result
    }
    
}




