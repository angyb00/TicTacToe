import Foundation
import SwiftUI


class gameViewModel: ObservableObject {
    
    private(set) var column: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published private(set) var model = gameModel()
    var isScreenDisabled = false
    var alert: alert?
    
    typealias moves = gameModel.moves
 
    var columns:[GridItem] {
        return self.column
    }
   
    var score: Int {
        return model.score
    }
    
    
    //Intent functions
    func positions(in index: Int) -> moves? {
        return model.positions[index]
    }
    
    func choose(index: Int) {
        
        if humanTurn(index:index) {
            alert = alertPopUp.humanWinner
            return
        }
        if self.isDraw() {
            alert = alertPopUp.draw
            return
        }
        self.isScreenDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.computerTurn() {
                self.alert = alertPopUp.computerWinner
                self.isScreenDisabled = false
                return
            }
            
            if self.isDraw() {
                self.alert = alertPopUp.draw
                return
            }
            self.isScreenDisabled = false
    }
}
    //will calculate computer position and return true if computer wins
    func computerTurn() -> Bool {
        let computerPosition = computeComputerPosition()
        return model.computerTurn(index: computerPosition)
    }
    
    //func blockHuman() -> Int? { model.blockHuman() }
    
    func isDraw() -> Bool { model.isDraw() }
    
    func restart(){ model.restart() }
    
    //func isOccupied(index: Int) -> Bool { model.isOccupied(position: index) }
    
    func humanTurn(index:Int) -> Bool{ model.humanChoose(index: index) }
    
    func computeComputerPosition() -> Int { model.computeComputerPosition() }
    
    }


