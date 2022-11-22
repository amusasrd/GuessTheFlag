//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by A Moses on 19/11/22.
//

import SwiftUI

struct ContentView: View
{
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var gameFinished = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var qCount = 0
    
    var body: some View
    {
        ZStack
        {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack
            {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15)
                {
                    VStack
                    {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                                Image(countries[number])
                                    .renderingMode(.original)
                                    .clipShape(Capsule())
                                    .shadow(radius: 05)
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
            
            .alert(scoreTitle, isPresented: $showingScore)
            {
                Button("Continue", action: askQuestion)
            } message:
            {
                Text("Your score is \(totalScore)")
            }
            
            .alert("Game Finished. \(scoreTitle)", isPresented: $gameFinished)
            {
//                Button("Exit", action: askQuestion)
                Button("Restart", action: restartGame)
            } message:
            {
                Text("Your score is \(totalScore)")
            }
        }
    }
    
    func flagTapped(_ number: Int)
    {
        qCount += 1
        
        if qCount == 8
        {
            switch totalScore
            {
            case 8:
                scoreTitle = "Perfect score! How many google searches did it take?"
            case 0:
                scoreTitle = "That's an...unfortunate score."
            case 1...4:
                scoreTitle = "Not bad. My dog can do better though."
            default:
                scoreTitle = "You should've paid more attention in geography."
            }
            
            gameFinished = true
        }
        else
        {
            if number == correctAnswer
            {
                scoreTitle = "Correct"
                totalScore += 1
            }
            else
            {
                scoreTitle = "That's \(countries[number])'s flag!"
                totalScore -= 1
            }
            
            showingScore = true
        }
    }
    
    func askQuestion()
    {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func restartGame()
    {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        totalScore = 0
        qCount = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
