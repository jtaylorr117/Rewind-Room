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
    @State var currItem: Int = 0
    
    var body: some View {
        NavigationStack{
            VStack{
                if(oldiesMusicViewModel.songsArray.isEmpty){
                    
                }else{
                    AsyncImage(url: URL(string: oldiesMusicViewModel.songsArray[currItem].art_url)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .scaledToFit()
                    .padding([.leading, .trailing], 100)
                    .rotationEffect(Angle.degrees(recordIsSpinning ? 360 : 0))
                    .animation(recordIsSpinning
                        ? Animation.linear(duration: 4.0).repeatForever(autoreverses: false)
                        : .default,
                        value: recordIsSpinning
                    )
                    
                }
                
                VStack{
                    
                    
                    OldiesSliderView(
                        viewModel: oldiesMusicViewModel,
                        isSpinning: $recordIsSpinning,
                        currItem: $currItem
                    )
                    
                    SoundEffectSliderView(viewModel: rainSoundsViewModel,
                    symbol: "arrow.clockwise",
                    label: "Rain")
                    
                    SoundEffectSliderView(viewModel: staticSoundsViewModel, symbol: "arrow.clockwise", label: "Static")
                    
                    SoundEffectSliderView(viewModel: fireSoundsViewModel, symbol: "arrow.clockwise", label: "Fire")
                    

                }
            
                Spacer()
            }
            .navigationTitle("Rewind Room")
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
}


#Preview {
    ContentView()
}
