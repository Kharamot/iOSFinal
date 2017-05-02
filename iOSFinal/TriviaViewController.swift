//
//  TriviaViewController.swift
//  iOSFinal
//
//  Created by Kameron Haramoto on 4/29/17.
//  Copyright © 2017 Kameron Haramoto. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class TriviaViewController: UIViewController {

    var isLightning: Bool = false
    var q: [NSManagedObject] = []
    var audioPlayer: AVAudioPlayer!
    var i = 0
    var score = 0
    var delayTimer = MyTimer(initial: 1)
    var gameTimer = MyTimer(initial: 10)
    var iosTimer: Timer!
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var skillImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.gameOverLabel.isHidden = true
        self.finalScoreLabel.isHidden = true
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.frame = self.view.frame
        self.backgroundImage.addSubview(effectView)
        if(isLightning){
            timeLabel.text = "Time: 5"
        }
        print(q[0].value(forKey: "is_voice") as! Bool)
        self.skillImage.isHidden = true
        self.runGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.skillImage.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func runGame(){
        if(i<10){
            self.displayQuestion(i: i)
            //i = i+1
        }
        if(i==10){
            self.endGame()
        }
    }
    @IBAction func buttonAPressed(_ sender: UIButton) {
        self.iosTimer.invalidate()
        self.buttonA.isEnabled = false
        self.buttonB.isEnabled = false
        self.buttonC.isEnabled = false
        self.buttonD.isEnabled = false
        if(sender.titleLabel?.text == q[i].value(forKey: "c_answer") as? String){
            self.questionLabel.text = "CORRECT"
            self.score = score + 10
            self.scoreLabel.text = "SCORE: \(score)"
        }
        else{
            self.questionLabel.text = "WRONG!"
        }
        self.delayTimer = MyTimer(initial: 1)
        self.delayTimer.start()
        self.iosTimer = Timer.init(timeInterval: 1.0, repeats: true, block: handleTick)
        RunLoop.current.add(iosTimer, forMode: .defaultRunLoopMode)
        i = i+1
    }
    
    func displayQuestion(i: Int){

        if(isLightning)
        {
            self.gameTimer = MyTimer(initial: 5)
        }
        else{
            self.gameTimer = MyTimer(initial: 10)
        }
        self.timeLabel.text = "Time: \(gameTimer.current)"
        let quest = q[i]
        let b = quest.value(forKey: "is_voice") as! Bool
        self.questionLabel.text = quest.value(forKey: "question") as? String
        self.buttonA.setTitle(quest.value(forKey: "c_answer") as! String?, for: .normal)
        self.buttonB.setTitle(quest.value(forKey: "a1_answer") as! String?, for: .normal)
        self.buttonC.setTitle(quest.value(forKey: "a2_answer") as! String?, for: .normal)
        self.buttonD.setTitle(quest.value(forKey: "a3_answer") as! String?, for: .normal)
        
        if(b){
            let URL = quest.value(forKey: "file") as! String
            let soundURL = Bundle.main.url(forResource: URL, withExtension: nil)
                
            do{
                self.audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            }catch{
                print("error playing sound")
            }
            self.audioPlayer.volume = 0.33
            //audioPlayer.numberOfLoops = 1
            self.audioPlayer.play()
        }
        else{
            let f = quest.value(forKey: "file") as! String
            let p = UIImage(named: f)!
            self.skillImage.image = p
            self.skillImage.isHidden = false
        }
        self.buttonA.isEnabled = true
        self.buttonB.isEnabled = true
        self.buttonC.isEnabled = true
        self.buttonD.isEnabled = true
        self.gameTimer.start()
        self.iosTimer = Timer.init(timeInterval: 1.0, repeats: true, block: handleGameTick)
        RunLoop.current.add(iosTimer, forMode: .defaultRunLoopMode)
    }
    
    func endGame(){
        iosTimer.invalidate()
        print("gameEnded")
        let highScore = UserDefaults.standard
        
        if(highScore.object(forKey: "highScore") == nil)
        {
            highScore.set(score, forKey: "highScore")
        }
        else{
            if(highScore.integer(forKey: "highScore") < score){
                highScore.set(score, forKey: "highScore")
            }
        }
        self.questionLabel.isHidden = true
        self.buttonA.isHidden = true
        self.buttonB.isHidden = true
        self.buttonC.isHidden = true
        self.buttonD.isHidden = true
        self.skillImage.isHidden = true
        
        self.finalScoreLabel.text = "SCORE: \(score)"
        self.finalScoreLabel.isHidden = false
        self.gameOverLabel.isHidden = false
    }
    
    func handleGameTick(timer: Timer){
        print("Gtick")
        let done = self.gameTimer.decrement()
        DispatchQueue.main.async {
            self.timeLabel.text = "Time: \(self.gameTimer.current)"
        }
        
        print(self.gameTimer.current)
        print(done)
        if(done){
            self.iosTimer.invalidate()
            self.buttonA.isEnabled = false
            self.buttonB.isEnabled = false
            self.buttonC.isEnabled = false
            self.buttonD.isEnabled = false
            self.questionLabel.text = "WRONG!"
            self.delayTimer = MyTimer(initial: 1)
            self.delayTimer.start()
            self.iosTimer = Timer.init(timeInterval: 1.0, repeats: true, block: handleTick)
            RunLoop.current.add(iosTimer, forMode: .defaultRunLoopMode)
            self.i = i+1
        }
    }
    
    func handleTick(timer: Timer) {
        print("tick")
        let done = delayTimer.decrement()
        //timeRemainingLabel.text = "Time remaining: \(delayTimer.current)"
        if (done) {
            self.iosTimer.invalidate()
            self.skillImage.isHidden = true
            runGame()
            //timesUpLabel.isHidden = false
            //startStopButton.isEnabled = false
            //resetButton.isEnabled = true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
