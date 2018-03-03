//
//  GameState.swift
//  Simon Says
//
//  Created by Krzysztof Langner on 03/03/2018.
//  Copyright © 2018 Krzysztof Langner. All rights reserved.
//

import Foundation

struct Game {
    
    // Number of colors to guess
    static let COLOR_COUNT = 4
    
    let currentPlayer: Int
    let scores: [Int]
    let colorSequence: [Int]
    
    // Default constructor for creating new game state
    init() {
        currentPlayer = 0
        scores = [0, 0]
        colorSequence = [Game.randomColor()]
    }
    
    // Constructor for updating game state
    private init(currentPlayer: Int, scores: [Int], colorSequence: [Int]) {
        self.currentPlayer = currentPlayer
        self.scores = scores
        self.colorSequence = colorSequence
    }
    
    private static func randomColor() -> Int {
        return Int(arc4random_uniform(UInt32(COLOR_COUNT)))
    }
    
    // When we go to the next level we need to:
    // * Add color to the sequence
    // * Add point to the current player score
    // * Switch players
    func nextLevel() -> Game {
        let colorIndex = Game.randomColor()
        let newScores = currentPlayer == 0 ? [scores[0]+1, scores[1]] : [scores[0], scores[1]+1]
        let xs = colorSequence + [colorIndex]
        return Game(
            currentPlayer: 1 - currentPlayer,
            scores: newScores,
            colorSequence: xs)
    }
    
    // Reset level so we can start another round
    func resetLevel() -> Game {
        return Game(
            currentPlayer: 1-currentPlayer,
            scores: scores,
            colorSequence: [Game.randomColor()])
    }
}
