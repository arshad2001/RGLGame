import SwiftUI

struct ContentView : View {
    @State private var showWinMessage = false
    
    var body: some View {
        ZStack {
            ARViewContainer(showWinMessage: $showWinMessage).edgesIgnoringSafeArea(.all)
            if showWinMessage {
                Text("You Win!")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
