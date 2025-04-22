//
//  SleepTimerView.swift
//  Rewind Room
//
//  Created by John Taylor on 4/21/25.
//

import SwiftUI

struct SleepTimerView: View {
    @ObservedObject var viewModel: AudioPlayerViewModel
    @Binding var isPresented: Bool
    
    let timerOptions = [0.5, 1, 5, 10, 15, 30, 45, 60]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.sleepTimerActive {
                    // Active timer display
                    VStack(spacing: 15) {
                        Text("Sleep timer active")
                            .font(.headline)
                        
                        Text(viewModel.formattedRemainingTime())
                            .font(.system(size: 48, weight: .medium, design: .monospaced))
                            .foregroundColor(.blue)
                        
                        Button(action: {
                            viewModel.cancelSleepTimer()
                        }) {
                            Text("Cancel Timer")
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                } else {
                    // Timer selection
                    Text("Stop playing music after:")
                        .font(.headline)
                        .padding(.top)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                        ForEach(timerOptions, id: \.self) { minutes in
                            Button(action: {
                                viewModel.startSleepTimer(minutes: Double(minutes))
                            }) {
                                VStack {
                                    Text("\(minutes)")
                                        .font(.title2)
                                        .bold()
                                    Text("min")
                                        .font(.caption)
                                }
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.blue)
                                .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                    
                    Text("The app will automatically stop playback after the selected time.")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
            .navigationBarTitle("Sleep Timer", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
}
