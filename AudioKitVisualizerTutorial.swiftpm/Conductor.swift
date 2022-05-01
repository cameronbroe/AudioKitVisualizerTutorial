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
    var mixer: Mixer?
    let refreshTimeInterval: Double = 0.02
    var fft: FFTTap?
    let FFT_SIZE = 512
    let sampleRate: double_t = 44100
    var outputLimiter: PeakLimiter?
    @Published var amplitudes: [Double] = Array(repeating: 0.5, count: 50)
    
    init() {
        setupMic()
    }
    
    func setupMic() {
        if let input = engine.input {
            mic = input
            if let inputAudio = mic {
                setupOutput(mic: inputAudio)
            }
        } else {
            mic = nil
            engine.output = Mixer()
        }
    }
    
    func setupOutput(mic: AudioEngine.InputNode) {
        mixer = Mixer(mic)
        fft = FFTTap(mixer as! Node, handler: updateAmplitudes)
        
        let silentMixer = Mixer(mixer as! Node)
        silentMixer.volume = 0.0
        
        outputLimiter = PeakLimiter(silentMixer)
        engine.output = outputLimiter
    }
    
    func updateAmplitudes(_ amplitudes: [Float]) {
        
    }
}
