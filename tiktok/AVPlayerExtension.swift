//
//  AVPlayerExtension.swift
//  tiktok
//
//  Created by RMAC34 on 14/05/23.
//

import AVKit

@MainActor
extension AVPlayer {
    var nowPlaying: Bool {
        rate != 0 && error == nil
    }
}
