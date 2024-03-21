//
//  Realm.swift
//  Musie
//
//  Created by Arth Patel on 9/8/23.
//

import Foundation
import RealmSwift
import MusicKit


class ListeningData : Object,  Identifiable {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted  var date : Date
    @Persisted  var playCount : Int
    @Persisted  var minutesListened : Int
    
    convenience init(date: Date, playCount: Int, minutesListened: Int) {
        self.init()
        self.date = date.startOfDay
        self.playCount = playCount
        self.minutesListened = minutesListened
    }
}



class StartStats: Object,  Identifiable {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted  var date : Date
    @Persisted  var playCount : Int
    @Persisted  var minutesListened : Int
    
    convenience init(date: Date, playCount: Int, minutesListened: Int) {
        self.init()
        self.date = date.startOfDay
        self.playCount = playCount
        self.minutesListened = minutesListened
    }
}

class CumulativeStats : Object,  Identifiable {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted  var date : Date
    @Persisted  var playCount : Int
    @Persisted  var minutesListened : Int
    
    convenience init(date: Date, playCount: Int, minutesListened: Int) {
        self.init()
        self.date = date.startOfDay
        self.playCount = playCount
        self.minutesListened = minutesListened
    }
}

class DeltaStats : Object,  Identifiable {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    @Persisted  var date : Date
    @Persisted  var playCount : Int
    @Persisted  var minutesListened : Int
    
    convenience init(date: Date, playCount: Int, minutesListened: Int) {
        self.init()
        self.date = date.startOfDay
        self.playCount = playCount
        self.minutesListened = minutesListened
    }
}


class SongListened: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: String = UUID().uuidString
    
    @Persisted var musicId: String
    @Persisted var playsOverTime: List<ListeningData>
    
    
    convenience init(musicId: String, playsOverTime: List<ListeningData>) {
        self.init()
        self.musicId = musicId
        self.playsOverTime = playsOverTime
    }
    
}

func writeToRealm(realm: Realm, song: Song) {
    DispatchQueue.main.async {
        realm.writeAsync {
            
        
            
                let songEntry = realm.objects(SongListened.self).first { item in
                                item.musicId == song.id.rawValue
                            }
                            
                            if let existingEntry = songEntry {
                                
                                
                                if let playcount = song.playCount, let duration = song.duration {
                                    let entry = existingEntry.playsOverTime.first { item in
                                        item.date == Date.now.startOfDay
                                       
                                    }
                                  
                                    if let existingDate = entry {
                                        existingDate.playCount = playcount
                                        existingDate.minutesListened = Int(  Double(playcount) * (duration/60.0))
                                       
                                    } else {
                                        existingEntry.playsOverTime.append(ListeningData(date: Date(), playCount: playcount, minutesListened: Int(  Double(playcount) * (duration/60.0))))
                                    }
                                    
                                  
                                }
                               
                            } else {
                                if let playcount = song.playCount, let duration = song.duration {
                                    let songListened = SongListened(musicId: song.id.rawValue, playsOverTime: List<ListeningData>())
                                  
                                    
                                    songListened.playsOverTime.append(ListeningData(date: song.lastPlayedDate ?? Date(), playCount: playcount, minutesListened:  Int(  Double(playcount) * (duration/60.0))))
                                    
                                    if let date = song.lastPlayedDate {
                                        if date.startOfDay != Date.now.startOfDay {
                                            songListened.playsOverTime.append(ListeningData(date: Date(), playCount: playcount, minutesListened: Int(  Double(playcount) * (duration/60.0))))
                                        }
                                    }
                                    
                                  
                                  realm.add(songListened )
                                }
                            }
            
            

            
                            
                
       }
       
    }
}
