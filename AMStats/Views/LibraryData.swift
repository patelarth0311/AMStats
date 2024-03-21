//qqqqqqqqqq
//
//  Created by Arth Patel on 8/13/23.
//

import Foundation
import MusicKit
import SwiftUI
import RealmSwift
import Combine
import MediaPlayer

@Observable class AMLibraryData {
    var songs : MusicItemCollection<MusicKit.Song> = MusicItemCollection<MusicKit.Song>()
    var artists : MusicItemCollection<MusicKit.Artist> = MusicItemCollection<MusicKit.Artist>()
    var albums : MusicItemCollection<MusicKit.Album> = MusicItemCollection<MusicKit.Album>()
    var recommendations :  [Recommendation] = [Recommendation]()
    var querysongs : MusicItemCollection<MusicKit.Song> = MusicItemCollection<MusicKit.Song>()
    var queryartists : MusicItemCollection<MusicKit.Artist> = MusicItemCollection<MusicKit.Artist>()
    var queryalbums : MusicItemCollection<MusicKit.Album> = MusicItemCollection<MusicKit.Album>()
    
    init() {
        
    }
}

extension MusicKit.Song {
    
}


struct  Recommendation : Identifiable, Hashable  {
  
    var id = UUID()
    var recommendation : MusicKit.MusicPersonalRecommendation
    var items : [MusicKit.MusicPersonalRecommendation.Item]
    
    init( recommendation: MusicKit.MusicPersonalRecommendation, items: [MusicKit.MusicPersonalRecommendation.Item]) {
       
        self.recommendation = recommendation
        self.items = items
    }
    
}





@Observable class LibraryData : AMLibraryData  {
    
    let realm = try! Realm()
    var loaded = false
    var totalMinutes : Double = 0.0
    var playCount : Double = 0.0

    var refresh = false;
    var option : SortOption = .lastPlayed
    var applicationMusicPlayer = SystemMusicPlayer.shared

   


    
    
    override
    init() {
        super.init()
        
        
     
        
       
        
        
        
       
            
        self.fetch { success in
            if success {
                
               self.loaded = true
               
        
             
                
            }
        }
        
    }
    
    private func requestAM() async -> MusicAuthorization.Status {
        let status = await MusicAuthorization.request()
        return status
    }
    
   
    
    
    @MainActor func sort(contentType: ContentType, optionChoose: SortOption) {
     
            switch contentType {
            case .songs:
                sortSongs(sortOption: optionChoose) { data in
                    self.songs = data
                   
                }
            case .artists:
                sortArtists(sortOption: optionChoose) { data in
                    self.artists = data
                   
                }
            case .albums:
                sortAlbums(sortOption: optionChoose) { data in
                    self.albums = data
                }
            }
            
        
    }
    
    
     func getPlaysAndMinutes() -> (Double,Double) {
        
        var totalMinutes : Double = 0.0
        var playCount : Double = 0.0
         
        self.songs.forEach { song in
            if let plays = song.playCount, let interval = song.duration {
             totalMinutes = totalMinutes + (Double(plays) * ((interval)/60))
             playCount = playCount + Double(plays)
              
               writeToRealm(realm: realm, song: song)
           
              
            }
        }
         
         DispatchQueue.main.async {
             
             self.realm.writeAsync {
                 
                
                
                 
                 let cumulativeEntry = self.realm.objects(CumulativeStats.self).first { item in
                     item.date.startOfDay == Date.now.startOfDay
                 }
                 
                 
                 let deltaEntry = self.realm.objects(DeltaStats.self).first { item in
                     item.date.startOfDay == Date.now.startOfDay
                 }
                 
                 let startEntry  = self.realm.objects(StartStats.self).first { item in
                     item.date.startOfDay == Date.now.startOfDay
                 }
                 
                
                
                 
                
                 if let existingCumulativeEntry = cumulativeEntry {
                
                     
                     existingCumulativeEntry.minutesListened = Int(totalMinutes)
                     existingCumulativeEntry.playCount = Int(playCount)
                     
                     if let existingDeltaEntry = deltaEntry, let existingStartStatsEntry = startEntry {
                         existingDeltaEntry.minutesListened = Int(totalMinutes) - existingStartStatsEntry.minutesListened
                         existingDeltaEntry.playCount = Int(playCount) - existingStartStatsEntry.playCount
                     }
                    
                     
                 } else {
                     
                         // no entry exists. add total of all stats as starting
                         let newCumulativeEntry : CumulativeStats = CumulativeStats(date: Date.now, playCount: Int(playCount), minutesListened: Int(totalMinutes))
                         self.realm.add(newCumulativeEntry)
                         let newStartStats : StartStats = StartStats(date: Date.now, playCount: Int(playCount), minutesListened: Int(totalMinutes))
                         self.realm.add(newStartStats)
                     
                        let newDeltaStats : DeltaStats = DeltaStats(date: Date.now, playCount: 0, minutesListened: 0)
                        self.realm.add(newDeltaStats)
                       
                     
                 }
                 
                
             }
         }
         

       
         return (totalMinutes, playCount)
    }
    
    
    
    func fetch(_ completion: @escaping (_ success: Bool) -> Void) {
        
        
        Task {
       
            let status = await self.requestAM()
            
            switch status {
            case .authorized:
                var songMusicRequest = MusicLibraryRequest<MusicKit.Song>()
             
               
                songMusicRequest.sort(by: \.title, ascending: true)
               
                var artistMusicRequest = MusicLibraryRequest<MusicKit.Artist>()
                artistMusicRequest.sort(by: \.name, ascending: true)
                
                var albumMusicRequest = MusicLibraryRequest<MusicKit.Album>()
                albumMusicRequest.sort(by: \.title, ascending: true)
                
                let recommendationRequest = MusicPersonalRecommendationsRequest()
                
                do {
                    let songResult = try await songMusicRequest.response()
                    
                    
                
                   
     
                    self.songs = songResult.items
                    
                   
               
                    let artistResult = try await artistMusicRequest.response()
                    self.artists = artistResult.items
                   

                    
                   
                    
                    
                    let albumResult = try await albumMusicRequest.response()
                    self.albums = albumResult.items
                    
                    
                
                   
                 
                    
                    let recommendationResult = try await recommendationRequest.response()
                    
                    self.recommendations = recommendationResult.recommendations.map { item in
                        return Recommendation(recommendation: item, items: item.items.itemsArray)
                    }
                  
                  
                 
                    (self.totalMinutes, self.playCount) =  self.getPlaysAndMinutes()
                    self.querysongs = songResult.items
                    self.queryartists = artistResult.items
                    self.queryalbums = albumResult.items
                   completion(true)
                    
                } catch {
                   
                    completion(false)
                }
            default:
                break;
            }
        }
    }






}


