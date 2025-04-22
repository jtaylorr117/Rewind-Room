//
//  SleepTimerView.swift
//  Rewind Room
//
//  Created by John Taylor on 4/21/25.
//

import SwiftUI

struct SleepTimerView: View {
    @ObservedObject var viewModel: AudioPlayerViewModel
    @Binding var isPresented: Bool
    
    let timerOptions = [0.1, 0.5, 1, 5, 10, 15, 30, 60]
    
    var body: some View {
        
    }
}
