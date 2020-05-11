//
//  ViewController.swift
//  Remecoco
//
//  Created by 王冠之 on 2020/4/26.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit
import AVFoundation

//列舉，避免打錯字 ：）
enum AudioSessionMode {
    case record
    case play
}

class ViewController: UIViewController, AVAudioRecorderDelegate{

    var recordName: [String] = []
    var VCrecordings : [String] = []
    
    @IBAction func recordAudio(_ sender: UIButton) {
        recordAudio()
    }
    
    @IBAction func stopRecord(_ sender: UIButton) {
        stopRecord()
    }
    
    @IBAction func playRecordedSound(_ sender: UIButton) {
        playRecordedSound()
    }
    
    @IBAction func stopPlay(_ sender: UIButton) {
        stopPlay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
    
    //MARK: - Segue 傳送資料(Test)
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToTablevVew" {
//
//            let destinationController = segue.destination as! TableViewController
//            destinationController.recordings = recordName
//
//        }
//    }
    //MARK: - Methods
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var isRecording = false
    var tbv : TableViewController!
    
    //調整音訊工作階段
    func settingAudioSession(mode: AudioSessionMode){
        let session = AVAudioSession.sharedInstance()
        do {
            switch mode {
            case .record:
                try session.setCategory(AVAudioSession.Category.playAndRecord)
            default:
                try session.setCategory(AVAudioSession.Category.playback)
                try session.setActive(false)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func recordAudio() {
        //設定存擋
        
        //設定錄音存擋位置
        let path = NSHomeDirectory() + "/Documents/" + datetime() + ".m4a"
        let url = URL(fileURLWithPath: path)
        recordName.append(datetime())
        VCrecordings.append(path)
        
        //設定錄音品質
        let recordSettings: [String:Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0 //取樣的品質
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recordSettings)
            audioRecorder?.delegate = self
        } catch {
            print(error.localizedDescription)
        }
        
        settingAudioSession(mode: .record)
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
        isRecording = true
    }
    
    func stopRecord() {
        audioRecorder?.stop()
        isRecording = false
        settingAudioSession(mode: .play)
    }
    
    func playRecordedSound() {
        if isRecording == false{
            audioPlayer?.stop() //先停止播放
            audioPlayer?.currentTime = 0.0
            audioPlayer?.play()
        }
    }
    
    func stopPlay() {
        if isRecording == false{
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0.0
        }
    }

    func datetime() -> String {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss E,d,MMM,y"
        return formatter.string(from: today)
    }
    
    //錄音是否成功
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true{
            //recorder.url
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: recorder.url)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

