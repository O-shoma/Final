//
//  TabBarController.swift
//  Final
//
//  Created by かけしん on 2020/05/25.
//  Copyright © 2020 Kakeshin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.delegate = self
        
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
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

//MARK: - UITabBarControllerDelegate


extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CameraViewController {
            //CameraViewControllerは、タブ切り替えではなくモーダル遷移
            if let cameraViewController = storyboard?.instantiateViewController(withIdentifier: "Camera") {
                present(cameraViewController, animated: true)
                
                return false
            }
        }
        
        //その他のViewControllerは通常のタブ切り替え
        return true
    }
}
