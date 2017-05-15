//
//  Dictation.swift
//  Cambridge
//
//  Created by zhangxi on 11/05/2017.
//  Copyright © 2017 zhangxi. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import RealmSwift


class Sound
{
    static var shared = Sound()
    
    var player : AVPlayer?
    var audioPlayer : AVAudioPlayer?
    
    func speak(word:String,type:Int = 2)
    {
        
        let soundName = String(format: "sound/%@_%d",word,type)
        let soundPath = Bundle.main.path(forResource: soundName, ofType: "mp3")
        
        if soundPath != nil
        {
            if let url = URL(string: soundPath!)
            {
                audioPlayer = try? AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
                return
            }
        }

        
        let url = String(format: "http://dict.youdao.com/dictvoice?audio=%@&type=%d",word,type)
        let key  = word + String(type) + ".mp3"
        
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let path         = documentsURL.appendingPathComponent(key)
        
        print(path.relativePath)
        
        if FileManager.default.fileExists(atPath: path.relativePath)
        {
            self.player = AVPlayer(url: path)
            self.player?.play()
        }else
        {
            
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                
                return (path, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            Alamofire.download(url, to: destination).response { response in
                

                if response.error == nil, let audioPath = response.destinationURL {
                    
                    self.player = AVPlayer(url: audioPath)
                    self.player?.play()
                }
            }
            
            
        }



    }
    
}

class Dictation: UIViewController {

    var type : String!
    var words = [String]()
    
    var step  = 0
    
    var dontSave = false
    
    @IBOutlet weak var countBarItem: UIBarButtonItem!
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var ukButton: UIButton!
    
    @IBOutlet weak var usButton: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var checkButtonItem: UIBarButtonItem!
    
    var dic : UIReferenceLibraryViewController?
    var dicView : UIView?
    
    
    var selected  = [String]()
    
    
    @IBOutlet weak var dicCanvas: UIView!
    
    
    var player : AVPlayer?
    
    
    var shownAnswer = false
    var check       = false
    
    
    var history : DictationHistory!
    
    
    @IBAction func check(_ sender: UIBarButtonItem) {
    
        check = !check
        
        sender.image = check ? UIImage(named:"check") : UIImage(named:"uncheck")
    }
    
    
    @IBAction func previous(_ sender: Any) {
    }
    
    @IBAction func showAnswer(_ sender: UIButton) {
        
        if shownAnswer == false
        {
            showWord()
            return
        }
        

        
        sender.isHidden = true
        
        self.dic = UIReferenceLibraryViewController(term: words[step])
        
        dicView?.removeFromSuperview()
        dicView = self.dic?.view
        
        dicView?.frame = dicCanvas.bounds
        
        dicView?.frame.origin.y -= 44
        dicView?.frame.size.height += 88
        
        self.dicCanvas.addSubview(dicView!)
    }
    
    
    @IBAction func read(_ sender: UIButton) {
        
        Sound.shared.speak(word: words[step],type:sender.tag)

    }
    func showWord()
    {
        shownAnswer = true
        
        self.answerButton.setTitle(words[step], for: .normal)
        self.answerButton.setTitle(words[step], for: .highlighted)
        self.nextButton.setTitle("Next", for: .normal)
        
        //self.answerButton.backgroundColor = ColorGreen
    }
    
    func showErrorWords()
    {
        let list = self.storyboard?.instantiateViewController(withIdentifier: "list") as! WordList
        list.wrongWords = self.selected
        self.navigationController?.pushViewController(list, animated: true)
    }
    func showAllWords()
    {
        let list = self.storyboard?.instantiateViewController(withIdentifier: "list") as! WordList
        list.wrongWords = self.words
        list.canDictate = false
        self.navigationController?.pushViewController(list, animated: true)
    }
    
    var saved = false
    @IBAction func next(_ sender: UIButton) {
        
        if saved
        {
            return
        }
        

        
        if shownAnswer == false
        {
            showWord()
            return
        }
        
        if self.check
        {
            selected.append(words[step])
            history.add(word: words[step])
        }
        
        if step >= (words.count - 1)
        {
            self.nextButton.setTitle("Save", for: .normal)
            self.nextButton.backgroundColor = ColorGreen
            


            if dontSave
            {
                self.nextButton.setTitle("Finish", for: .normal)
            }else
            {
                let item = UIBarButtonItem(title: "Wrong words", style: .plain, target: self, action: #selector(Dictation.showErrorWords))
                self.navigationItem.rightBarButtonItem = item
                
                let alert = UIAlertController(title: "Save the result ?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
                
                self.history.save()
                self.saved = true
                self.nextButton.setTitle("Saved", for: .normal)
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        

        
        self.dicView?.removeFromSuperview()
        self.nextButton.setTitle("Show Word", for: .normal)
        
        
        self.check = false
        self.checkButtonItem?.image = UIImage(named:"uncheck")
        
        answerButton.isHidden = false
        answerButton.setTitle("?", for: .normal)
        answerButton.setTitle("?", for: .highlighted)
        shownAnswer = false
        
        
        
        step += 1
        let but = UIButton()
        but.tag = 2
        self.read(but)
        
        self.progressView.progress = Float(step+1) / Float(words.count)
        //self.title = String(step+1) + " / " + String(words.count) + " (" + String(selected.count) + ")"
        if selected.count != 0
        {
            self.countBarItem.title = String(selected.count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        history = DictationHistory.history(type:self.type)
        
        self.progressView.progress = 0
        self.title = ""
        //self.countBarItem.title = ""
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"close"), style: .plain, target: self, action: #selector(Dictation.back))
        
        
        if self.dontSave
        {
            let item = UIBarButtonItem(title: "All", style: .plain, target: self, action: #selector(Dictation.showAllWords))
            self.navigationItem.rightBarButtonItem = item
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    func back()
    {
        if saved
        {
            self.navigationController?.popViewController(animated: true)
            return 
        }
        
        let alert = UIAlertController(title: "Exit ?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
