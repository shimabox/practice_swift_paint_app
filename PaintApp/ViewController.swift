//
//  ViewController.swift
//  PaintApp
//
//  Created by shimabox on 2015/09/20.
//  Copyright © 2015年 shimabox. All rights reserved.
//

import UIKit

class ViewController: UIViewController
, UIImagePickerControllerDelegate
, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Cameraを撮る
    @IBAction func tapCamButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            let cam = UIImagePickerController()
            cam.sourceType = .Camera
            // cam.allowsEditing = true
            cam.delegate = self
            
            presentViewController(cam, animated:true, completion:nil)
        }
    }
    
    // 画像を選択
    @IBAction func tapSelectImageButton(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            // picker.allowsEditing = true
            picker.delegate = self
            
            presentViewController(picker, animated:true, completion: nil)
        }
    }
    
    // そのまま描く
    @IBAction func tapDrawButton(sender: UIButton) {
        viewTransition()
    }
    
    // Use Photo選択で呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        viewTransition(image)
        
        // カメラ画面を閉じる
        picker.dismissViewControllerAnimated(true, completion:nil)
    }
    
    // 画面遷移
    func viewTransition(image:UIImage? = nil){
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PaintView") as? PaintViewController{
            vc.cameraImage = image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}