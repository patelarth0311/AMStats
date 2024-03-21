//
//  MusicPlayerViewData.swift
//  Musie
//
//  Created by Arth Patel on 9/20/23.
//

import Foundation
import MusicKit
import SwiftUI
import RealmSwift
import Combine
import MediaPlayer

@Observable class MusicPlayer {
    
   
    var offsetps : CGFloat = 0.0
    var offsetX : CGFloat = 0.0
    var timer : Timer.TimerPublisher = Timer.publish(every: 0.1, on: .current, in: .common)
    var loaded = false
    var width : CGFloat = 0.0
    var total : CGFloat = 0.0
    var interval  : TimeInterval = TimeInterval()
    var timerSubscription: Cancellable?
    var subscription: AnyCancellable?
    var subscription2: AnyCancellable?
    var currentlyPlayingSong : Song?  = nil
    
    init() {
       
       
        subscription2 = SystemMusicPlayer.shared.state.objectWillChange.sink(receiveCompletion: { _ in
            
        }, receiveValue: { _ in
            print(SystemMusicPlayer.shared.state.playbackStatus)
        })
        
       
        
        subscription = SystemMusicPlayer.shared.queue.objectWillChange.sink(receiveCompletion: { _ in
           
        }, receiveValue: { _ in
            DispatchQueue.main.async {
               
                self.currentlyPlayingSong  = SystemMusicPlayer.shared.queue.currentEntry?.song
                   
                  
                
                if   SystemMusicPlayer.shared.state.playbackStatus == .playing, let song = self.currentlyPlayingSong  {
                    self.timer = Timer.publish(every: 0.1, on: .main, in: .common)
                    self.timerSubscription =  self.timer.connect()
                    self.interval =  SystemMusicPlayer.shared.playbackTime
                   
                }
            }
           
          
        })
        
    }
    
    func pause() -> Void {
       
            SystemMusicPlayer.shared.pause()
        DispatchQueue.main.async {
            self.timerSubscription?.cancel()
            self.timerSubscription = nil
        }
    }
    
    func play() -> Void {
        Task {
            do {
                try await SystemMusicPlayer.shared.play()
                
            } catch {
                
            }
                        
            
        }
        DispatchQueue.main.async {
            self.timer = Timer.publish(every: 0.1, on: .current, in: .common)
            self.timerSubscription =  self.timer.connect()
        }
       
    }
    
    func skip() -> Void {
        
        Task {
            try await SystemMusicPlayer.shared.skipToNextEntry()
           
          
        }
      
    }
    
    func backward() -> Void {
        Task {
            try await SystemMusicPlayer.shared.skipToPreviousEntry()
            
            
        }
       
    }
    
    
}
