// Derived from: https://github.com/Matt54/SwiftUI-AudioKit-Visualizer/blob/master/Visualizer/Models/Conductor.swift

import SwiftUI
import AudioKit

enum ConductorError: Error {
    case couldNotOpenMicrophone
}

final class Conductor: ObservableObject {
    static let shared = Conductor()
    let engine = AudioEngine()
    var mic: AudioEngine.InputNode?
    var mixer: Mixer
    let refreshTimeInterval: Double = 0.02
    var fft: FFTTap?
    let FFT_SIZE = 512
    let sampleRate: double_t = 44100
    var outputLimiter: PeakLimiter?
    @Published var amplitudes: [Double] = Array(repeating: 0.5, count: 50)
    
    init() {
        mixer = Mixer()
        setupMic()
        
        do {
            try engine.start()
        } catch {
            assert(false, error.localizedDescription)
        }
    }
    
    func setupMic() {
        if let input = engine.input {
            mic = input
            if let inputAudio = mic {
                setupOutput(mic: inputAudio)
            }
        } else {
            mic = nil
            engine.output = mixer
        }
    }
    
    func setupOutput(mic: Node) {
        mixer = Mixer(mic)
        fft = FFTTap(mixer, handler: updateAmplitudes)
        
        let silentMixer = Mixer(mixer)
        silentMixer.volume = 0.0
        
        outputLimiter = PeakLimiter(silentMixer)
        engine.output = outputLimiter
    }
    
    func updateAmplitudes(_ fftData: [Float]) {
        for i in stride(from: 0, to: self.FFT_SIZE - 1, by: 2) {
            let real = fftData[i]
            let imaginary = fftData[i + 1]
            
            let normalizedBinMagnitude = (2.0 * sqrt(real * real + imaginary * imaginary)) / Float(self.FFT_SIZE)
            let amplitude = (20.0 * log10(normalizedBinMagnitude))
            
            var scaledAmplitude = (amplitude + 250) / 229.80
            
            if (scaledAmplitude < 0) {
                scaledAmplitude = 0
            }
            
            if(scaledAmplitude > 1.0) {
                scaledAmplitude = 1.0
            }
            
            DispatchQueue.main.async {
                if(i / 2 < self.amplitudes.count) {
                    self.amplitudes[i / 2] = self.mapy(n: Double(scaledAmplitude), start1: 0.3, stop1: 0.9, start2: 0.0, stop2: 1.0)
                }
            }
        }
    }
    
    func mapy(n: Double, start1: Double, stop1: Double, start2: Double, stop2: Double) -> Double {
        return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2
    }
}
