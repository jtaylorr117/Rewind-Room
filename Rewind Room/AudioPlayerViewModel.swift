//
//  AudioPlayerViewModel.swift
//  Rewind Room
//
//  Created by John Taylor on 4/14/25.
//

import AVFoundation
import Supabase

class AudioPlayerViewModel: ObservableObject {
    var audioPlayer: AVPlayer?
    
    
    @Published var isPlaying = false
    @Published var songsArray: [Song] = []
    @Published var soundEffectArray: [SoundEffect] = []
    @Published var songVolumeLevel: Float = 50.0
    
    func play() {
        guard let player = audioPlayer else { return }
        player.play()
        isPlaying = true
    }
    func pause() {
        guard let player = audioPlayer else { return }
        player.pause()
        isPlaying = false
    }
    
    func setCurrentSong(song: Song){
        let url = URL(string: song.audio_url)!
        audioPlayer = AVPlayer(url: url)
    }
    
    func setSoundEffect(sound: SoundEffect){
        let url = URL(string: sound.audioFile)!
        audioPlayer = AVPlayer(url: url)
    }
    
    func setVolumeLevel(volume: Float){
        guard let player = audioPlayer else { return }
        player.volume = volume
    }
    
    @MainActor
    func fetchSongs() async {
        do{
            let songs: [Song] = try await supabase
                .from("songs")
                .select()
                .execute()
                .value
            
            songsArray = songs
            
        }
        catch{
            print ("ERROR:: \(error)")
        }
    }

    
    @MainActor
    func fetchSoundEffects() async {
        do{
            let soundEffects: [SoundEffect] = try await supabase
                .from("soundEffects")
                .select()
                .execute()
                .value
            
            soundEffectArray = soundEffects
            
        }
        catch{
            print ("ERROR:: \(error)")
        }
    }
    
}
