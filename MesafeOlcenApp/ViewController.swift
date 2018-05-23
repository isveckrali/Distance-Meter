//
//  ViewController.swift
//  MesafeOlcenApp
//
//  Created by Flyco Developer on 22.05.2018.
//  Copyright © 2018 Flyco Global. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var mesafeLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    var firstDot: SCNNode?
    var secondDot : SCNNode?
    
    @IBAction func buttonAction(_ sender: Any) {
     
        if firstDot == nil {
            firstDot = createDot()
            button.setTitle("İkinci Nokta", for: UIControlState.normal)
        } else if secondDot == nil {
            secondDot = createDot()
            //hesaplama
            mesafeLabel.text =  mesafeyiHesapla()
            button.setTitle("Sıfırla", for: UIControlState.normal)
        } else {
            button.setTitle("İlk Nokta", for: UIControlState.normal)
            mesafeLabel.text = ""
            firstDot?.removeFromParentNode()
            secondDot?.removeFromParentNode()
            firstDot = nil
            secondDot = nil
        }
        
    }
    func createDot() -> SCNNode? {
        let userTouch = sceneView.center
        let results = sceneView.hitTest(userTouch, types: .featurePoint)
        if let resultOne = results.first {
            let dot = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.01)
            let materail = SCNMaterial()
            materail.diffuse.contents = UIColor.red
            dot.firstMaterial = materail
            
            let dotNode = SCNNode(geometry: dot)
            dotNode.position = SCNVector3(resultOne.worldTransform.columns.3.x, resultOne.worldTransform.columns.3.y, resultOne.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(dotNode)
            return dotNode
        }
        return nil
    }
    
    func mesafeyiHesapla()  -> String {
        if let firstDot = firstDot {
            if let secondDot = secondDot {
                let vector = SCNVector3Make(secondDot.position.x - firstDot.position.x, secondDot.position.y - firstDot.position.y, secondDot.position.z - firstDot.position.z)
                let mesafe = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z )
                return "Mesafe: \(String(mesafe))"
            }
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        mesafeLabel.text = ""
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
