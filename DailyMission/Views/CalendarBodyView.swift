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
    var group : Group
    @Query private var missions: [Mission]
    @State var month: Date
    @State var offset: CGSize = CGSize()
    @Binding var clickedDate: Date?
    
    var body: some View {
        
        VStack {
            headerView
            calendarGridView
        }
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
    
    // MARK: - 헤더 뷰
    private var headerView: some View {
        VStack {
            Text(month, formatter: Self.dateFormatter)
                .font(.title)
                .padding(.bottom)
            
            HStack {
                ForEach(Self.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .frame(maxWidth: .infinity)
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
                        let clicked = (clickedDate != nil) ? true : false
                        
                        CellView(date: date, clicked: clicked, clickedDate: clickedDate)
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
}

// MARK: - 일자 셀 뷰
private struct CellView: View {
    var date: Date
    var clicked: Bool = false
    var clickedDate: Date?
    init(date: Date, clicked: Bool, clickedDate: Date?) {
        self.date = date
        self.clicked = clicked
        self.clickedDate = clickedDate
    }
    
    var body: some View {
        VStack {
            if clickedDate != nil {
                if clickedDate != date { NumberView(date: date, colorFore: .gray, colorBack: .clear) }
                else { NumberView(date: date, colorFore: .red, colorBack: .yellow) }
            } else {
                if date.isSameDate(date: Date.now) { NumberView(date: date, colorFore: .red, colorBack: .gray) }
                NumberView(date: date, colorFore: .gray, colorBack: .clear)
            }
        }
    }
}

private struct NumberView: View {
    var date: Date
    var colorFore : Color = .blue
    var colorBack : Color = .clear
    init(date: Date, colorFore: Color, colorBack: Color) {
        self.date = date
        self.colorFore = colorFore
        self.colorBack = colorBack
    }
    var body: some View {
        Circle()
            .padding(15)
                .opacity(0)
                .overlay(Text(date.formatted(
                    Date.FormatStyle()
                        .day()
                )))
                .foregroundColor(colorFore)
                .backgroundStyle(colorBack.opacity(0.2))
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
