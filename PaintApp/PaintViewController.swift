//
//  PaintViewController.swift
//  PaintApp
//
//  Created by shimabox on 2015/09/20.
//  Copyright © 2015年 shimabox. All rights reserved.
//

import UIKit
import AVFoundation

class PaintViewController: UIViewController, ACEDrawingViewDelegate, AVAudioPlayerDelegate {
    
    // 背景画像とお絵かきゾーンをまとめたもの
    @IBOutlet weak var canvasView: UIView!
    
    // 背景画像
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // お絵かき
    @IBOutlet weak var drawView: ACEDrawingView!
    
    // 音
    var audioPlayer:AVAudioPlayer?
    
    // 選択カメラ画像
    var cameraImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAudioPlayer()
        drawImage()
    }
    
    // AudioPlayerの初期化
    private func initAudioPlayer() {
        audioPlayer = createAudioPlayer()
        
        guard let ap = audioPlayer else {
            return
        }
        
        ap.delegate = self
        ap.prepareToPlay()
    }
    
    // AudioPlayerの生成
    private func createAudioPlayer() -> AVAudioPlayer? {
        // 再生する audio ファイルのパスを取得
        // onara_002.mp3 @link http://onara-mp3.com/material.html
        let audioPath = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("onara_002", ofType: "mp3")!)
        
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioPath, fileTypeHint: nil)
        } catch {
            //Handle the error
            print("Error : PaintViewController->createAudioPlayer()")
        }
        
        return audioPlayer;
    }
    
    // お絵かきする
    private func drawImage(){
        
        drawView.drawTool = ACEDrawingToolTypePen
        drawView.lineWidth = 3.0
        // デリゲート
        drawView.delegate = self
        
        if let image = cameraImage{
            //背景画像に
            backgroundImageView.image = image
        }
    }
    
    // 保存するボタン押下時
    @IBAction func tapSaveButton(sender: UIButton) {
        // 背景とお絵かき画像を重ねて画像化します。
        UIGraphicsBeginImageContextWithOptions(canvasView.frame.size, false, 0)
        
        canvasView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let exportImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        // 写真アルバムに保存します。
        UIImageWriteToSavedPhotosAlbum(exportImage,
            self, "image:didFinishSavingWithError:contextInfo:", nil)
        
    }
    
    // callback
    func image(image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutablePointer<Void>) {
        if error != nil {
            print(error.code)
        }
        else {
            showSaveAlert()
        }
    }
    
    // 保存成功時のアラート表示
    func showSaveAlert() {
        let alert = UIAlertController(title: "保存しました！", message: "画像をカメラロールに保存しました。", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action -> Void in })
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // 削除するボタン押下時
    @IBAction func tapDeleteButton(sender: UIButton) {
        
        let alertController = UIAlertController(title: "ちょっとまって！", message: "お絵描きを消しますか？", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "はい。消します！", style: .Default) {
            action in self.drawView.clear()
        }
        let cancelAction = UIAlertAction(title: "消さない！", style: .Cancel) { action -> Void in }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // ACEDrawingView delegate method
    // - (void)drawingView:(ACEDrawingView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool;
    // - (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
    
    // タッチエンド(お絵描き終了)
    func drawingView(view:ACEDrawingView, didEndDrawUsingTool tool:AnyObject) {
        if let ap = audioPlayer {
            ap.play()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
