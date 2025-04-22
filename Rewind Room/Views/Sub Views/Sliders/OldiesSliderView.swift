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
        HStack(spacing: 12) {
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

            // Track label with small icon
            HStack() {
                Image(systemName: "music.note")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("Oldies")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(width: 70, alignment: .leading)

            // Volume Slider with custom style
            SliderView(value: $viewModel.songVolumeLevel, range: 0...1) { _ in
                viewModel.setVolumeLevel(volume: viewModel.songVolumeLevel)
            }
            .padding(.top, 12)

            // Skip Button
            Button {
                if viewModel.isPlaying {
                    viewModel.pause()
                }

                isSpinning = false

                currItem = Int.random(in: 0..<viewModel.songsArray.count)
                viewModel.setCurrentSong(song: viewModel.songsArray[currItem])
                viewModel.setVolumeLevel(volume: viewModel.songVolumeLevel)
                
                if viewModel.songVolumeLevel > 0 {
                    viewModel.play()
                    isSpinning = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        isSpinning = true
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "forward.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
    }
}

// Custom slider for more visual appeal
struct SliderView: View {
    @Binding var value: Float
    let range: ClosedRange<Float>
    let onEditingChanged: (Bool) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 8)
                
                // Fill
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: CGFloat(value / (range.upperBound - range.lowerBound)) * geometry.size.width, height: 8)
                
                // Thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
                    .offset(x: CGFloat(value / (range.upperBound - range.lowerBound)) * geometry.size.width - 8)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let newValue = Float(gesture.location.x / geometry.size.width) * (range.upperBound - range.lowerBound) + range.lowerBound
                                self.value = min(max(newValue, range.lowerBound), range.upperBound)
                                onEditingChanged(true)
                            }
                            .onEnded { _ in
                                onEditingChanged(false)
                            }
                    )
            }
        }
        .frame(height: 30)
    }
}
