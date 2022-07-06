import SwiftUI

struct alert: Identifiable {
    var id = UUID()
    let header: Text
    let bodyMsg: Text
    let buttonMsg: Text
    
}

struct alertPopUp {
    static let humanWinner = alert(header: Text("You won!"), bodyMsg:Text("Nice Job!"), buttonMsg: Text("Ok"))
    static let computerWinner = alert(header: Text("You Lost"), bodyMsg: Text("Nice try!"), buttonMsg: Text("Ok"))
    static let draw = alert(header:Text("Draw!"), bodyMsg: Text("You drew!"), buttonMsg: Text("Ok"))
}
