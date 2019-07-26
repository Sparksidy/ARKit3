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
   
    @IBOutlet weak var play: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.worldTracking.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.worldTracking.showsStatistics = true
        self.configuration.planeDetection = .horizontal
        self.worldTracking.delegate = self
       
        self.worldTracking.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor)
    {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let lavaNode = createLava(planeAnchor : planeAnchor)
        node.addChildNode(lavaNode)
    }
    
    func createLava(planeAnchor: ARPlaneAnchor)->SCNNode
    {
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Lava")
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
        lavaNode.eulerAngles = SCNVector3(90.degToRad, 0, 0)
        return lavaNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes{(childNode, _) in
            childNode.removeFromParentNode()
        }
        let lavaNode = createLava(planeAnchor : planeAnchor)
        node.addChildNode(lavaNode)
    }
}

func +(left: SCNVector3, right: SCNVector3)->SCNVector3
{
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

extension Int {
    var degToRad : Double {return Double(self) * .pi/180}
}

