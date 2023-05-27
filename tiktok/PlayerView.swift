//
//  PlayerView.swift
//  tiktok
//
//  Created by RMAC34 on 13/05/23.
//

import UIKit
import AVKit

class PlayerView: UIView {
    // MARK: Configuration

    /// `.resizeAspectFill` by default.
    public var videoGravity: AVLayerVideoGravity = .resizeAspectFill {
        didSet {
            _playerLayer?.videoGravity = videoGravity
        }
    }

    /// `true` by default. If disabled, the video will resize with the frame without animations
    public var animatesFrameChanges = true

    /// `true` by default. If disabled, will only play a video once.
    public var isLooping = true {
        didSet {
            guard isLooping != oldValue else { return }
            player?.actionAtItemEnd = isLooping ? .none : .pause
            if isLooping, !(player?.nowPlaying ?? false) {
                restart()
            }
        }
    }

    /// Add if you want to do something at the end of the video
    public var onVideoFinished: (() -> Void)?

    // MARK: Initialization

    public var playerLayer: AVPlayerLayer {
        if let layer = _playerLayer {
            return layer
        }
        let playerLayer = AVPlayerLayer()
        self.layer.addSublayer(playerLayer)
        
        playerLayer.frame = bounds
        playerLayer.videoGravity = videoGravity
        _playerLayer = playerLayer
        return playerLayer
    }

    private var _playerLayer: AVPlayerLayer?

    override public func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(!animatesFrameChanges)
        _playerLayer?.frame = bounds
        CATransaction.commit()
    }

    // MARK: Private

    private var player: AVPlayer? {
        didSet {
            registerNotifications()
        }
    }

    private var playerObserver: AnyObject?

    public func reset() {
        _playerLayer?.player = nil
        player = nil
        playerObserver = nil
    }

    public var asset: AVAsset? {
        didSet { assetDidChange() }
    }
    
    public var videoUrl: URL? {
        didSet {
            videoUrlDidChange()
        }
    }

    private func assetDidChange() {
        if asset == nil {
            reset()
        }
    }
    
    private func videoUrlDidChange() {
        guard let videoUrl = videoUrl else {
            return
        }
        let asset = AVURLAsset(url: videoUrl)
        self.asset = asset
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerItemDidPlayToEndTimeNotification(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    public func restart() {
        player?.seek(to: CMTime.zero)
        player?.play()
    }

    public func play() {
        guard let asset = asset else {
            return
        }

        let playerItem = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer(playerItem: playerItem)
        player.isMuted = true
        player.preventsDisplaySleepDuringVideoPlayback = false
        player.actionAtItemEnd = isLooping ? .none : .pause
        self.player = player

        playerLayer.player = player

        playerObserver = player.observe(\.status, options: [.new, .initial]) { player, _ in
            Task { @MainActor in
                if player.status == .readyToPlay {
                    player.play()
                }
            }
        }
    }

    @objc private func playerItemDidPlayToEndTimeNotification(_ notification: Notification) {
        guard let playerItem = notification.object as? AVPlayerItem else {
            return
        }
        if isLooping {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
        } else {
            onVideoFinished?()
        }
    }

    @objc private func applicationWillEnterForeground() {
        if shouldResumeOnInterruption {
            player?.play()
        }
    }
    override public func willMove(toWindow newWindow: UIWindow?) {
        if newWindow != nil && shouldResumeOnInterruption {
            player?.play()
        }
    }

    private var shouldResumeOnInterruption: Bool {
        return player?.nowPlaying == false &&
        player?.status == .readyToPlay &&
        isLooping
    }
}


