//
//  InsightsView.swift
//  Musie
//
//  Created by Arth Patel on 8/28/23.
//

import SwiftUI
import Charts
import MusicKit
import UIKit



enum Month : String, Identifiable {
    case March
    case February
    case January
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
    
    var id: Self {self}
    
    var fullMonthName : String {
        return self.rawValue
    }
    

    
    var monthNumber : Int {
        switch self {
        case .January:
            return 1
        case .February:
            return 2
        case .March:
            return 3
        case .April:
            return 4
        case .May:
            return 5
        case .June:
            return 6
        case .July:
            return 7
        case .August:
            return 8
        case .September:
            return 9
        case .October:
            return 10
        case .November:
            return 11
        case .December:
            return 12
        }
    }
    
    
}

enum TimeFrame :  String , Identifiable {
    case day
    case week
    case month
    case year
    var id: Self { self }
    
    var component : Calendar.Component {
        switch self {
        case .day:
            return .minute
        case .week:
            return .day
        case .month:
            return .day
        case .year:
            return .month
            
        }
    }
    
    var text : String {
        switch self {
        case .day:
            return Date.now.day
        case .week:
            return Date.now.week
        case .month:
            return Date.now.month
        case .year:
            return Date.now.year
            
        }
    }
}

struct YearSelectorView : View {
    
    @Binding var year : Date
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach([Date.now.startOfYear], id: \.self) { year in
                    Button {
                        self.year = year
                    } label: {
                        Text(year.year)
                            .font(.system(.title,weight: .semibold))
                            
                            .foregroundStyle(self.year == year ? .pink : .secondary)
                        
                    }

                }
            }
        }
        .foregroundStyle(.secondary)
    }
       
}

struct MonthSelectorView : View {
    @Binding var month : Month
    var months : [Month] = [.January,.February,.March,.April,.May,.June,.July,.August,.September,.October,.November,.December]
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .bottom,spacing: 14) {
                ForEach(months) { month in
                    Button {
                        self.month = month
                    } label: {
                        Text(month.fullMonthName)
                            .font(.system(.title2,weight: .semibold))
                            .foregroundStyle(self.month == month ? .pink : .secondary)
                            
                        
                    }

                }
            }
        }
        .foregroundStyle(.secondary)
        
    }
}

struct MonthDataChartView : View {
    
    @Binding var stats : [DeltaStats]
    @Binding  var selectedMonth : Month
    @State var minutesListened : Int = 0
    @State var playCounts : Int = 0
    
    var body: some View {
        Group {
            if (stats.count == 0) {
                Text("No listening data for \(selectedMonth.fullMonthName).")
                    .font(.system(.title,weight: .bold))
                    .foregroundStyle(.secondary)
            } else {
                Group {
                VStack(alignment: .leading,spacing: 15) {
                    
                    VStack {
                        HStack(alignment: .bottom) {
                           
                                Group {
                                    VStack(alignment: .leading) {
                                        Text("\(minutesListened)")
                                            .foregroundStyle(.pink)
                                        Text("minutes listened in \(selectedMonth.fullMonthName).")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .font(.system(.largeTitle,weight: .bold))
                                
                                    
                            
                            Spacer()
                        }
                    }
                    
                    Text("Minutes listened over the month ")
                        .font(.system(.title3,weight: .regular))
                        .foregroundStyle(.secondary)
                    
                    Chart( stats)  { item in
                        BarMark(x: .value("Time", item.date, unit: .day), y: .value("listens", item.minutesListened))
                        
                            .foregroundStyle(Color.pink)
                        
                            .lineStyle(StrokeStyle(lineWidth: 2))
                        
                       
                    }
                    
                    .frame(minHeight: 300)
                    
                }
                    VStack(alignment: .leading,spacing: 15) {
                        
                        VStack {
                            HStack(alignment: .bottom) {
                                
                                Group {
                                    VStack(alignment: .leading) {
                                        Text("\(playCounts )")
                                            .foregroundStyle(.pink)
                                        Text("songs played in \(selectedMonth.fullMonthName).")
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    .font(.system(.largeTitle,weight: .bold))
                                    
                                    
                                }
                                Spacer()
                            }
                        }
                        
                        Text("Songs played over the month")
                            .font(.system(.title3,weight: .regular))
                            .foregroundStyle(.secondary)
                        
                        Chart(stats)  { item in
                            BarMark(x: .value("Time", item.date, unit: .day), y: .value("playCount", item.playCount))
                            
                                .foregroundStyle(Color.pink)
                            
                                .lineStyle(StrokeStyle(lineWidth: 2))
                            
                        

                        }
                        
                        .frame(minHeight: 300)
                        
                        
                    }
                    }
                
                .task(priority: .high, {
                    playCounts = 0
                    minutesListened = 0
                    stats.forEach { stat in
                        playCounts = playCounts + stat.playCount
                        minutesListened = minutesListened + stat.minutesListened
                    }
                })
                
                   
                }
            }
        
    }
}

struct InsightsView: View {

   
    
    var currentYear = Calendar.current.startOfDay(for: .now).startOfYear
    
    
   
    @State var selectedMonth : Month = Date.now.numberAsMonth
    @State var selectedYear : Date = Date.now.startOfYear

    var timeframes : [TimeFrame] = [.day,.week,.month,.year]
    @State var selected : TimeFrame = .day
    @State var loaded = false
    @Environment(LibraryData.self) private var libraryData
    @Environment(MusicPlayer.self) private var musicPlayer
    
    @State var deltaStats : [DeltaStats] = []
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 45) {
                    
                    HStack(alignment: .bottom,spacing: 20) {
                        YearSelectorView(year: $selectedYear)
                        
                        MonthSelectorView(month: $selectedMonth)
                    }
                    
                    
                    
                    VStack(spacing: 40) {
                      
                            
                               
                            MonthDataChartView(stats: $deltaStats, selectedMonth: $selectedMonth)
                            
                    
                        
                    }
                }
                .padding()
                .padding(.bottom, musicPlayer.currentlyPlayingSong == nil ? 0 : 55)
              
            }
            .scrollIndicators(.hidden)
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
            .navigationTitle("Insights")
            .onChange(of: selectedMonth, { old, new in
                self.deltaStats = self.libraryData.realm.objects(DeltaStats.self).filter({$0.date.yearAsNumber == selectedYear.yearAsNumber && $0.date.monthAsNumber == selectedMonth.monthNumber})
            })
            .onChange(of: selectedYear, { old, new in
                self.deltaStats = self.libraryData.realm.objects(DeltaStats.self).filter({$0.date.yearAsNumber == selectedYear.yearAsNumber && $0.date.monthAsNumber == selectedMonth.monthNumber})
            })
           
            
            .task(priority: .high, {
                self.deltaStats = self.libraryData.realm.objects(DeltaStats.self).filter({$0.date.yearAsNumber == selectedYear.yearAsNumber && $0.date.monthAsNumber == selectedMonth.monthNumber}).sorted(by: { one, two in
                    one.date < two.date
                })
                
                
                
            })
        }
    }
}




extension Date {
    
   
    
 
    var month : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLL"
        
        return dateFormatter.string(from: self)
    }
    
    var week: String {
        let sowdateFormatter = DateFormatter()
        sowdateFormatter.dateFormat = "MMMM d"
        
        let eowdateFormatter = DateFormatter()
        eowdateFormatter.dateFormat = "d"
        
        return  sowdateFormatter.string(from: Date.now.startOfWeek) + "-" + eowdateFormatter.string(from: Date.now.endOfWeek) + ", " + Date.now.year
        
    }
    var yearAsNumber: Int {

        let components = Calendar.current.dateComponents([.year], from: self)
        
        return components.year!
    }
    
    var numberAsMonth: Month {
        switch (self.monthAsNumber) {
        case 1:
            return .January
        case 2:
            return .February
        case 3:
            return .March
        case 4:
            return .April
        case 5:
            return .May
            
        case 6:
            return .June
            
        case 7:
            return .July
        case 8:
            return .August
        case 9:
            return .September
        case 10:
            return .October
        case 11:
            return .November
        case 12:
            return .December
        default:
            return .January
        }
    }
    
    
    var monthAsNumber : Int {
        let components = Calendar.current.dateComponents([.month], from: self)
        
        return components.month!
    }
    var year : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return  dateFormatter.string(from: self)
    }
    
    var day : String {
        return Calendar.current.startOfDay(for: .now).formatted(date: .complete, time: .omitted)
    }
    
    
    
    var startOfDay : Date {
       
           return Calendar.current.startOfDay(for: self)
    }
    
    var startOfYear: Date {
        let components = Calendar.current.dateComponents([.year], from: self)
           return Calendar.current.date(from: components)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
           return Calendar.current.date(from: components)!
       }

       var endOfMonth: Date {
           var components = DateComponents()
           components.month = 1
           components.second = -1
           return Calendar.current.date(byAdding: components, to: startOfMonth)!
       }
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfWeek: Date {
          Calendar.current.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
      }
      
      var endOfWeek: Date {
          var components = DateComponents()
          components.weekOfYear = 1
          components.second = -1
          return Calendar.current.date(byAdding: components, to: startOfWeek)!
      }
    
    var startOfHour : Date {
       
        Calendar.current.dateComponents([.calendar, .minute, .year, .month, .day, .hour], from: self).date!
    }
  
}

extension MusicItemCollection<Song> {
    
    func filterByTime(date: Date, dateComponent: Calendar.Component) -> ([Date : Int], Int)  {
        
        var dictionary: [Date : Int] = [:]
       let filteredSongs = self.filter({ song in
             if let songDate = song.libraryAddedDate {
             
         
                 
                 if (Calendar.current.compare(date, to: songDate, toGranularity: dateComponent) == .orderedSame) {
                     
                     switch dateComponent {
                     case .weekOfYear:
                         dictionary[songDate.startOfDay] =  (dictionary[songDate.startOfDay] ?? 0) + 1
                     case .month:
                         dictionary[songDate.startOfDay] =  (dictionary[songDate.startOfDay] ?? 0) + 1
                     case .year:
                         dictionary[songDate.startOfMonth] =  (dictionary[songDate.startOfMonth] ?? 0) + 1
                     default:
                      
                         dictionary[songDate.startOfHour] =  (dictionary[songDate.startOfHour] ?? 0) + 1
                       
                     }
                    
                   
                     return true
                 } else {
                     return false;
                 }
             } else {
                 return false;
             }
        })
        
       
        return (dictionary, filteredSongs.count)
    }
    
}

extension MusicItemCollection<Artist> {
    
    func filterByTime(date: Date, dateComponent: Calendar.Component) -> ([Date : Int], Int)   {
        
        var dictionary: [Date : Int] = [:]
       let filteredArtists = self.filter({ artist in
             if let artistDate = artist.libraryAddedDate {
             
         
                 
                 if (Calendar.current.compare(date, to: artistDate, toGranularity: dateComponent) == .orderedSame) {
                
                     switch dateComponent {
                     case .weekOfYear:
                         dictionary[artistDate.startOfDay] =  (dictionary[artistDate.startOfDay] ?? 0) + 1
                     case .month:
                         dictionary[artistDate.startOfDay] =  (dictionary[artistDate.startOfDay] ?? 0) + 1
                     case .year:
                         dictionary[artistDate.startOfMonth] =  (dictionary[artistDate.startOfMonth] ?? 0) + 1
                     default:
                         dictionary[artistDate.startOfHour] =  (dictionary[artistDate.startOfHour] ?? 0) + 1
                     }
                     
                  
                     return true
                 } else {
                     return false;
                 }
             } else {
                 return false;
             }
        })
        
        return (dictionary, filteredArtists.count)
    }
    
}

extension MusicItemCollection<Album> {
    
    func filterByTime(date: Date, dateComponent: Calendar.Component) -> ([Date : Int], Int) {
    
        var dictionary: [Date : Int] = [:]
       let filteredAlbums = self.filter({ album in
             if let albumDate = album.libraryAddedDate {
             
         
                 
                 if (Calendar.current.compare(date, to: albumDate, toGranularity: dateComponent) == .orderedSame) {
                     switch dateComponent {
                     case .weekOfYear:
                         dictionary[albumDate.startOfDay] =  (dictionary[albumDate.startOfDay] ?? 0) + 1
                     case .month:
                         dictionary[albumDate.startOfDay] =  (dictionary[albumDate.startOfDay] ?? 0) + 1
                     case .year:
                         dictionary[albumDate.startOfMonth] =  (dictionary[albumDate.startOfMonth] ?? 0) + 1
                     default:
                         dictionary[albumDate.startOfHour] =  (dictionary[albumDate.startOfHour] ?? 0) + 1
                     }
                     return true
                 } else {
                     return false;
                 }
             } else {
                 return false;
             }
        })
        
        return (dictionary, filteredAlbums.count)
    }
    
}


