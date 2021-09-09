//
//  ViewController.swift
//  RockPaperScissors
//
//  Created by Huey Bai on 4/8/21.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!
    
    @IBOutlet weak var playerScoreLable: UILabel!
       
    @IBOutlet weak var computerScoreLable: UILabel!
    
    @IBOutlet weak var scoreBar: UIStackView!
    
    @IBOutlet weak var promptInformation: UILabel!
    
    @IBOutlet weak var scissor: UIButton!
    
    @IBOutlet weak var rock: UIButton!
    
    @IBOutlet weak var paper: UIButton!
    
    @IBOutlet weak var chooseColumn: UIStackView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var coachingOverlay: ARCoachingOverlayView!
    
    private let box = try! Experience.loadBox()
    
    private let system = GameSystem.instance
    
    private let feedback = UIImpactFeedbackGenerator(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptInformation.isHidden = true
        let arConfiguration = ARWorldTrackingConfiguration()
        arConfiguration.planeDetection = .horizontal
        
        // People occlusion
        let semantics: ARConfiguration.FrameSemantics = [.personSegmentationWithDepth]
        if type(of: arConfiguration).supportsFrameSemantics(semantics){
            arConfiguration.frameSemantics = semantics;
        }
        
        // Object occlusion
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        
        arView.session.run(arConfiguration)
        presentCoachingOverlay()
    }
    
    @IBAction func chooseGestureAction(_ sender: UIButton) {
        feedback.impactOccurred()
        switch sender.restorationIdentifier{
            case "scissorButton":
                print("Player: Scissor")
                box.notifications.hide.post()
                box.notifications.scissorsUser.post()
            case "rockButton":
                print("Player: Rock")
                box.notifications.hide.post()
                box.notifications.rockUser.post()
            case "paperButton":
                print("Player: Paper")
                box.notifications.hide.post()
                box.notifications.scissorsUser.post()
            default: return
        }
        chooseColumn.isHidden = true
        let computerChoose = checkComputerDetermine()
        system.compare(playerChoose: .Scissor, computerChoose: computerChoose)
    }
    
    @IBAction func onTapToCastScenes(_ sender: UITapGestureRecognizer) {
        let tapLocation: CGPoint = sender.location(in: arView)
        let estimatedPlane: ARRaycastQuery.Target = .estimatedPlane
        let alignment: ARRaycastQuery.TargetAlignment = .horizontal
                        
        let result: [ARRaycastResult] = arView.raycast(from: tapLocation,
                                                           allowing: estimatedPlane,
                                                          alignment: alignment)
                
        guard let rayCast: ARRaycastResult = result.first
        else {
            print("Failed to get the result of casting")
            promptInformation.text = "Casting failed, please click again"
            return
        }
                
        let anchor = AnchorEntity(world: rayCast.worldTransform)
        anchor.addChild(box)
        arView.scene.anchors.append(anchor)
        print("------------------")
        print(rayCast)
        
        chooseColumn.isHidden = false
        scoreBar.isHidden = false
        tapGesture.isEnabled = false
        promptInformation.isHidden = true
        box.actions.completeARound.onAction = prepareNextContent(_:)
        box.notifications.showQuestionMark.post()
    }
    
    func checkComputerDetermine() -> GameGestures{
        let computChoose = system.getComputerChoose()
        switch computChoose {
            case .Paper:
                print("Computer: Paper\n")
                box.notifications.paperCpu.post()
            case .Rock:
                print("Computer: Rock\n")
                box.notifications.rockCpu.post()
            case .Scissor:
                print("Computer: Scissor\n")
                box.notifications.scissorsCpu.post()
        }
        return computChoose
    }
   
    func updataScoreDisplay(){
        playerScoreLable.text = String(system.playerScore)
        computerScoreLable.text = String(system.computerScore)
    }
    
    func prepareNextContent(_ entity: Entity?){
        updataScoreDisplay()
        if system.haveWiner(){
            if system.isPlayerWin(){
                box.notifications.playerWin.post()
            }
            //TODO: Show another game button
        }else{
            box.notifications.showQuestionMark.post()
            chooseColumn.isHidden = false
        }
    }
}
