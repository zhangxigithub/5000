//
//  ZXRealm.swift
//  Cambridge
//
//  Created by 张玺 on 06/05/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import UIKit
import RealmSwift


class ZXRealm: NSObject {

    
    
    static let shared = ZXRealm()
    
    
    
    func realm() -> Realm
    {
        //let config = Realm.Configuration(fileURL: URL(string: NSHomeDirectory().appending("/Document/glossary.realm")))
        
        
        let r = try! Realm()
        
        
        return r
    }
    
}


class SearchWord: Object {
    dynamic var content : String = ""
    
    
    class func add(word:String)
    {
        let w = SearchWord()
        w.content = word
        
        let realm = ZXRealm.shared.realm()
        try! realm.write {
            realm.add(w)
        }
    }
    
    class func words() -> [String]
    {

        let puppies = ZXRealm.shared.realm().objects(SearchWord.self)
        
        var r = [String]()
        
        for i in puppies
        {
            r.insert(i.content, at: 0)
        }
        
        
        return r
        
    }
}
