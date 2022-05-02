import SwiftUI
import SpriteKit

struct ContentView: View {
    @State var showModaliIntro = true
    var body: some View {
        GeometryReader{geometry in
            VStack {
                SpriteView(scene: GameScene(size: geometry.size))
            }
            
        }
        .sheet(isPresented: $showModaliIntro){
            SheetViewIntro(isShowSheet: $showModaliIntro)
        }
    }
}

struct SheetViewIntro: View {
    @Binding var isShowSheet: Bool
    var body: some View {
        NavigationView {
            VStack{
                Text("Brother Dog")
                    .font(.largeTitle)
                    .bold()
                    .padding(20)
                    .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
                Image("MauiHead")
                    .resizable()
                    .frame(width: 160, height: 129)
                    .imageScale(.large)
                    .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
                ScrollView{
                    HStack{
                        Image(systemName: "pawprint")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .imageScale(.large)
                            .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
                        VStack(alignment: .leading){
                            Text("Hello, I am Maui!")
                                .font(.title)
                                .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
                                .bold()
                                .padding(5)
                            Text("Humans who have dogs like me know how much we enjoy their company. Beyond that, how much fun our days can be when we are playing with you. Yet, when there are children in the house it can be a bit challenging. But it is still a wonderful experience. Also, did you know that there are many benefits for children who grow up with dogs just like me?")
                                .font(.title2)
                                .padding(3)
                            Text("Here I will show you some of these benefits that pets can provide for a lifetime.")
                                .font(.title2)
                            
                        }.frame(width: 500).padding(10)
                    }
                    
                    NavigationLink(destination: SheetViewHowPlay(isShowSheet: self.$isShowSheet)) {
                        Text("Skip").padding(10)
                    }
                }
            }
        } .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SheetViewHowPlay: View {
    @Environment(\.presentationMode) var presentation
    @Binding var isShowSheet: Bool
    var body: some View {
        let buttonColor:Color = Color(#colorLiteral(red: 0.3012100756, green: 0.1583171785, blue: 0.01381174754, alpha: 1))
        VStack{
            Text("Brother Dog")
                .font(.largeTitle)
                .bold()
                .padding(20)
                .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
            ScrollView{
                HStack{
                    VStack(alignment: .leading){
                        Text("How to play")
                            .font(.title)
                            .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
                            .bold()
                            .padding(5)
                        Text("The scenario shows some interactions that can be performed, such as petting the dog.")
                            .padding(3)
                        HStack{
                            Image("MauiInicio")
                                .resizable()
                                .frame(width: 110, height: 148)
                                .imageScale(.large)
                                .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
                            Image("instruction")
                                .resizable()
                                .frame(width: 154, height: 106)
                                .imageScale(.large)
                                .foregroundColor(Color(#colorLiteral(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1)))
                        }
                        Text("After completing a task correctly, the lock will unlock and a specific benefit will be displayed. To read the message again just click on the star that will take the lock's place.")
                        HStack{
                            Image("CadeadoFechado")
                                .resizable()
                                .frame(width: 45, height: 60)
                                .imageScale(.large)
                                .padding(20)
                            Image("CadeadoAberto")
                                .resizable()
                                .frame(width: 45, height: 60)
                                .imageScale(.large)
                                .padding(20)
                            Image("Estrela")
                                .resizable()
                                .frame(width: 62, height: 60)
                                .imageScale(.large)
                                .padding(20)
                        }
                    }.frame(width: 500).padding(10)
                }
                Button("Play") {
                    self.isShowSheet = false
                }
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .background(buttonColor.opacity(5))
                .cornerRadius(20)
            }
        }
    }
}
