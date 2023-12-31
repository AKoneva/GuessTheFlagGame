//
//  ContentView.swift
//  Guess the flag
//
//  Created by Анна Перехрест  on 2023/09/08.
//

import SwiftUI

struct ContentView: View {
    @State private var isGameFinished = false
    
    @State private var selectedButtonIndex = -1
    @State private var isAnimating = false
    @State private var animationAmount = 1.0
    @State private var showResult = false
    @State private var result = ""
    
    
    @State var userScore = 0
    @State var previousScore = 0
    @State var rounds = 0
    
    @State var chosenCountry = ""
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy",  "Poland",  "UK"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 300, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                Text("Score: \(userScore)")
                    .font(.title.bold())
                    .foregroundColor(userScore > previousScore ? Color.green : (userScore < previousScore ? Color.red : Color.white))
                    .font(.title.bold())
                    .animation(.linear, value: userScore)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    VStack {
                        ForEach(0..<3) { number in
                            Button {
                                selectedButtonIndex = number
                                animationAmount -= 0.5
                                flagTapped(number)
                            } label: {
                                FlagImage(number)
                                    .rotation3DEffect(.degrees(selectedButtonIndex == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                    .animation(.easeOut, value: selectedButtonIndex)
                                    .scaleEffect(selectedButtonIndex == number ? 1 : animationAmount)
                                    .animation(.easeOut.repeatCount(1, autoreverses: false), value: animationAmount)
                                    .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                            }
                            .disabled(isAnimating)
                        }
                    }
                }
                .padding(40)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Button("Reset", role: .destructive) {
                    resetGame()
                }
                .buttonStyle(.borderedProminent)
            }.blur(radius: showResult ? 20 : 0)
            
                           Text(result)
                               .font(.system(size: 70))
                               .fontWeight(.bold)
                               .foregroundColor(result == "WRONG" ? .red : .green)
                               .transition(.move(edge: .bottom))
                               .opacity(showResult ? 1 : 0)
        }
        .alert("Game Over", isPresented: $isGameFinished) {
            Button("Restart") {
                resetGame()
            }
        } message: {
            Text("Your score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        rounds += 1
        if rounds <= 5 {
            isAnimating = true
                if number == correctAnswer {
                    previousScore = userScore
                    userScore += 10
                    result = "CORRECT"
                    
                } else {
                    previousScore = userScore
                    userScore -= 10
                    result = "WRONG"
                }
            showResult = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAnimating = false
                showResult = false
                askQuestion()
            }
        } else {
            isGameFinished.toggle()
        }
    }
    
    func askQuestion() {
        showResult = false
        
        selectedButtonIndex = 3
        animationAmount = 1.0
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        animationAmount = 1.0
        
        isGameFinished.toggle()
        
        userScore = 0
        previousScore = 0
        rounds = 0
        
        askQuestion()
    }
    
    func FlagImage(_ number: Int) -> some View {
        return Image(countries[number])
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
