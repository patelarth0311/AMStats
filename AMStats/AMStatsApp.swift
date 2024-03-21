//
//  MusieApp.swift
//  Musie
//
//  Created by Arth Patel on 8/10/23.
//

import SwiftUI
import RealmSwift
import BackgroundTasks
import MusicKit

extension UINavigationBarAppearance {
    
}

@main
struct MusieApp: SwiftUI.App {
@State private var libraryData = LibraryData()

@Environment(\.scenePhase) private var phase

@State private var musicPlayer =  MusicPlayer()

    
init() {
    let appearance = UINavigationBarAppearance()

    appearance.configureWithDefaultBackground()
    
    appearance.shadowImage = nil // line
    appearance.shadowColor = .none // line

    appearance.setBackIndicatorImage(UIImage(systemName: "arrow.uturn.backward.circle")?.withTintColor(.white), transitionMaskImage: UIImage(systemName: "arrow.uturn.backward.circle")?.withTintColor(.white))
    UITableView.appearance().separatorStyle = .none
    UINavigationBar.appearance().standardAppearance = appearance
    

    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithTransparentBackground()
    UITabBar.appearance().standardAppearance = tabBarAppearance
    
    
      
}

var body: some Scene {
    
    
WindowGroup {
    GeometryReader { geometry in
        if (libraryData.loaded) {
        
                ContentView()
                .environment(libraryData)
                .environment(musicPlayer)
                .tint(.pink)
           
            
        } else {
            SplashView()
                
        }
    
           
    }
}
.onChange(of: phase) { oldValue, newValue in
    switch newValue {
    case .background:
        schedule(id: "UpdateListeningHistory", when: Date.now)
      
    case .active:
        DispatchQueue.main.async {
           
            self.musicPlayer.currentlyPlayingSong  = SystemMusicPlayer.shared.queue.currentEntry?.song
           
          
           
        
            if   SystemMusicPlayer.shared.state.playbackStatus == .playing, let song = musicPlayer.currentlyPlayingSong  {
            self.musicPlayer.timer = Timer.publish(every: 1, on: .main, in: .common)
            self.musicPlayer.timerSubscription =    self.musicPlayer.timer.connect()
            self.musicPlayer.interval =  SystemMusicPlayer.shared.playbackTime
            
        }
        }
            
    default:
        break;
    }
}
.backgroundTask(.appRefresh("UpdateListeningHistory")) {
    await updateListeningHistory()
}
}
    func schedule(id: String, when: Date) {
        
      
        let request = BGAppRefreshTaskRequest(identifier: id)
        request.earliestBeginDate = when
        
        do {
          try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
       
    }
    
    func updateListeningHistory()  async {

           var songMusicRequest = MusicLibraryRequest<MusicKit.Song>()
          
           songMusicRequest.sort(by: \.title, ascending: true)
          
       
           do {
             
               self.libraryData.fetch { success in
                   
                   DispatchQueue.main.async {
                       
                       libraryData.realm.writeAsync {
                
                           let cumulativeEntry = libraryData.realm.objects(CumulativeStats.self).first { item in
                               item.date.startOfDay == Date.now.startOfDay
                           }
                           let deltaEntry = libraryData.realm.objects(DeltaStats.self).first { item in
                               item.date.startOfDay == Date.now.startOfDay
                           }
                           
                           let startEntry  = libraryData.realm.objects(StartStats.self).first { item in
                               item.date.startOfDay == Date.now.startOfDay
                           }
                         
                       
                           
                           
                           if let existingCumulativeEntry = cumulativeEntry {
                          
                               
                               existingCumulativeEntry.minutesListened = Int(libraryData.totalMinutes)
                               existingCumulativeEntry.playCount = Int(libraryData.playCount)
                              
                               if let existingDeltaEntry = deltaEntry, let existingStartStatsEntry = startEntry {
                                   existingDeltaEntry.minutesListened = Int(self.libraryData.totalMinutes) - existingStartStatsEntry.minutesListened
                                   existingDeltaEntry.playCount = Int(self.libraryData.playCount) - existingStartStatsEntry.playCount
                               }
                               
                           } else {
                               
                                   // no entry exists. add total of all stats as starting
                               let newCumulativeEntry : CumulativeStats = CumulativeStats(date: Date.now, playCount: Int(self.libraryData.playCount), minutesListened: Int(self.libraryData.totalMinutes))
                               self.libraryData.realm.add(newCumulativeEntry)
                               let newStartStats : StartStats = StartStats(date: Date.now, playCount: Int(self.libraryData.playCount), minutesListened: Int(self.libraryData.totalMinutes))
                               self.libraryData.realm.add(newStartStats)
                               
                           }
                       }
                   }
               }
               
              
               
               
           } catch {
               print(error)
           }

          
       
   }
}




