//
//  PaintViewController.swift
//  PaintApp
//
//  Created by shimabox on 2015/09/20.
//  Copyright © 2015年 shimabox. All rights reserved.
//

import UIKit

class PaintViewController: UIViewController {

    // 背景画像とお絵かきゾーンをまとめたもの
    @IBOutlet weak var canvasView: UIView!
    
    // 背景画像
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // お絵かき
    @IBOutlet weak var drawView: ACEDrawingView!
    
    // 選択カメラ画像
    var cameraImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawImage()
    }
    
    // お絵かきする
    private func drawImage(){
        
        drawView.drawTool = ACEDrawingToolTypePen
        drawView.lineWidth = 3.0
        
        if let image = cameraImage{
            //背景画像に
            backgroundImageView.image = image
        }
    }
    
    // 保存するボタン押下時
    @IBAction func tapSaveButton(sender: UIButton) {
        //背景とお絵かき画像を重ねて画像化します。
        UIGraphicsBeginImageContextWithOptions(canvasView.frame.size, false, 0)
        
        canvasView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let exportImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        //写真アルバムに保存します。
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
