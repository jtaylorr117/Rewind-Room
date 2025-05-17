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
    @StateObject var sliderViewModel1 = AudioPlayerViewModel()
    @StateObject var sliderViewModel2 = AudioPlayerViewModel()
    @StateObject var sliderViewModel3 = AudioPlayerViewModel()
    
    
    
    
    
    @State private var showingInfo = false
    @State private var showingSleepTimer = false
    
    @State var currItem: Int = 0
    
    
    
    //Preset states
    @State var cozyEveningPreset = false
    @State var rainyNight = false
    @State var vintageRadio = false
    @State var quietNight = false
    
    
    //sleep timer options
    @State var timerOptions = [0.5, 1, 5, 10, 15, 20, 30, 60]
    
    
    var body: some View {
        NavigationStack{
            ZStack{
            
                VStack{
                    // Image
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
                                .rotationEffect(Angle.degrees(oldiesMusicViewModel.recordIsSpinning ? 360 : 0))
                                .animation(oldiesMusicViewModel.recordIsSpinning
                                           ? Animation.linear(duration: 4.0).repeatForever(autoreverses: false)
                                           : .default,
                                           value: oldiesMusicViewModel.recordIsSpinning
                                )
                                
                            }
                                // Song info
                            VStack(spacing: 5) {
                                Text(oldiesMusicViewModel.songsArray[currItem].title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
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
                    // Box of sound effects
                    VStack(spacing: 12) {
                        Button {
                            print("Button")
                        } label: {
                            OldiesSliderView(
                                viewModel: oldiesMusicViewModel,
                                isSpinning: $oldiesMusicViewModel.recordIsSpinning,
                                currItem: $currItem
                            )
                            .background(oldiesMusicViewModel.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                        }

                        
                        
                        NavigationLink{
                            SoundEffectDetailView(soundEffectViewModel: sliderViewModel1)
                        }label:{
                            SoundEffectSliderView(viewModel: sliderViewModel1)
                            .background(sliderViewModel1.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                        }
                        
                        NavigationLink{
                            SoundEffectDetailView(soundEffectViewModel: sliderViewModel2)
                        }label:{
                            SoundEffectSliderView(viewModel: sliderViewModel2)
                            .background(sliderViewModel2.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                        }
                        
                        NavigationLink{
                            SoundEffectDetailView(soundEffectViewModel: sliderViewModel3)
                        }label:{
                            SoundEffectSliderView(viewModel: sliderViewModel3)
                            .background(sliderViewModel3.isPlaying ? Color.accentColor.opacity(0.2) : Color.clear)
                            .cornerRadius(10)
                        }
                        
                        
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
                InfoView(viewModel: oldiesMusicViewModel, isPresented: $showingInfo, currItem: $currItem)
            }
            .sheet(isPresented: $showingSleepTimer) {
                sleepTimerView()
            }
            .task {
                await oldiesMusicViewModel.fetchSongs()
                if(oldiesMusicViewModel.getCurrentSong().title == ""){
                    currItem = Int.random(in: 0..<oldiesMusicViewModel.songsArray.count)
                    oldiesMusicViewModel.setCurrentSong(song: oldiesMusicViewModel.songsArray[currItem])
                    oldiesMusicViewModel.setVolumeLevel(volume: 0)
                }
                await sliderViewModel1.fetchSoundEffects()
                if(sliderViewModel1.getSoundEffect().fileName == ""){
                    sliderViewModel1.setSoundEffect(soundEffectId: 1)// Rain
                    sliderViewModel1.setVolumeLevel(volume: 0)
                }
                await sliderViewModel2.fetchSoundEffects()
                if(sliderViewModel2.getSoundEffect().fileName == ""){
                    sliderViewModel2.setSoundEffect(soundEffectId: 2) // Static
                    sliderViewModel2.setVolumeLevel(volume: 0)
                }
                await sliderViewModel3.fetchSoundEffects()
                if(sliderViewModel3.getSoundEffect().fileName == ""){
                    sliderViewModel3.setSoundEffect(soundEffectId: 3) // Fire
                    sliderViewModel3.setVolumeLevel(volume: 0)
                }
                
                
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
        sliderViewModel1.setVolumeLevel(volume: rainVolume)
        sliderViewModel2.setVolumeLevel(volume: staticVolume)
        sliderViewModel3.setVolumeLevel(volume: fireVolume)
        
        if oldiesVolume > 0 && !oldiesMusicViewModel.isPlaying {
            oldiesMusicViewModel.play()
            oldiesMusicViewModel.recordIsSpinning = true
        } else if oldiesVolume == 0 && oldiesMusicViewModel.isPlaying {
            oldiesMusicViewModel.pause()
            oldiesMusicViewModel.recordIsSpinning = false
        }
        
        if rainVolume > 0 && !sliderViewModel1.isPlaying {
            sliderViewModel1.play()
        } else if rainVolume == 0 && sliderViewModel1.isPlaying {
            sliderViewModel1.pause()
        }
        
        if staticVolume > 0 && !sliderViewModel2.isPlaying {
            sliderViewModel2.play()
        } else if staticVolume == 0 && sliderViewModel2.isPlaying {
            sliderViewModel2.pause()
        }
        
        if fireVolume > 0 && !sliderViewModel3.isPlaying {
            sliderViewModel3.play()
        } else if fireVolume == 0 && sliderViewModel3.isPlaying {
            sliderViewModel3.pause()
        }
    }
    
    private func sleepTimerView() -> some View {
        NavigationView {
            VStack(spacing: 20) {
                if oldiesMusicViewModel.sleepTimerActive || sliderViewModel1.sleepTimerActive{
                    // Active timer display
                    VStack(spacing: 15) {
                        Text("Sleep timer active")
                            .font(.headline)
                        
                        Text(oldiesMusicViewModel.formattedRemainingTime())
                            .font(.system(size: 48, weight: .medium, design: .monospaced))
                            .foregroundColor(.blue)
                        
                        Button(action: {
                            oldiesMusicViewModel.cancelSleepTimer()
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
                                if(oldiesMusicViewModel.isPlaying){
                                    oldiesMusicViewModel.startSleepTimer(minutes: Double(minutes))
                                }
                                if(sliderViewModel2.isPlaying){
                                    sliderViewModel2.startSleepTimer(minutes: Double(minutes))
                                }
                                if(sliderViewModel3.isPlaying){
                                    sliderViewModel3.startSleepTimer(minutes: Double(minutes))
                                }
                                if(sliderViewModel1.isPlaying){
                                    sliderViewModel1.startSleepTimer(minutes: Double(minutes))
                                }
                                
                            }) {
                                VStack {
                                    if(minutes < 1){
                                        
                                        Text("\(Int(minutes*60))")
                                            .font(.title2)
                                            .bold()
                                        Text("sec")
                                            .font(.caption)
                                    }else{
                                        Text("\(Int(minutes))")
                                            .font(.title2)
                                            .bold()
                                        Text("min")
                                            .font(.caption)
                                    }
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
                showingSleepTimer = false
            })
        }
    }
}


#Preview {
    ContentView()
}
