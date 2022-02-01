//
//  ContentView.swift
//  EdutainmentMultiplication
//
//  Created by Joey Graham on 12/30/21.
//

import SwiftUI

struct RoundButton: View {
    
    var name = ""
    var primaryColor = Color.blue
    var secondaryColor = Color.white
    var body: some View {
        Text("\(name)")
        .padding(20)
        .font(.headline)
            .frame(minWidth: 100, idealWidth: 200, maxWidth: 300, minHeight: 50, idealHeight: 50, maxHeight: 50, alignment: .center)
            .foregroundColor(primaryColor)
            .background(secondaryColor)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(primaryColor, lineWidth: 4))
    }
}

struct ContentView: View {
    @State private var inGameMode = false
    @State private var numberOfQuestions = 5
    @State private var numberInput = ""
    @State private var multiples = 2
    @State private var gameOver = false
    @State private var randomNumber = Int.random(in: 1...12)
    @State private var userAnswer = ""
    @State private var totalScore = 0
    @State private var totalQuestions = 1
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var disabled = false
    @State private var isCorrect = false
    @State private var buttonSpinAmount = 0.0
    @State private var opacity = 1.0
    @State private var buttonChange: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                if !inGameMode {
                    ZStack {
                        Form {
                            Section {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("How many questions would you like?")
                                        .font(.headline)
                                    
                                    Stepper("\(numberOfQuestions) Questions", value: $numberOfQuestions, in: 5...20, step: 5)
                                }
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Choose your Multiples:")
                                        .font(.headline)
                                    
                                    Stepper("\(multiples)s", value: $multiples, in: 2...10, step: 1)
                                }
                            }
                        }
                    }
                }
                if inGameMode {
                    Group {
                        HStack {
                            RoundButton(name: "\(multiples)")
                            .padding()
                            Spacer()
                            Text("X")
                            Spacer()
                            RoundButton(name: "\(randomNumber)")
                            .padding()
                        }
                    }
                    VStack {
                        TextField("Answer", text: $userAnswer)
                            .padding()
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                        Button(action:  {
                            checkAnswer()
                            if isCorrect == true  {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    self.colorChange()
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                                    continueGame()
                                }
                            }
                            else {
                                
                            }
                        }) {
                            Text("Check")
                                .frame(width: 200, height: 50, alignment: .center)
                                .background(buttonChange ? Color.green : Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .rotation3DEffect(.degrees(self.buttonSpinAmount), axis: (x: 0, y : isCorrect ? 1 : 0, z: 0))

                        Text("Score: \(totalScore)")
                            .font(.title)
                        Text("Question: \(totalQuestions)/\(numberOfQuestions)")
                    }
                    Spacer()
                }
            }
            .navigationTitle("Multiplication")
            .toolbar {
                Button(inGameMode ? "Settings" : "Play") {
                    withAnimation {
                        inGameMode.toggle()
                        resetGame()
                    }
                }
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: continueGame)
        } message: {
            Text("Your score is \(totalScore)")
        }
        .alert(isPresented: $gameOver) {
                    Alert(title: Text("Game over!"), message: Text("Your final score was \(totalScore)/\(numberOfQuestions)"), dismissButton: .default(Text("Play again")) {
                        resetGame()
                        inGameMode.toggle()
                    })
        }
    }
    
    func colorChange() {
        //toggle makes check button green
        self.buttonChange.toggle()
        
        // wait for 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            withAnimation(.easeIn) {
                self.buttonChange.toggle()
            }
        })
    }
    
    func continueGame() {
        if totalQuestions == numberOfQuestions + 1 {
            gameOver = true
        }
        else {
            randomNumber = Int.random(in: 1...12)
        }
    }
    func checkAnswer() {
        let correctAnswer = Int(userAnswer) ?? 0
        if multiples * randomNumber == correctAnswer {
            isCorrect = true
            totalScore += 1
            totalQuestions += 1
            userAnswer = ""
        }
        else {
        isCorrect = false
        scoreTitle = "Thats not it - the answer is \(multiples * randomNumber)"
        totalQuestions += 1
        showingScore = true
        userAnswer = ""
        }
    }
    func resetGame() {
        totalScore = 0
        totalQuestions = 1
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
