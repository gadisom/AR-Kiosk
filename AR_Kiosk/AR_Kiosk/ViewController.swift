//
//  ViewController.swift
//  AR_Kiosk
//
//  Created by 김정원 on 2023/07/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    
    @IBOutlet weak var vwContainer: UIView!
    @IBAction func buttonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated: true, completion: nil)
    }
    @IBOutlet var sceneView: ARSCNView!
    var pokeNode : SCNNode?
    func aa ()
    {
        DispatchQueue.main.async {
            self.vwContainer.alpha = 0.0
            self.vwContainer.isHidden = false
            UIView.animate(withDuration: 1.5, delay: 0.2,options: .curveEaseIn, animations: {
                self.vwContainer.alpha = 1.0
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        self.vwContainer.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

 @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
     // get the location of the touch in the view
     let location = gestureRecognize.location(in: sceneView)
     // get the nodes at that location
     let hitTestResults = sceneView.hitTest(location, options: [:])
     // if there is a hit, and the first node is the pokeNode, then present the HomeVC
     if let firstNode = hitTestResults.first?.node, firstNode == pokeNode {
         let storyboard = UIStoryboard(name: "Home", bundle: nil)
         let viewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
         self.present(viewController, animated: true, completion: nil)
     }
 }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Card", bundle: Bundle.main){
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("성공")
            
        }
        sceneView.session.run(configuration)
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        
    }
  
    func renderer (_ renderer : SCNSceneRenderer, nodeFor anchor: ARAnchor )-> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)
            
            if let pokeScene = SCNScene(named: "ARKiosk.scn") {
              if let pokeNode = pokeScene.rootNode.childNodes.first{
                  self.pokeNode = pokeNode
                  planeNode.addChildNode(pokeNode)
                  pokeNode.eulerAngles.x = .pi/3
                  aa()
                  
              }

            }
        }
        
        return node
    }
 
}
