//
//  PlayerViewController.swift
//  YouTubeAPI
//
//  Created by Shlykov Danylo on 6/19/20.
//  Copyright © 2020 Shlykov Danylo. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import MediaPlayer
import AVKit

class PlayerViewController: UIViewController {
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var videoProgressBar: UISlider!
    @IBOutlet weak var currentPosLabel: UILabel!
    @IBOutlet weak var lastPosLabel: UILabel!
    @IBOutlet weak var videoNameLabel: UILabel!
    @IBOutlet weak var videoViewsCountLabel: UILabel!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var closePlayerView: UIView!
    
    
    var presenter: PlayerPresenter<PlayerViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        playerView.delegate = self
        startPlayVideo()
        
        let audioSession = AVAudioSession.sharedInstance()
        let volume : Float = audioSession.outputVolume
        volumeSlider.setValue(volume, animated: false)
        
        closePlayerView.isUserInteractionEnabled = true
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(closePlayer))
        closePlayerView.addGestureRecognizer(closeGesture)
    }
    
    @objc func closePlayer() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        roundedView.layer.cornerRadius = 20
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        roundedView.clipsToBounds = true
        
        videoProgressBar.setThumbImage(#imageLiteral(resourceName: "ProgressThumb"), for: .normal)
        videoProgressBar.minimumTrackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        videoProgressBar.minimumTrackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.35)
        volumeSlider.setThumbImage(#imageLiteral(resourceName: "VolumeThumb"), for: .normal)
        volumeSlider.minimumTrackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        volumeSlider.minimumTrackTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.35)
        
        setupGradient()
    }
    
    func setupGradient() {
        let gradientedLayer = CAGradientLayer()
        gradientedLayer.colors = [
          UIColor(red: 0.933, green: 0.259, blue: 0.537, alpha: 1).cgColor,
          UIColor(red: 0.388, green: 0.043, blue: 0.961, alpha: 1).cgColor
        ]
        gradientedLayer.locations = [0, 1]
        gradientedLayer.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientedLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientedLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 0.5, ty: 0))
        gradientedLayer.bounds = roundedView.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        gradientedLayer.position = roundedView.center
        roundedView.layer.insertSublayer(gradientedLayer, at: 0)
    }
    
    func startPlayVideo() {
        playerView.isUserInteractionEnabled = false
        let playVars: [String : Any] = ["autoplay": 1, "controls": 0, "fs": 0, "iv_load_policy": 3, "playsinline": 1, "showinfo": 0, "disablekb": 1, "modestbranding": 1]
        playerView.load(withVideoId: presenter.currentVideoId, playerVars: playVars)
        setupVideo()
    }
    
    func setupVideo() {
        guard let currentVideoIndex = presenter.allVideoIds.firstIndex(of: presenter.currentVideoId) else {return}
        let curVideo = presenter.videoList[currentVideoIndex]
        videoNameLabel.text = curVideo.snippet.title
        videoViewsCountLabel.text = "\(curVideo.statistics.viewCount) просмотра"
        let videoDuration = curVideo.contentDetails.duration.getYoutubeFormattedDuration()
        lastPosLabel.text = videoDuration
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        if playButton.imageView?.image == UIImage(named: "Play") {
            playerView.playVideo()
        } else {
            playerView.pauseVideo()
        }
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        nextVideo()
    }
    
    @IBAction func previousButtonAction(_ sender: Any) {
        guard let currentVideoIndex = presenter.allVideoIds.firstIndex(of: presenter.currentVideoId) else {return}
        if currentVideoIndex > 0 {
            presenter.currentVideoId = presenter.allVideoIds[currentVideoIndex - 1]
            startPlayVideo()
        }
    }
    
    @IBAction func tracklineValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        
        guard let currentVideoIndex = presenter.allVideoIds.firstIndex(of: presenter.currentVideoId) else {return}
        let curVideo = presenter.videoList[currentVideoIndex]
        let videoDuration = curVideo.contentDetails.duration.getYoutubeFormattedDuration()
        let durationInSeconds = videoDuration.getSecondsFromDuration()
        let toSeconds = Float(durationInSeconds) * currentValue
        
        playerView.seek(toSeconds: toSeconds, allowSeekAhead: true)
    }
    
    @IBAction func volumeValueChanged(_ sender: UISlider) {
        MPVolumeView.setVolume(sender.value)
    }
    
    func nextVideo() {
        guard let currentVideoIndex = presenter.allVideoIds.firstIndex(of: presenter.currentVideoId) else {return}
        if currentVideoIndex < presenter.allVideoIds.count - 1 {
            presenter.currentVideoId = presenter.allVideoIds[currentVideoIndex + 1]
            startPlayVideo()
        }
    }
    
}

extension PlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        guard let currentVideoIndex = presenter.allVideoIds.firstIndex(of: presenter.currentVideoId) else {return}
        let curVideo = presenter.videoList[currentVideoIndex]
        let videoDuration = curVideo.contentDetails.duration.getYoutubeFormattedDuration()
        let durationInSeconds = videoDuration.getSecondsFromDuration()
        let currentTrackValue = playTime / Float(durationInSeconds)
        videoProgressBar.setValue(currentTrackValue, animated: true)
        
        let time = Int(playTime).getTimeFromInt()
        self.currentPosLabel.text = time
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .paused {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
        }
        if state == .playing {
            playButton.setImage(UIImage(named: "PauseIcon"), for: .normal)
        }
        if state == .ended {
            nextVideo()
        }
    }
}

extension PlayerViewController: PlayerView {
    
    func update() {
        
    }
    
}

extension MPVolumeView {
  static func setVolume(_ volume: Float) {
    let volumeView = MPVolumeView()
    let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
      slider?.value = volume
    }
  }
}
