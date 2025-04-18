//
//  OldiesSliderView.swift
//  Rewind Room
//
//  Created by John Taylor on 4/18/25.
//

import SwiftUI

struct OldiesSliderView: View {
    @ObservedObject var viewModel: AudioPlayerViewModel
    @Binding var isSpinning: Bool
    @Binding var currItem: Int
    

    var body: some View {
        HStack {
            // Play/Pause Button
            Button {
                if viewModel.isPlaying {
                    viewModel.pause()
                    isSpinning = false
                } else {
                    viewModel.play()
                    isSpinning = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        isSpinning = true
                    }
                }
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
            }
            .padding()

            Text("Oldies")
                .frame(width: 60, alignment: .leading)

            // Volume Slider
            Slider(value: $viewModel.songVolumeLevel, in: 0...100) { isMoving in
                viewModel.setVolumeLevel(volume: viewModel.songVolumeLevel)
            }

            // Skip Button
            Button {
                if viewModel.isPlaying {
                    viewModel.pause()
                }

                isSpinning = false

                currItem = Int.random(in: 0..<viewModel.songsArray.count-1)
                viewModel.setCurrentSong(song: viewModel.songsArray[currItem])

                if !viewModel.isPlaying {
                    viewModel.play()
                    isSpinning = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        isSpinning = true
                    }
                }
            } label: {
                Image(systemName: "forward.fill")
            }
            .frame(width: 20, alignment: .leading)
            .padding()
        }
    }
}



