//
//  ContentView.swift
//  UtteranceToURLStarter
//
//  Created by Ali Mohammadian on 6/15/21.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    let utteranceText = "Hi how are you. This is sample text."
    
    var body: some View {
        VStack {
            Button(action: {
                speechSynthesizer.stopSpeaking(at: .immediate)
                let speechVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
                let speechUtterance = AVSpeechUtterance(string: utteranceText)
                
                speechUtterance.voice = speechVoice
                speechSynthesizer.speak(speechUtterance)
            }) {
                Text("Preview utterance audio")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
            }.padding()
            
            Button(action: {
                let speechVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_en-GB_compact")
                let speechUtterance = AVSpeechUtterance(string: utteranceText)
                
                speechUtterance.voice = speechVoice
                // Exporting
                let savePathUrl: URL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/audio.m4a")
                do {
                    try saveAVSpeechUtteranceToFile(utterance: speechUtterance, fileURL: savePathUrl)
                } catch {
                    print("CATCH ERROR \(error.localizedDescription)")
                }
               
                
                
            }) {
                Text("Export utterance audio to URL")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
            }
            
            
        }

    }
    
    private func saveAVSpeechUtteranceToFile(utterance: AVSpeechUtterance, fileURL: URL) throws {
        let synthesizer = AVSpeechSynthesizer()
        
        var output: AVAudioFile?
        print("Saving utterance to file: \(fileURL.absoluteString)")
        
        try? FileManager.default.removeItem(at: fileURL)
        
        synthesizer.write(utterance) { buffer in
           guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
              print("unknown buffer type: \(buffer)")
              return
           }
           if pcmBuffer.frameLength == 0 {
              // no length
           } else {
              if output == nil {
                 output = try! AVAudioFile(forWriting: fileURL, settings: pcmBuffer.format.settings, commonFormat: .pcmFormatInt16, interleaved: false)
              }
              try! output!.write(from: pcmBuffer)
           }
        }
     }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
