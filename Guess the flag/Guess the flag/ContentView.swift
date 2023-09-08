//
//  ContentView.swift
//  Guess the flag
//
//  Created by Анна Перехрест  on 2023/09/08.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var showingScore = false
    @State private var alertTitle = ""
    
    @State var userScore = 0
    @State var points = 0
    @State var chosenCountry = ""
    @State var rounds = 0
    @State var alertMessage = ""
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy",  "Poland",  "UK"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
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
                    .foregroundColor(.white)
                    .font(.title.bold())
                
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
                                flagTapped(number)
                            } label: {
                                FlagImage(number)
                            }
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
            }
            
            
        }
        .alert(alertTitle, isPresented: $showingScore) {
            Button("Continue", action: {})
        } message: {
            Text(alertMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        rounds += 1
        if rounds <= 5 {
            if number == correctAnswer {
                userScore += 10
                
                alertTitle = "Correct"
                alertMessage = "You get 10 points."
            } else {
                userScore -= 10
                
                alertTitle = "Wrong"
                alertMessage = "You get -10 points. That’s the flag of \(countries[number])"
            }
            askQuestion()
        } else {
            alertTitle = "Game over"
            alertMessage = "Your score is \(userScore)"
        }
        
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        userScore = 0
        rounds = 0
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
