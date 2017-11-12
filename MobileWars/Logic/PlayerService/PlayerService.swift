//
//  Player.swift
//  MobileWars
//
//  Created by leonard on 12.11.2017.
//  Copyright © 2017 swiftbook.ru. All rights reserved.
//

import AVFoundation


class PlayerService {
    
   private static var player: AVAudioPlayer?
    
    public enum SoundType: String {
        case explosion = "explosion"
        case hit = "hit"
    }
    
    public class func playSound(ofType type: SoundType) {
        guard let url = Bundle.main.url(forResource: type.rawValue, withExtension: "mp3") else { return }

        DispatchQueue.global(qos: .default).async {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                
                guard let player = player else { return }
                
                player.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
