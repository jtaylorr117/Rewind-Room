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
    
    
    @State private var recordIsSpinning = false
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
                    .clipShape(Circle())
                    .scaledToFit()
                    .padding([.leading, .trailing], 100)
                    .rotationEffect(Angle.degrees(recordIsSpinning ? 360 : 0))
                    .animation(recordIsSpinning
                        ? Animation.linear(duration: 4.0).repeatForever(autoreverses: false)
                        : .default,
                        value: recordIsSpinning
                    )
                    
                    
                    //                    Text(audioPlayerViewModel.songsArray[currItem].title)
                    //                        .font(.title3)
                }
                
                
                
                //Text("\(audioPlayerViewModel.songsArray.last?.id ?? UUID())")
                
                
                VStack{
                    HStack{
                        
                        //Play Button
                        Button(action:
                        {
                            if audioPlayerViewModel.isPlaying {
                                    audioPlayerViewModel.pause()
                                    recordIsSpinning = false
                                } else {
                                    audioPlayerViewModel.play()
                                    recordIsSpinning = false // reset position to 0 before spinning again
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                        recordIsSpinning = true
                                    }
                                }
                        }) {
                            Image(systemName: audioPlayerViewModel.isPlaying ? "pause.fill" : "play.fill")
                        }
                        .padding()
                        
                        Text("Oldies")
                            .frame(width: 60, alignment: .leading)
                        
                        
                        //Oldies Sound Slider
                        Slider(value: $audioPlayerViewModel.songVolumeLevel, in: 0...100) { isMoving in
                            audioPlayerViewModel.setVolumeLevel(volume: audioPlayerViewModel.songVolumeLevel)
                        }
                        
                        //Skip Button
                        Button {
                            if(audioPlayerViewModel.isPlaying){
                                audioPlayerViewModel.pause()
                            }
                            
                            recordIsSpinning = false // stop rotation before skipping
                            
                            currItem = Int.random(in: 0..<audioPlayerViewModel.songsArray.count-1)
                            audioPlayerViewModel.setCurrentSong(song: audioPlayerViewModel.songsArray[currItem])
                            
                            if(!audioPlayerViewModel.isPlaying){
                                audioPlayerViewModel.play()
                                recordIsSpinning = false // reset position to 0 before spinning again
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                    recordIsSpinning = true
                                }
                                
                            }
                        } label: {
                            //Text("Skip Song")
                            Image(systemName: "forward.fill")
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
                        }
                        .padding()
                        
                        Text("Rain")
                            .frame(width: 60, alignment: .leading)
                        

                        
                        Slider(value: $audioPlayerViewModel2.songVolumeLevel, in: 0...100) { isMoving in
                            audioPlayerViewModel2.setVolumeLevel(volume: audioPlayerViewModel2.songVolumeLevel)
                        }.padding(.trailing, 20)
                        
                        
                        
                    }

                }
            
                Spacer()
            }
            .navigationTitle("Rewind Room")
            .task {
                await audioPlayerViewModel.fetchSongs()
                audioPlayerViewModel.setCurrentSong(song: audioPlayerViewModel.songsArray[currItem])
                
                await audioPlayerViewModel2.fetchSoundEffects()
                audioPlayerViewModel2.setSoundEffect(soundEffectId: 1)
            }
        }
    }
}


#Preview {
    ContentView()
}
