//
//  SoundEffectDetailView.swift
//  Rewind Room
//
//  Created by John Taylor on 5/16/25.
//

import SwiftUI

struct SoundEffectDetailView: View {
    @ObservedObject var soundEffectViewModel: AudioPlayerViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        let currentSoundEffect = soundEffectViewModel.getSoundEffect()
        
        ScrollView {
            VStack(spacing: 20) {
                // Current Sound Effect Card
                VStack(spacing: 12) {
                    Image(systemName: currentSoundEffect.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text(currentSoundEffect.label)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(currentSoundEffect.soundType)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // Preview Player
                    HStack(spacing: 16) {
                        Button {
                            if soundEffectViewModel.isPlaying {
                                soundEffectViewModel.pause()
                            } else {
                                soundEffectViewModel.play()
                            }
                        } label: {
                            Image(systemName: soundEffectViewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(.blue)
                        }
                        
                        // Volume Slider
                        SliderView(value: $soundEffectViewModel.songVolumeLevel, range: 0...1) { _ in
                            soundEffectViewModel.setVolumeLevel(volume: soundEffectViewModel.songVolumeLevel)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                
                // Available Sound Effects
                VStack(alignment: .leading, spacing: 16) {
                    Text("Available Sound Effects")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // Show all sound effects except current one
                    ForEach(soundEffectViewModel.soundEffectArray.filter { $0.id != currentSoundEffect.id }, id: \.id) { soundEffect in
                        Button {
                            // Stop current playback
                            if soundEffectViewModel.isPlaying {
                                soundEffectViewModel.pause()
                            }
                            // Set new sound effect
                            soundEffectViewModel.setSoundEffect(soundEffectId: soundEffect.id)
                            // Restore volume
                            soundEffectViewModel.setVolumeLevel(volume: soundEffectViewModel.songVolumeLevel)
                            // Play if volume > 0
                            if soundEffectViewModel.songVolumeLevel > 0 {
                                soundEffectViewModel.play()
                            }
                        } label: {
                            HStack {
                                Image(systemName: soundEffect.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading) {
                                    Text(soundEffect.label)
                                        .font(.system(size: 16, weight: .medium))
                                    
                                    Text(soundEffect.soundType)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    if soundEffect.isPremiumSound {
                                        Text("Premium")
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Change Sound Effect")
        .task {
            await soundEffectViewModel.fetchSoundEffects()
        }
    }
}
