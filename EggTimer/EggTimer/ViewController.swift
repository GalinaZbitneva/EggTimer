//
//  ViewController.swift
//  EggTimer
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var player: AVAudioPlayer?
    var time: [String:Int] = ["Soft": 5, "Medium": 7, "Hard": 12]
    var timer = Timer() // эта переменная нужна чтобы останавливать текущий тамер если была нажата другая кнопка
   
    
    @IBOutlet weak var eggsHeadline: UILabel!
    
    @IBOutlet weak var timerProgress: UIProgressView!
    
    @IBAction func pressedEgg(_ sender: UIButton) {
        
        timer.invalidate()//отключаем работающий таймер
        guard let hardness = sender.currentTitle else {
            return
        }
        
        let timeForBoiling = time[hardness]!
        // hardness - это надпись на кнопке,которая по совместительству будет ключом словаря
        
       startTimer(timeInMinutes: timeForBoiling)
    }
    
    func startTimer(timeInMinutes: Int) {
        
        var secondsRemaining = timeInMinutes * 60 //  потом перевести в секунды
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if secondsRemaining > 0 {
                
                self.eggsHeadline.text = "\(secondsRemaining) seconds"
                self.timerProgress.progress = 1.0 - (Float(secondsRemaining)/Float(timeInMinutes * 60))
                secondsRemaining -= 1
            } else {
                Timer.invalidate()// время истекло и таймер отключаем
                self.eggsHeadline.text = "Done"
                self.timerProgress.progress = 1.0
                self.playSound(soundName: "alarm_sound")
            }
        }
    }
    
    func playSound(soundName: String){
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else {
                return
            }
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
