//
//  SoundEffectSliderView.swift
//  Rewind Room
//
//  Created by John Taylor on 4/18/25.
//

import SwiftUI


struct SoundEffectSliderView: View {
    @ObservedObject var viewModel: AudioPlayerViewModel
    
    let symbol: String
    let label: String
    
    var body: some View {
        HStack {
            Button {
                if viewModel.isPlaying {
                    viewModel.pause()
                } else {
                    viewModel.play()
                }
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
            }
            .padding()

            Text(label)
                .frame(width: 60, alignment: .leading)
            
            Slider(value: $viewModel.songVolumeLevel, in: 0...1) { isMoving in
                
                viewModel.setVolumeLevel(volume: viewModel.songVolumeLevel)
            }
            .scaleEffect(x: 0.8, y: 0.8)
            
            Button {
                viewModel.restart()
            } label: {
                Image(systemName: symbol)
            }
            .frame(width: 20, alignment: .leading)
            .padding()
        }
    }
}
