//
//  ViewController.swift
//  WorldTracking
//
//  Created by Siddharth  Gupta on 6/30/19.
//  Copyright © 2019 Siddharth  Gupta. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var worldTracking: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
   
    @IBAction func play(_ sender: Any)
    {
        self.addnode()
        self.play.isEnabled = false
    }
    @IBAction func reset(_ sender: Any)
    {
        
    }
    @IBOutlet weak var play: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.worldTracking.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.worldTracking.showsStatistics = true
        self.worldTracking.session.run(configuration)
        let taprecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.worldTracking.addGestureRecognizer(taprecognizer)
    }
    
    func addnode()
    {
        let jellyfish = SCNScene(named: "art.scnassets/Jellyfish.scn")
        let jellyfishnode = jellyfish?.rootNode.childNode(withName: "Sphere", recursively: false)
        jellyfishnode?.position = SCNVector3(0,-2,-1)
        self.worldTracking.scene.rootNode.addChildNode(jellyfishnode!)
    }
    @objc func handleTap(sender: UIGestureRecognizer)
    {
        let sceneviewTappedOn = sender.view as! SCNView
        let touchCoords = sender.location(in: sceneviewTappedOn)
        let hitTest = sceneviewTappedOn.hitTest(touchCoords)
        if hitTest.isEmpty
        {
            print("Fail")
        }
        else
        {
            let results = hitTest.first!
            let node = results.node
            self.animateNode(node: node)
            print("Pass")
        }
        
    }
    
    func animateNode(node: SCNNode)
    {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(0,0,node.presentation.position.z - 1)
        spin.duration = 1
        spin.repeatCount =  5
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "position")
    }
}

func +(left: SCNVector3, right: SCNVector3)->SCNVector3
{
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

extension Int {
    var degToRad : Double {return Double(self) * .pi/180}
}

