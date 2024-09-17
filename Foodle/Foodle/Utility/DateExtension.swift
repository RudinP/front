
import Foundation

extension Date{
    mutating func setTime(_ to: Date){
        var calendar = Calendar.current

        // 날짜 구성 요소 가져오기
        var dateComponentsFrom = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        var dateComponentsTo = calendar.dateComponents([.hour, .minute], from: to)
        // 새로운 시간 설정 (예: 15시 30분 0초)
        dateComponentsFrom.hour = dateComponentsTo.hour
        dateComponentsFrom.minute = dateComponentsTo.minute
        
        if let date = calendar.date(from: dateComponentsFrom){
            self = date
        }
    }
    
    func nextHour() -> Date?{
        var calendar = Calendar.current

        // 날짜 구성 요소 가져오기
        var dateComponentsFrom = calendar.dateComponents([.hour, .minute], from: self)
        guard let to = Calendar.current.date(byAdding: .hour, value: 1, to: self) else {return nil}
        var dateComponentsTo = calendar.dateComponents([.hour, .minute], from: to)
        // 새로운 시간 설정 (예: 15시 30분 0초)
        dateComponentsFrom.hour = dateComponentsTo.hour
        dateComponentsFrom.minute = 0
        
        guard let date = calendar.date(from: dateComponentsFrom) else { return nil}
         
        return date
    }
}
