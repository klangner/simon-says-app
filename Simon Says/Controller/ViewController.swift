//
//  ViewController.swift
//  Simon Says
//
//  Created by Krzysztof Langner on 02/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorButtons: [CircleButton]!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet var playerLabels: [UILabel]!
    @IBOutlet var scoreLabels: [UILabel]!

    var gameModel = Game()
    var colorsToTap = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorButtons = colorButtons.sorted() { $0.tag < $1.tag }
        playerLabels = playerLabels.sorted() { $0.tag < $1.tag }
        scoreLabels = scoreLabels.sorted() { $0.tag < $1.tag }
        newGameState()
    }
    
    // Switch to new game state
    func newGameState() {
        actionButton.isEnabled = true
        disableColorButton()
        actionButton.setTitle("Start Game", for: .normal)
        updatePlayerLabels()
    }
    
    // Play color sequence so the player can memorize them
    func memorizeState() {
        actionButton.isEnabled = false
        view.isUserInteractionEnabled = false
        actionButton.setTitle("Memorize", for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.animateSequence(0) {
                self.view.isUserInteractionEnabled = true
                self.playState()
            }
        }
    }
    
    // Allow player to replay sequence
    // Player can play sequence correctly or make error
    func playState() {
        colorsToTap = gameModel.colorSequence
        actionButton.setTitle("Tap the circles", for: .normal)
        for button in colorButtons {
            button.isEnabled = true
        }
    }
    
    // Player has successful solved the current level
    func successState() {
        disableColorButton()
        gameModel = gameModel.nextLevel()
        updatePlayerLabels()
        actionButton.isEnabled = true
        actionButton.setTitle("Continue", for: .normal)
    }
    
    // Player has failed to show correct sequnce
    func failedState() {
        disableColorButton()
        if gameModel.currentPlayer == 0 {
            actionButton.setTitle("Player 2 has won!", for: .normal)
        } else {
            actionButton.setTitle("Player 1 has won!", for: .normal)
        }
        gameModel = gameModel.resetLevel()
        UIView.animate(withDuration: 3, animations: {
            self.actionButton.alpha = 1
            self.actionButton.alpha = 0
            self.actionButton.alpha = 1
        }){ (bool) in self.newGameState() }

    }
    
    // Highlight current player and set scores
    func updatePlayerLabels() {
        playerLabels[gameModel.currentPlayer].alpha = 1.0
        playerLabels[1-gameModel.currentPlayer].alpha = 0.5
        scoreLabels[0].text = "\(gameModel.scores[0])"
        scoreLabels[1].text = "\(gameModel.scores[1])"
    }

    func disableColorButton() {
        for button in colorButtons {
            button.isEnabled = false
        }
    }
    // Animate sequence of colors.
    // This function will use event queue to show all colors in sequence
    func animateSequence(_ index: Int, completed: @escaping () -> Void) {
        if index < gameModel.colorSequence.count {
            colorButtons[gameModel.colorSequence[index]].flash() {(bool) in
                self.animateSequence(index + 1, completed:completed)
            }
        } else {
            completed()
        }
    }

    // Color button was tapped
    @IBAction func colorButtonTapped(_ sender: CircleButton) {
        if sender.tag == colorsToTap.removeFirst() {
            if colorsToTap.isEmpty {
                successState()
            }
        } else {
            failedState()
        }
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        memorizeState()
    }
}

