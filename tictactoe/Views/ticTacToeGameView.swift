import SwiftUI

struct ticTacToeGame: View {
    @ObservedObject var game: gameViewModel

    var body: some View {
        VStack {
            HStack {
                Text("Score: \(game.score)")
                    .font(.title2)
                Spacer()
            }
            gameBody
            Spacer()
            Spacer()
        }.disabled(game.isScreenDisabled)
            .padding()
            .alert(item: $game.alert, content: { alert in
                Alert(title: alert.header, message: alert.bodyMsg, dismissButton: .default(alert.buttonMsg, action: { game.restart()
                }))
            })
    }

    // game board
    var gameBody: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: game.columns) {
                    ForEach(0 ..< 9) { i in
                        ZStack {
                            circleView(size: geometry.size)
                            Image(systemName: game.positions(in:i)?.indicate ?? "")
                        }.onTapGesture {
                            game.choose(index: i)
                        }
                    }
                }
                Spacer()
            }
        }
    }
}

struct circleView: View {
    var size: CGSize
    var body: some View {
        Circle().foregroundColor(.blue)
            .opacity(0.7)
            .frame(width: size.width/4, height: size.width/4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = gameViewModel()
        ticTacToeGame(game: game)
    }
}
