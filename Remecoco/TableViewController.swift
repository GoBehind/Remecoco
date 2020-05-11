//
//  TableViewController.swift
//  Remecoco
//
//  Created by 王冠之 on 2020/5/6.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//
import AVFoundation
import UIKit

class TableViewController: UITableViewController, AVAudioRecorderDelegate {
    
    //var rh: RecordHelper?
    let rh = RecordHelper()
    var recordings: [String] = []
    var stop:Bool = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let home = URL(fileURLWithPath: NSHomeDirectory())
        let docs = home.appendingPathComponent("Documents")
        do{
            let contents = try FileManager.default.contentsOfDirectory(atPath: docs.path)
            
            for file in contents {
                if file != ".DS_Store"{
                    self.recordings.append(file)
                }
            }
        }catch{
            print("error \(error)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.recordings.count)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let note = self.recordings[indexPath.row]
        cell.cellText.text = note
        
        return cell
        }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //設定刪除
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            let recording = self.recordings.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            //刪除真的音檔
            let path = NSHomeDirectory() + "/Documents/" + recording
            TableViewController.deleteFile(path: path)
            
            //保險用
            self.tableView.reloadData()
            
            //呼叫完成處理器來取消動作按鈕
            completionHandler(true)
        }
        
        //設定分享
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            
            let defaultText = "From Kuan's iPhone >_^\n" +  self.recordings[indexPath.row]
            let activityController: UIActivityViewController!
            
            let recording = self.recordings[indexPath.row]
            let path = NSHomeDirectory() + "/Documents/" + recording
            let url = URL(fileURLWithPath: path)

            activityController = UIActivityViewController(activityItems: [defaultText, url], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            
            //呼叫完成處理器來取消動作按鈕
            completionHandler(true)
        }
        
        //設定刪除圖示
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(systemName: "trash")
        
        //設定分享圖示
        shareAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        //防止滑到底直接執行第一個動作
        swipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let indexPath = self.tableView.indexPathForSelectedRow{
            let recording = self.recordings[indexPath.row]
            let path = NSHomeDirectory() + "/Documents/" + recording
            let url = URL(fileURLWithPath: path)
            do{
                try rh.audioPlayer = AVAudioPlayer(contentsOf: url)
            }catch{
                rh.audioPlayer = nil
            }
        }

        if let player = rh.audioPlayer {
            if stop == false{
                player.currentTime = 0.0
                player.play()
                stop = true
            }else if stop == true{
            player.stop()
            player.currentTime = 0.0
            player.play()
            stop = false
            }
        }
    }
    
    static func deleteFile(path:String){//刪除檔案
        
        let manager = FileManager.default
        do{
            try manager.removeItem(atPath: path)
        }catch{
            print("失敗:\(error)")
        }
    }
}
