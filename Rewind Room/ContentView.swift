//
//  ContentView.swift
//  Rewind Room
//
//  Created by John Taylor on 4/14/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var audioPlayerViewModel = AudioPlayerViewModel()
    @StateObject var audioPlayerViewModel2 = AudioPlayerViewModel()
    @State var currItem: Int = 0
    
    var body: some View {
        NavigationStack{
            VStack{
                if(audioPlayerViewModel.songsArray.isEmpty){
                    
                }else{
                    AsyncImage(url: URL(string: audioPlayerViewModel.songsArray[currItem].art_url)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 10))
                    .scaledToFit()
                    .padding([.leading, .trailing], 100)
                    .animation(.bouncy, value: audioPlayerViewModel.isPlaying)
                    
//                    Text(audioPlayerViewModel.songsArray[currItem].title)
//                        .font(.title3)
                }
                
                
                
                //Text("\(audioPlayerViewModel.songsArray.last?.id ?? UUID())")
                
                
                VStack{
                    HStack{
                        
                        //Play Button
                        Button(action: {
                            if(audioPlayerViewModel.isPlaying){
                                audioPlayerViewModel.pause()
                            }else{
                                audioPlayerViewModel.play()
                            }
                        }) {
                            Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                        }
                        .padding()
                        
                        Text("Oldies")
                        
                        //Oldies Sound Slider
                        Slider(value: $audioPlayerViewModel.songVolumeLevel, in: 0...100) { isMoving in
                            audioPlayerViewModel.setVolumeLevel(volume: audioPlayerViewModel.songVolumeLevel)
                        }
                        
                        //Skip Button
                        Button {
                            if(audioPlayerViewModel.isPlaying){
                                audioPlayerViewModel.pause()
                            }
                            currItem = Int.random(in: 0..<audioPlayerViewModel.songsArray.count-1)
                            audioPlayerViewModel.setCurrentSong(song: audioPlayerViewModel.songsArray[currItem])
                            
                            if(!audioPlayerViewModel.isPlaying){
                                audioPlayerViewModel.play()
                            }
                        } label: {
                            Text("Skip Song")
                        }
                        .padding()
                    }
                    HStack{
                        //Play Button
                        Button(action: {
                            if(audioPlayerViewModel2.isPlaying){
                                audioPlayerViewModel2.pause()
                            }else{
                                audioPlayerViewModel2.play()
                            }
                        }) {
                            Image(systemName: audioPlayerViewModel2.isPlaying ? "pause.fill" : "play.fill")
                                .font(.largeTitle)
                        }
                        .padding()
                        
                        Text("Rain")
                        Slider(value: $audioPlayerViewModel2.songVolumeLevel, in: 0...100) { isMoving in
                            audioPlayerViewModel2.setVolumeLevel(volume: audioPlayerViewModel2.songVolumeLevel)
                        }
                        
                        
                    }

                }
            
                Spacer()
            }
            .navigationTitle("Rewind Room")
            .task {
                await audioPlayerViewModel.fetchSongs()
                audioPlayerViewModel.setCurrentSong(song: audioPlayerViewModel.songsArray[currItem])
                
                await audioPlayerViewModel2.fetchSoundEffects()
                audioPlayerViewModel2.setSoundEffect(sound: audioPlayerViewModel2.soundEffectArray[0])
            }
        }
    }
}


#Preview {
    ContentView()
}
