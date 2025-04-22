//
//  ContentView.swift
//  Rewind Room
//
//  Created by John Taylor on 4/14/25.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    @StateObject var oldiesMusicViewModel = AudioPlayerViewModel()
    @StateObject var rainSoundsViewModel = AudioPlayerViewModel()
    @StateObject var staticSoundsViewModel = AudioPlayerViewModel()
    @StateObject var fireSoundsViewModel = AudioPlayerViewModel()
    
    
    @State private var recordIsSpinning = false
    @State private var showingInfo = false
    @State private var showingSleepTimer = false
    
    @State var currItem: Int = 0
    
    
    
    //Preset states
    @State var cozyEveningPreset = false
    @State var rainyNight = false
    @State var vintageRadio = false
    @State var quietNight = false
    
    var body: some View {
        NavigationStack{
            ZStack{
            
                VStack{
                    
                    VStack{
                        if !oldiesMusicViewModel.songsArray.isEmpty{
                            ZStack{
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 280, height: 280)
                                    .shadow(color: .black.opacity(0.5), radius: 10)
                                
                                
                                AsyncImage(url: URL(string: oldiesMusicViewModel.songsArray[currItem].art_url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 250, height: 250)
                                .clipShape(Circle())
                                .rotationEffect(Angle.degrees(recordIsSpinning ? 360 : 0))
                                .animation(recordIsSpinning
                                           ? Animation.linear(duration: 4.0).repeatForever(autoreverses: false)
                                           : .default,
                                           value: recordIsSpinning
                                )
                                
                            }
                                // Song info
                            VStack(spacing: 5) {
                                Text(oldiesMusicViewModel.songsArray[currItem].title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                if let date = oldiesMusicViewModel.songsArray[currItem].date {
                                    Text(date)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 10)
                            
                        }else {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                        }
                    }
                    //box of sound effects
                    VStack(spacing: 12) {
                        OldiesSliderView(
                            viewModel: oldiesMusicViewModel,
                            isSpinning: $recordIsSpinning,
                            currItem: $currItem
                        )
                        .background(oldiesMusicViewModel.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                        
                        SoundEffectSliderView(
                            viewModel: rainSoundsViewModel,
                            symbol: "arrow.clockwise",
                            label: "Rain"
                        )
                        .background(rainSoundsViewModel.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                        
                        SoundEffectSliderView(
                            viewModel: staticSoundsViewModel,
                            symbol: "arrow.clockwise",
                            label: "Static"
                        )
                        .background(staticSoundsViewModel.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                        
                        SoundEffectSliderView(
                            viewModel: fireSoundsViewModel,
                            symbol: "arrow.clockwise",
                            label: "Fire"
                        )
                        .background(fireSoundsViewModel.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                        
                        
                        
                        // Preset buttons
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                presetButton("Cozy Evening", action: {
                                    
                                    cozyEveningPreset.toggle()
                                    
                                    rainyNight = false
                                    vintageRadio = false
                                    quietNight = false
                                    
                                    if(cozyEveningPreset){
                                        activatePreset(
                                            oldiesVolume: 0.3,
                                            rainVolume: 0.2,
                                            staticVolume: 0.0,
                                            fireVolume: 0.8
                                        )
                                    }else{
                                        activatePreset(
                                            oldiesVolume: 0.0,
                                            rainVolume: 0.0,
                                            staticVolume: 0.0,
                                            fireVolume: 0.0
                                        )
                                    }
                                })
                                .background(cozyEveningPreset ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                                .cornerRadius(20)
                                
                                
                                presetButton("Rainy Night", action: {
                                    rainyNight.toggle()
                                    
                                    cozyEveningPreset = false
                                    vintageRadio = false
                                    quietNight = false
                                    
                                    if(rainyNight){
                                        activatePreset(
                                            oldiesVolume: 0.4,
                                            rainVolume: 0.7,
                                            staticVolume: 0.1,
                                            fireVolume: 0.0
                                        )
                                    }else{
                                        activatePreset(
                                            oldiesVolume: 0.0,
                                            rainVolume: 0.0,
                                            staticVolume: 0.0,
                                            fireVolume: 0.0
                                        )
                                    }
                                })
                                .background(rainyNight ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                                .cornerRadius(20)
                                
                                presetButton("Vintage Radio", action: {
                                    vintageRadio.toggle()
                                    
                                    cozyEveningPreset = false
                                    rainyNight = false
                                    quietNight = false
                                    
                                    if(vintageRadio){
                                        activatePreset(
                                            oldiesVolume: 0.6,
                                            rainVolume: 0.0,
                                            staticVolume: 0.4,
                                            fireVolume: 0.0
                                        )
                                    }else{
                                        activatePreset(
                                            oldiesVolume: 0.0,
                                            rainVolume: 0.0,
                                            staticVolume: 0.0,
                                            fireVolume: 0.0
                                        )
                                    }
                                })
                                .background(vintageRadio ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                                .cornerRadius(20)
                                
                                presetButton("Quiet Night", action: {
                                    quietNight.toggle()
                                    
                                    cozyEveningPreset = false
                                    rainyNight = false
                                    vintageRadio = false
                                    
                                    if(quietNight){
                                        activatePreset(
                                            oldiesVolume: 0.2,
                                            rainVolume: 0.3,
                                            staticVolume: 0.0,
                                            fireVolume: 0.4
                                        )
                                    }else{
                                        activatePreset(
                                            oldiesVolume: 0.0,
                                            rainVolume: 0.0,
                                            staticVolume: 0.0,
                                            fireVolume: 0.0
                                        )
                                    }
                                })
                                .background(quietNight ? Color.blue.opacity(0.3) : Color.gray.opacity(0.3))
                                .cornerRadius(20)
                            }
                            .padding(.horizontal)
                        }
                        }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(15)
                    
                    Spacer()
                }
                .padding()
                
            }
            .navigationTitle("Rewind Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingInfo.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                    }
                }
                
                //Sleep Timer
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingSleepTimer.toggle()
                    }) {
                        ZStack {
                            Image(systemName: "clock")
                                .foregroundColor(oldiesMusicViewModel.sleepTimerActive ? .blue : .white)
                            
                            if oldiesMusicViewModel.sleepTimerActive {
                                // Show small indicator dot when timer is active
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 7, y: -7)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingInfo) {
                infoView()
            }
            .sheet(isPresented: $showingSleepTimer) {
                SleepTimerView(viewModel: oldiesMusicViewModel, isPresented: $showingSleepTimer)
            }
            .task {
                await oldiesMusicViewModel.fetchSongs()
                oldiesMusicViewModel.setCurrentSong(song: oldiesMusicViewModel.songsArray[currItem])
                oldiesMusicViewModel.setVolumeLevel(volume: 0.5)
                
                await rainSoundsViewModel.fetchSoundEffects()
                rainSoundsViewModel.setSoundEffect(soundEffectId: 1)
                rainSoundsViewModel.setVolumeLevel(volume: 0.5)
                
                await staticSoundsViewModel.fetchSoundEffects()
                staticSoundsViewModel.setSoundEffect(soundEffectId: 2) // Static
                staticSoundsViewModel.setVolumeLevel(volume: 0.5)
                
                await fireSoundsViewModel.fetchSoundEffects()
                fireSoundsViewModel.setSoundEffect(soundEffectId: 3) // Fire
                fireSoundsViewModel.setVolumeLevel(volume: 0.5)
            }
        }
    }
    
    private func presetButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .foregroundColor(.white)
        }
    }
    
    // Helper function to activate presets
    private func activatePreset(oldiesVolume: Float, rainVolume: Float, staticVolume: Float, fireVolume: Float) {
        oldiesMusicViewModel.setVolumeLevel(volume: oldiesVolume)
        rainSoundsViewModel.setVolumeLevel(volume: rainVolume)
        staticSoundsViewModel.setVolumeLevel(volume: staticVolume)
        fireSoundsViewModel.setVolumeLevel(volume: fireVolume)
        
        if oldiesVolume > 0 && !oldiesMusicViewModel.isPlaying {
            oldiesMusicViewModel.play()
            recordIsSpinning = true
        } else if oldiesVolume == 0 && oldiesMusicViewModel.isPlaying {
            oldiesMusicViewModel.pause()
            recordIsSpinning = false
        }
        
        if rainVolume > 0 && !rainSoundsViewModel.isPlaying {
            rainSoundsViewModel.play()
        } else if rainVolume == 0 && rainSoundsViewModel.isPlaying {
            rainSoundsViewModel.pause()
        }
        
        if staticVolume > 0 && !staticSoundsViewModel.isPlaying {
            staticSoundsViewModel.play()
        } else if staticVolume == 0 && staticSoundsViewModel.isPlaying {
            staticSoundsViewModel.pause()
        }
        
        if fireVolume > 0 && !fireSoundsViewModel.isPlaying {
            fireSoundsViewModel.play()
        } else if fireVolume == 0 && fireSoundsViewModel.isPlaying {
            fireSoundsViewModel.pause()
        }
    }
    private func infoView() -> some View {
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
                        Text("• Tap the forward button on the music player to change songs")
                        Text("• Tap the restart button on ambient sounds to restart the loop, by default the sounds will auto-loop")
                    }
                    
                    if !oldiesMusicViewModel.songsArray.isEmpty {
                        Text("Current Song:")
                            .font(.headline)
                        
                        VStack(alignment: .leading) {
                            Text("\(oldiesMusicViewModel.songsArray[currItem].title)")
                                .bold()
                            
                            if let date = oldiesMusicViewModel.songsArray[currItem].date {
                                Text("Released: \(date)")
                            }
                            
                            if let isPublicDomain = oldiesMusicViewModel.songsArray[currItem].public_domain, isPublicDomain {
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
                showingInfo = false
            })
        }
    }
}


#Preview {
    ContentView()
}
