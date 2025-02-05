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
//                            .frame(width: 10, height: 10)
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
                if clickedDate != date { NumberView(date: date, color: .gray) }
                else { NumberView(date: date, color: .red) }
            } else {
                NumberView(date: date, color: .gray)
            }
        }
    }
}

private struct NumberView: View {
    var date: Date
    var color : Color = .blue
    init(date: Date, color: Color) {
        self.date = date
        self.color = color
    }
    var body: some View {
            RoundedRectangle(cornerRadius: 5)
            .padding(15)
                .opacity(0)
                .overlay(Text(date.formatted(
                    Date.FormatStyle()
                        .day()
                )))
                .foregroundColor(color)
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

//#Preview {
//    
//    CalenderBodyView(group: Group(name: "ya", missionTitle: ["1","2"], memberCount: 2, category: "study"), month: Date())
//}
