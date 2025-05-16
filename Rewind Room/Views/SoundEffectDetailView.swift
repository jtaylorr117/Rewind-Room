//
//  SoundEffectDetailView.swift
//  Rewind Room
//
//  Created by John Taylor on 5/16/25.
//

import SwiftUI

struct SoundEffectDetailView: View {
    @ObservedObject var soundEffectViewModel: AudioPlayerViewModel
    
    
    var body: some View {
        let currentSoundEffect = soundEffectViewModel.getSoundEffect()
        NavigationStack{
            Text(currentSoundEffect.label)
        }.navigationTitle("Change \(currentSoundEffect.soundType) Sound Effect")
    }
}
