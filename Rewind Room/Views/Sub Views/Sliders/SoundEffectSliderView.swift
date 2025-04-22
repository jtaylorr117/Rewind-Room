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
        HStack(spacing: 12) {
            // Play/Pause Button
            Button {
                if viewModel.isPlaying {
                    viewModel.pause()
                } else {
                    viewModel.play()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(viewModel.isPlaying ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Track label with appropriate icon
            HStack() {
                Image(systemName: getIconForLabel(label))
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 70, alignment: .leading)
            
            // Volume Slider with custom style
            SliderView(value: $viewModel.songVolumeLevel, range: 0...1) { _ in
                viewModel.setVolumeLevel(volume: viewModel.songVolumeLevel)
                
                // Auto-play when volume is increased from zero
                if viewModel.songVolumeLevel > 0 && !viewModel.isPlaying {
                    viewModel.play()
                }
                
                // Auto-pause when volume is set to zero
                if viewModel.songVolumeLevel == 0 && viewModel.isPlaying {
                    viewModel.pause()
                }
            }
            .padding(.top, 12)

            // Restart Button
            Button {
                if viewModel.songVolumeLevel > 0 {
                    viewModel.restart()
                    if !viewModel.isPlaying {
                        viewModel.play()
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: symbol)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(viewModel.songVolumeLevel == 0)
            .opacity(viewModel.songVolumeLevel > 0 ? 1.0 : 0.5)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
    
    // Helper function to get appropriate icon for each sound type
    private func getIconForLabel(_ label: String) -> String {
        switch label {
        case "Rain":
            return "cloud.rain"
        case "Static":
            return "radio"
        case "Fire":
            return "flame"
        default:
            return "speaker.wave.2"
        }
    }
}
