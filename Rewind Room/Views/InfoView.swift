//
//  InfoView.swift
//  Rewind Room
//
//  Created by John Taylor on 4/22/25.
//

import SwiftUI

struct InfoView: View {
    @ObservedObject var viewModel: AudioPlayerViewModel
    @Binding var isPresented: Bool
    @Binding var currItem: Int
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("About Rewind Room")
                        .font(.title)
                        .bold()
                    
                    Text("Rewind Room is a unique audio experience that combines classic oldies music with ambient soundscapes to create the perfect nostalgic atmosphere.")
                    
                    Text("Inspired by \"i miss my cafe\"  and \"oldies playing in another room and its raining\" ")
                    
                    Text("How to Use:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("• Tap play/pause to control each sound individually")
                        Text("• Use the sliders to adjust volume levels")
                        //Text("• Try the preset buttons for quick atmosphere changes")
                        Text("• Tap on the sound to get more info and change settings")
                        Text("• Tap on the top left to activate the sleep timer for those long nights")
                    }
                    
                    if !viewModel.songsArray.isEmpty {
                        Text("Current Song:")
                            .font(.headline)
                        
                        VStack(alignment: .leading) {
                            Text("\(viewModel.songsArray[currItem].title)")
                                .bold()
                            
                            if let date = viewModel.songsArray[currItem].date {
                                Text("Released: \(date)")
                            }
                            
                            if let isPublicDomain = viewModel.songsArray[currItem].public_domain, isPublicDomain {
                                Text("Public Domain Music")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitle("Info", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                isPresented = false
            })
        }
    }
}

