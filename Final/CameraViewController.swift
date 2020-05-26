//
//  CameraViewController.swift
//  Final
//
//  Created by かけしん on 2020/05/25.
//  Copyright © 2020 Kakeshin. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class CameraViewController: UIViewController {
    
    //MARK: - Outlet
    
    @IBOutlet weak var arSceneView: ARSCNView!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.arSceneView.delegate = self
        // Do any additional setup after loading the view.
        
        let mySession = ARSession()
        self.arSceneView.session = mySession
        self.arSceneView.showsStatistics = true
        self.arSceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(self.pinched))
        self.arSceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        //タップ時画像を消す
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tappedView))
        self.arSceneView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        self.arSceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.arSceneView.session.pause()
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK: - Action
    
    
    /// 画像選択ボタン
    /// - Parameter sender: UIButton
    @IBAction func selectPhotoButton(_ sender: UIButton) {
        
        self.showUIImagePicker()
    }
    
    /// 戻るボタン
    /// - Parameter sender: UIButton
    @IBAction func backToPage(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    /// ピンチイン/ピンチアウト処理
    /// - Parameter recognizer: UIPinchGestureRecognizer
    @objc func pinched(recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed {
            self.arSceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == "photo" {
                    let pinchScaleX = Float(recognizer.scale) * node.scale.x
                    let pinchScaleY = Float(recognizer.scale) * node.scale.y
                    let pinchScaleZ = Float(recognizer.scale) * node.scale.z
                    
                    node.scale = SCNVector3(pinchScaleX, pinchScaleY, pinchScaleZ)
                    recognizer.scale = 1
                }
            }
        }
    }
    
    /// 画像削除処理
    /// - Parameter sender: UITapGestureRecognizer
    @objc private func tappedView(sender: UITapGestureRecognizer) {
        
        print("DEBUG_PRINT: touch")
        
        if sender.state == .began {
            let location = sender.location(in: self.arSceneView)
            let hitTest = self.arSceneView.hitTest(location)
            if let result = hitTest.first {
                if result.node.name == "photo" {
                    result.node.removeFromParentNode()
                }
            }
        }
    }
    
    
    //MARK: - PrivateMethod
    
    /// フォトライブラリを開く
    private func showUIImagePicker() {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            pickerController.modalPresentationStyle = .overFullScreen
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    /// Nodeの作成処理
    /// - Parameters:
    ///   - image: UIImage
    ///   - position: SCNVector
    /// - Returns: SCNNode
    private func createPhotoNode(_ image: UIImage, position: SCNVector3) -> SCNNode {
        
        let node = SCNNode()
        let scale: CGFloat = 0.3
        let geometry = SCNPlane(width: image.size.width * scale  / image.size.height, height: scale)
        geometry.firstMaterial?.diffuse.contents = image
        node.geometry = geometry
        node.position = position
        
        return node
    }
    
    /// スクリーンに画像を追加
    /// - Parameter image: UIImage
    private func setImageToScene(image: UIImage) {
        
        //カメラから500mm先の座標
        let position = SCNVector3(x: 0, y: 0, z: -0.5)
        //表示場所処理
        guard let camera = self.arSceneView.pointOfView else { return }
            //中央に配置
            let convertedPosition = camera.convertPosition(position, to: nil)
            let node = self.createPhotoNode(image, position: convertedPosition)
            //配置した画像を常にカメラ側に向かせる
            let frontCamera = SCNBillboardConstraint()
            //Y軸の回転は加えないようにする処理
            frontCamera.freeAxes = SCNBillboardAxis.Y
            node.constraints = [frontCamera]
            node.name = "photo"
            
            self.arSceneView.scene.rootNode.addChildNode(node)
            
            print("DEBUG_PRINT: \(node)")
    }
}

//MARK: - ARSCNViewDelegate

extension CameraViewController: ARSCNViewDelegate {
    
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    /// 画像選択時処理
    /// - Parameters:
    ///   - picker: UIImagePickerController
    ///   - info: UIImagePickerController.InfoKey: Any
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        self.setImageToScene(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

