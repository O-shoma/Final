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
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CameraViewController: ARSCNViewDelegate {
    
}
