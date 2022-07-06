import SwiftUI

@main
struct tictactoeApp: App {
    
    private let game = gameViewModel()
    var body: some Scene {
        WindowGroup {
            ticTacToeGame(game: game)
        }
    }
}
