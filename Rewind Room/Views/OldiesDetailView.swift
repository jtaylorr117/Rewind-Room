import SwiftUI
import AVFoundation

struct OldiesDetailView: View {
    @ObservedObject var viewModel: AudioPlayerViewModel
    @Binding var isSpinning: Bool
    @Binding var currItem: Int
    @Environment(\.dismiss) private var dismiss
    @State private var progress: Float = 0
    @State private var duration: Float = 1
    @State private var timer: Timer? = nil
    
    var body: some View {
        let song = viewModel.getCurrentSong()
        VStack(spacing: 24) {
            // Song Info
            VStack(spacing: 8) {
                if let artURL = URL(string: song.art_url) {
                    AsyncImage(url: artURL) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                Text(song.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                if let date = song.date {
                    Text(date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top)
            
            
            Spacer()
            
            
            // Progress Bar
            VStack(spacing: 4) {
                SliderView(value: $progress, range: 0...duration) { editing in
                    if !editing {
                        seekTo(Double(progress))
                    }
                }
                HStack {
                    Text(timeString(Double(progress)))
                        .font(.caption.monospacedDigit())
                    Spacer()
                    Text(timeString(Double(duration)))
                        .font(.caption.monospacedDigit())
                }
            }
            .padding(.horizontal)
            
            // Controls
            HStack(spacing: 40) {
                Button(action: { skip(-10) }) {
                    Image(systemName: "gobackward.10")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
                Button(action: {
                    if viewModel.isPlaying {
                        viewModel.pause()
                    } else {
                        viewModel.play()
                    }
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                }
                Button(action: { skip(10) }) {
                    Image(systemName: "goforward.10")
                        .font(.system(size: 32))
                        .foregroundColor(.blue)
                }
            }
            
            // Skip Button
            Button(action: {
                if viewModel.isPlaying {
                    viewModel.pause()
                }
                isSpinning = false
                if !viewModel.songsArray.isEmpty {
                    currItem = Int.random(in: 0..<viewModel.songsArray.count)
                    viewModel.setCurrentSong(song: viewModel.songsArray[currItem])
                    viewModel.setVolumeLevel(volume: viewModel.songVolumeLevel)
                    if viewModel.songVolumeLevel > 0 {
                        viewModel.play()
                        isSpinning = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            isSpinning = true
                        }
                    }
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 18, weight: .medium))
                    Text("Skip")
                        .font(.system(size: 18, weight: .semibold))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.15))
                .foregroundColor(.blue)
                .cornerRadius(20)
            }
            .padding(.top, 4)
            
            // Volume
            VStack(spacing: 4) {
                Text("Volume")
                    .font(.caption)
                SliderView(value: $viewModel.songVolumeLevel, range: 0...1) { _ in
                    viewModel.setVolumeLevel(volume: viewModel.songVolumeLevel)
                    if viewModel.songVolumeLevel > 0 && !viewModel.isPlaying {
                        viewModel.play()
                    }
                    if viewModel.songVolumeLevel == 0 && viewModel.isPlaying {
                        viewModel.pause()
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Now Playing")
        .onAppear {
            setupProgressTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func setupProgressTimer() {
        updateProgress()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            updateProgress()
        }
    }
    
    private func updateProgress() {
        guard let player = viewModel.audioPlayer, let item = player.currentItem else { return }
        let asset = item.asset
        Task {
            do {
                let durationValue = try await asset.load(.duration)
                let durationSeconds = Float(durationValue.seconds.isFinite ? durationValue.seconds : 1)
                await MainActor.run {
                    self.duration = durationSeconds
                    self.progress = Float(item.currentTime().seconds)
                }
            } catch {
                print("Failed to load duration: \(error)")
            }
        }
    }
    
    private func seekTo(_ time: Double) {
        guard let player = viewModel.audioPlayer else { return }
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player.seek(to: cmTime)
    }
    
    private func skip(_ seconds: Double) {
        guard let player = viewModel.audioPlayer else { return }
        let current = player.currentTime().seconds
        let newTime = max(0, min(current + seconds, Double(duration)))
        seekTo(newTime)
    }
    
    private func timeString(_ seconds: Double) -> String {
        let min = Int(seconds) / 60
        let sec = Int(seconds) % 60
        return String(format: "%d:%02d", min, sec)
    }
} 
