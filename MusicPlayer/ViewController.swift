//
//  ViewController.swift
//  MusicPlayer
//
//  Created by khacviet on 11/25/16.
//  Copyright © 2016 khacviet. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioPlayerDelegate
{
    var isPlaying = true
    var trackId: Int = 0
    var libary = ["IDo - 911", "MotNha - VickyNhung", "OngBaAnh - LeThienHieu", "PhiaSauMotCoGai - SoobinHoangSon"]
    var audio = AVAudioPlayer()
    
    @IBOutlet weak var lbl_Musicname: UILabel!
    @IBOutlet weak var lbl_TimeCurrent: UILabel!
    @IBOutlet weak var lbl_TimeTotal: UILabel!
    @IBOutlet weak var sld_Duration: UISlider!
    @IBOutlet weak var sld_Volume: UISlider!
    @IBOutlet weak var btn_Play: UIButton!
    @IBOutlet weak var btn_Next: UIButton!
    @IBOutlet weak var btn_Previous: UIButton!
    @IBOutlet weak var switch_Repeat: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addThumImgForSld()
        setTrack()
        audio.delegate = self
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateTimeCurrent), userInfo: nil, repeats: true)
    }
    func addThumImgForSld() {
        sld_Volume.setThumbImage(UIImage(named: "thumb.png"), forState: .Normal)
        sld_Volume.setThumbImage(UIImage(named: "thumbHightLight.png"), forState: .Highlighted)
        sld_Duration.setThumbImage(UIImage(named: "duration.png"), forState: .Normal)
        btn_Play.setImage(UIImage(named: "play.png"), forState: .Normal)
    }
    func checkRepeatSwitch() {
        if switch_Repeat.on {
            audio.numberOfLoops = -1
        }
        else {
            audio.numberOfLoops = 0
        }
    }
    func checkBtnPlay() {
        if isPlaying == false {
            audio.prepareToPlay()
            audio.play()
        }
    }
    func setTrack() {
        let filePath = NSBundle.mainBundle().pathForResource(libary[trackId], ofType: ".mp3")
        let url = NSURL(fileURLWithPath: filePath!)
        audio = try! AVAudioPlayer(contentsOfURL: url)
        checkRepeatSwitch()
        setTotalTime()
        lbl_Musicname.text! = libary[trackId]
        sld_Duration.value = 0
        sld_Duration.maximumValue = Float(audio.duration)
        audio.volume = sld_Volume.value
        print(audio.volume)
    }
    func setTotalTime() {
        let minu = Int(audio.duration / 60)
        let sec = Int(audio.duration % 60)
        lbl_TimeTotal.text! = "\(minu):\(sec)"
    }
    func updateTimeCurrent() {
        let minu = Int(audio.currentTime / 60)
        let sec = Int(audio.currentTime % 60)
        if minu < 10 && sec < 10 {
            lbl_TimeCurrent.text! = "\(minu):0\(sec)"
        }
        else if minu < 10 && sec >= 10 {
            lbl_TimeCurrent.text! = "0\(minu):\(sec)"
        }
        else {
            lbl_TimeCurrent.text! = "\(minu):\(sec)"
        }
        self.sld_Duration.value = Float(audio.currentTime)
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if trackId >= 3 {
            isPlaying = !isPlaying
            btn_Play.setImage(UIImage(named: "play.png"), forState: .Normal)
        }
        else{
            setTrack()
            action_Next(trackId)
        }
    }
    @IBAction func action_Duration(sender: UISlider) {
        audio.currentTime = Double(sender.value)
    }
    @IBAction func action_Play(sender: AnyObject) {
        if isPlaying {
            audio.play()
            btn_Play.setImage(UIImage(named: "pause.png"), forState: .Normal)
        }
        else {
            audio.pause()
            btn_Play.setImage(UIImage(named: "play.png"), forState: .Normal)
        }
        isPlaying = !isPlaying
    }
    @IBAction func action_Next(sender: AnyObject) {
        btn_Previous.hidden = false
        if trackId < 3 {
            trackId = trackId + 1
            setTrack()
            checkBtnPlay()
            setTotalTime()
            audio.delegate = self
        }
        if trackId >= 3 {
            btn_Next.hidden = true
        }
    }
    @IBAction func action_Previous(sender: AnyObject) {
        btn_Next.hidden = false
        if trackId > 0 {
            trackId = trackId - 1
            setTrack()
            checkBtnPlay()
            setTotalTime()
            audio.delegate = self
        }
        if trackId <= 0 {
            btn_Previous.hidden = true
        }
    }
    @IBAction func sld_Volume(sender: UISlider) {
        audio.volume = sender.value
    }
    @IBAction func action_Switch(sender: UISwitch) {
        checkRepeatSwitch()
    }
}