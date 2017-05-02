//
//  ViewController.swift
//  iOSFinal
//
//  Created by Kameron Haramoto on 4/25/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var hsLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    var quest: [NSManagedObject] = []
    let highScore = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hsLabel.isHidden = true
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.view.frame
        self.backgroundImage.addSubview(effectView)
        
        if(highScore.object(forKey: "highScore") != nil){
            self.hsLabel.text = "HIGH SCORE: \(highScore.integer(forKey: "highScore"))"
            self.hsLabel.isHidden = false
        }
        else{
            self.initGame()
        }
        self.startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(highScore.object(forKey: "highScore") != nil){
            self.hsLabel.text = "HIGH SCORE: \(highScore.integer(forKey: "highScore"))"
            self.hsLabel.isHidden = false
        }
    }
    
    func initGame()
    {
        Database.db.createQuestion("Whos Voice?", "Ana", "Mercy", "Mei", "Phara", "Ana_-_Take_your_medicine.wav", true)
        Database.db.createQuestion("Whos Skill?", "Genji", "Hanzo", "Soldier76", "Junkrat", "genji-ult.png", false)
        Database.db.createQuestion("Whos Voice?", "Dva", "Ana", "Widowmaker", "Symmetra", "D.VA_-_See_Ya.mp3", true)
        Database.db.createQuestion("Whos Skill?", "McCree", "RoadHog", "Genji", "Honzo", "mccree-ult.png", false)
        Database.db.createQuestion("Whos Skill?", "Pharah", "Tracer", "Genji", "Winston", "parah-boop.png", false)
        Database.db.createQuestion("Whos Voice?", "Mei", "Ana", "Symmetra", "Dva", "Mei_-_Yay_1.mp3", true)
        Database.db.createQuestion("Whos Voice?", "Roadhog", "Junkrat", "Lucio", "Reaper", "Roadhog_-_Rollin'_Out.mp3", true)
        Database.db.createQuestion("Whos Skill?", "Sombra", "McCree", "Reaper", "Soldier76", "sombra-passive.png", false)
        Database.db.createQuestion("Whos Voice?", "McCree", "Junkrat", "Lucio", "Reaper", "McCree_-_Hey.mp3", true)
        Database.db.createQuestion("Whos Voice?", "Junkrat", "Winston", "Zenyatta", "Reaper", "Junkrat_-_Brrring!.mp3", true)
        
    }
    func startGame(){
        quest = Database.db.fetchQuestions()!
        for q in quest{
            print(q.value(forKey: "question") as! String)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let triviaVC = segue.destination as! TriviaViewController
        
        if(segue.identifier == "ToNormal")
        {
            triviaVC.isLightning = false
        }
        if(segue.identifier == "ToLightning")
        {
            triviaVC.isLightning = true
        }
        triviaVC.q = quest
    }
}

