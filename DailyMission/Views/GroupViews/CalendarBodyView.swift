//
//  CalenderView.swift
//  DailyMission
//
//  Created by 최하진 on 2/4/25.
//

import SwiftUI
import SwiftData

struct CalenderBodyView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var missions: [Mission]
    
    var group : Group
    var groupColor : Color
    var groupMission : [Mission]
    
    @State var month: Date = Date()
    @State var offset: CGSize = CGSize()
    @Binding var clickedDate: Date?
    
    var user : User
    var body: some View {
        
        VStack {
            headerView
            calendarGridView
        }
        .onAppear(perform: {
            clickedDate = Date.now
//            updateMissionsDateStamp()
        })
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                }
                .onEnded { gesture in
                    if gesture.translation.width < -100 {
                        changeMonth(by: 1)
                    } else if gesture.translation.width > 100 {
                        changeMonth(by: -1)
                    }
                    self.offset = CGSize()
                }
        )
    }
//    private func updateMissionsDateStamp() {
//            for mission in groupMission {
//                if let userStamp = mission.userStamp?.first(where: { $0.userId == user.id }) {
//                    if userStamp.dateStamp.isEmpty {
//                        print("Mission: \(mission.title) has empty dateStamp. Adding clickedDate...")
//                        userStamp.dateStamp.append(DateStamp(date: clickedDate ?? Date(), isCompleted: false))
//                        
//                        do {
//                            try modelContext.save()
//                            print("Successfully added default dateStamp.")
//                        } catch {
//                            print("Failed to save dateStamp: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
//        }
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            HStack {
                Button(action: {
                    changeMonth(by: -1)
                }) {
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundStyle(groupColor)
                }
                Text(month, formatter: Self.dateFormatter)
                    .font(.body)
                Button(action: {
                    changeMonth(by: 1)
                }) {
                    Image(systemName: "arrowtriangle.right.fill")
                        .foregroundStyle(groupColor)
                }
            }
            .padding(.bottom, 5)
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                        if symbol == "S" {
                            Text(symbol)
                                .frame(maxWidth: .infinity)
                            .foregroundStyle(.red)
                        } else {
                            Text(symbol)
                                .frame(maxWidth: .infinity)
                        }
                }
            }
            .padding(.bottom, 10)
        }
    }
    
    // MARK: - 날짜 그리드 뷰
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        
        return VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 5) {
                ForEach(0 ..< daysInMonth + firstWeekday, id: \.self) { index in
                    if index < firstWeekday {
                        RoundedRectangle(cornerRadius: 5)
                            .padding(15)
                            .foregroundColor(Color.clear)
                    } else {
                        let date = getDate(for: index - firstWeekday)
//                        let day = index - firstWeekday + 1
                        let _ = (clickedDate != nil) ? true : false
                        let completedRatio = completedRatio(user, groupMission, date)
                        CellView(date, clickedDate, groupColor, completedRatio, groupMission, user)
                            .onTapGesture {
                                if clickedDate != nil {
                                    clickedDate = (clickedDate == date) ? nil : date
                                } else {
                                    clickedDate = date
                                }
                            }

                    }
                }
            }
        }
    }
    
    private func completedRatio(_ user: User, _ missions: [Mission], _ date: Date) -> Double {

        var completedCount: Double = 0.0
            var dateMissionCount: Double = 0.0
            var dateStamp: [DateStamp]
            
            for mission in missions {
                if let index = mission.userStamp?.firstIndex(where: { $0.userId == user.id }) {
                    dateStamp = mission.userStamp?[index].dateStamp ?? []
                    if !dateStamp.contains(where: { $0.date.isSameDate(date: date) }) {
                        mission.userStamp?[index].dateStamp.append(DateStamp(date: date, isCompleted: false))
                        try? modelContext.save()
                    }
                    if let index2 = dateStamp.firstIndex(where: { $0.date.isSameDate(date: date) }) {
                        dateMissionCount += 1
                        if dateStamp[index2].isCompleted {
                            completedCount += 1
                        }
                    }
                }
            }
            return dateMissionCount > 0 ? (completedCount / dateMissionCount) : 0.0
        }
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var date: Date
    var clickedDate: Date?
    var groupColor: Color
    var completedRatio : Double
    var mission : [Mission]
    var user : User
    
    init(_ date: Date, _ clickedDate: Date?, _ groupColor: Color, _ completedRatio : Double, _ mission: [Mission], _ user: User) {
        self.date = date
        self.clickedDate = clickedDate
        self.groupColor = groupColor
        self.completedRatio = completedRatio
        self.mission = mission
        self.user = user
    }
    
    var body: some View {
        VStack {
            if clickedDate != nil {
                if clickedDate != date && !date.isSameDate(date: Date.now)  {
                    NumberView(date: date, colorFore: .gray, colorBack: .clear, completedRatio: completedRatio, mission: mission, user: user)
                } else if clickedDate != date && date.isSameDate(date: Date.now) {
                    NumberView(date: date, colorFore: .gray, colorBack: .gray, completedRatio: completedRatio, mission: mission, user: user)
                }else { NumberView(date: date, colorFore: groupColor, colorBack: groupColor, completedRatio: completedRatio, mission: mission, user: user) }
            } else {
                if date.isSameDate(date: Date.now) { NumberView(date: date, colorFore: .gray, colorBack: .gray, completedRatio: completedRatio, mission: mission, user: user) }
                else { NumberView(date: date, colorFore: .gray, colorBack: .clear, completedRatio: completedRatio, mission: mission, user: user) }
            }
        }
    }
}

private struct NumberView: View {
    var date: Date
    var colorFore : Color
    var colorBack : Color
    var completedRatio : Double
    var mission : [Mission]
    var user : User
    init(date: Date, colorFore: Color, colorBack: Color, completedRatio : Double, mission: [Mission], user: User) {
        self.date = date
        self.colorFore = colorFore
        self.colorBack = colorBack
        self.completedRatio = completedRatio
        self.mission = mission
        self.user = user
    }
    var body: some View {
        VStack{
            Circle()
                .fill(colorBack.opacity(0.2))
                .frame(width: 25, height: 25)
                .padding(5)
                .overlay(Text(date.formatted(
                    Date.FormatStyle()
                        .day()
                )))
                .foregroundColor(colorFore)
            if mission.first(where: { $0.userStamp?.first(where: { $0.userId == user.id && $0.dateStamp.first(where: { $0.date.onlyDate == date.onlyDate }) != nil })  != nil}) != nil  {
                if completedRatio == 1 {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                } else if completedRatio == 0 {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 8, height: 8)
                } else {
                    Circle()
                        .fill(Color.red.opacity(completedRatio))
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

// MARK: - 내부 메서드
private extension CalenderBodyView {
    
    
    /// 특정 해당 날짜
    private func getDate(for day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    /// 해당 월의 시작 날짜
    func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 해당 월에 존재하는 일자 수
    func numberOfDays(in date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 해당 월의 첫 날짜가 갖는 해당 주의 몇번째 요일
    func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    /// 월 변경
    func changeMonth(by value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
}

// MARK: - Static 프로퍼티
extension CalenderBodyView {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    static let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
}

extension Date {
    private func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
    
    func isSameDate(date: Date) -> Bool {
        self.startOfDay() == date.startOfDay()
    }
}

//#Preview {
//    
//    CalenderBodyView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
