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
    
    @Published var shouldLoop: Bool = true
    private var playbackObserver: Any?

    //deallocates the observeer when the viewmodel is no longer needed
    deinit {
        if let observer = playbackObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func play() {
        guard let player = audioPlayer else { return }
        player.play()
        isPlaying = true
    }
    
    func restart() {
        guard let player = audioPlayer else { return }
        player.seek(to: .zero)
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
        observePlayerDidFinishPlaying()
    }
    
    
    // sets the sound effect to the one in the database matching the id provided
    func setSoundEffect(soundEffectId: Int){
        
        for sound in soundEffectArray{
            if (sound.id == soundEffectId){
                let foundSound = sound
                let url = URL(string: foundSound.audioFile)!
                audioPlayer = AVPlayer(url: url)
                observePlayerDidFinishPlaying()
                break
            }
        }
    }
    
    func setVolumeLevel(volume: Float){
        guard let player = audioPlayer else { return }
        player.volume = volume
        songVolumeLevel = volume
    }
    
    // useses an observer to check when a song finishes playing so that it can loop it
    private func observePlayerDidFinishPlaying() {
        if let observer = playbackObserver {
            NotificationCenter.default.removeObserver(observer)
        }

        playbackObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: audioPlayer?.currentItem,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            if self.shouldLoop {
                self.audioPlayer?.seek(to: .zero)
                self.audioPlayer?.play()
            } else {
                self.isPlaying = false
            }
        }
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
