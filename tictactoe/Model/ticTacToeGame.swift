import Foundation

enum Player {
    case computer, human
}

struct gameModel {
    private(set) var positions: [moves?] = Array(repeating: nil, count: 9)
    private(set) var score: Int = 0
    
    private let possibleWinCond: Set<Set<Int>> = [[0, 1, 2], [0, 3, 6], [0, 4, 8], [1, 4, 7], [2, 5, 8], [2, 4, 6], [3, 4, 5], [6, 7, 8]]
    
    private(set) var easyRounds = Int.random(in: 2..<4)
    private(set) var mediumRounds = Int.random(in: 4..<6)
    
    func isOccupied(position: Int) -> Bool {
        return positions.contains(where: { $0?.boardIndex == position })
    }
    
    // Draw X on board for human
    // If returns true, then human won
    mutating func humanChoose(index: Int) -> Bool {
        positions[index] = moves(player: .human, boardIndex: index)
        let winner = positions.compactMap { $0 }.filter { $0.player == .human }
        let winnerPositions = Set(winner.map { $0.boardIndex })
        for winCond in possibleWinCond where winCond.isSubset(of: winnerPositions) {
            score += 1
            return true
        }
        return false
    }
    
    func blockHuman() -> Int? {
        let humanTurns = positions.compactMap { $0 }.filter { $0.player == .human }
        
        let humanPositions = Set(humanTurns.map { $0.boardIndex })
        for winCond in possibleWinCond {
            let possibleWinPos = winCond.subtracting(humanPositions)
            if possibleWinPos.count == 1 {
                let posAvailable = !isOccupied(position: possibleWinPos.first!)
                if posAvailable { return possibleWinPos.first! }
            }
        }
        return nil
    }
    
    // determine position of computer
    // level of difficulty will be based on score
    // easy rounds will be from scores of 0-2 or 0-3
    // medium rounds from 3-4, or 4-5, from there on it will be hard mode
    func computeComputerPosition() -> Int {
        if let easyModePosition = calculateEasyModePositions() {
            return easyModePosition
        }
        
        if let mediumModePosition = calculateMediumModePositions() {
            return mediumModePosition
        }
        
        // Hard mode initiated from here
        let possibleWinCond: Set<Set<Int>> = [[0, 1, 2], [0, 3, 6], [0, 4, 8], [1, 4, 7], [2, 5, 8], [2, 4, 6], [3, 4, 5], [6, 7, 8]]
        
        let computerTurns = positions.compactMap { $0 }.filter { $0.player == .computer }
        
        let computerPositions = Set(computerTurns.map { $0.boardIndex })
        
        for winCond in possibleWinCond {
            let possibleWinPos = winCond.subtracting(computerPositions)
            if possibleWinPos.count == 1 {
                let posAvailable = !isOccupied(position: possibleWinPos.first!)
                if posAvailable { return possibleWinPos.first! }
            }
        }
        
        if let possibleBlock = blockHuman() {
            return possibleBlock
        }
        
        let middlePos = 4
        if !isOccupied(position: middlePos) { return middlePos }
        
        var possiblePosition = Int.random(in: 0..<9)
        while isOccupied(position: possiblePosition) {
            possiblePosition = Int.random(in: 0..<9)
        }
        return possiblePosition
    }
    
    // easy rounds will just be random placement, no blocking or trying to win
    func calculateEasyModePositions() -> Int? {
        if score > easyRounds { return nil }
        var possiblePosition = Int.random(in: 0..<9)
        while isOccupied(position: possiblePosition) {
            possiblePosition = Int.random(in: 0..<9)
        }
        return possiblePosition
    }
    
    // medium rounds will consist of blocking and taking the middle position first if available
    func calculateMediumModePositions() -> Int? {
        if score > mediumRounds { return nil }
        if let possibleBlock = blockHuman() {
            return possibleBlock
        }
        
        let middlePos = 4
        if !isOccupied(position: middlePos) { return middlePos }
        
        var possiblePosition = Int.random(in: 0..<9)
        while isOccupied(position: possiblePosition) {
            possiblePosition = Int.random(in: 0..<9)
        }
        return possiblePosition
    }
    
    // Draw O for computer position
    // If returns true, then computer won and score will reset
    // Once player loses, change up the difficulty settings
    mutating func computerTurn(index: Int) -> Bool {
        positions[index] = moves(player: .computer, boardIndex: index)
        let winner = positions.compactMap { $0 }.filter { $0.player == .computer }
        let winnerPositions = Set(winner.map { $0.boardIndex })
        for winCond in possibleWinCond where winCond.isSubset(of: winnerPositions) {
            score = 0
            easyRounds = Int.random(in: 2..<4)
            mediumRounds = Int.random(in: 4..<6)
            return true
        }
        return false
    }
    
    mutating func restart() {
        positions = Array(repeating: nil, count: 9)

    }
    
    func isDraw() -> Bool {
        let drawCond = positions.compactMap { $0 }
        return drawCond.count == 9 ? true : false
    }
    
    struct moves: Identifiable {
        var id = UUID()
        var player: Player
        var boardIndex: Int
        var indicate: String {
            return player == .human ? "xmark" : "circle"
        }
    }
}
