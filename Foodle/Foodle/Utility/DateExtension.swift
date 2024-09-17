
import Foundation

extension Date{
    mutating func setTime(_ to: Date){
        let calendar = Calendar.current
        
        // 날짜 구성 요소 가져오기
        var dateComponentsFrom = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        let dateComponentsTo = calendar.dateComponents([.hour, .minute], from: to)
        // 새로운 시간 설정 (예: 15시 30분 0초)
        dateComponentsFrom.hour = dateComponentsTo.hour
        dateComponentsFrom.minute = dateComponentsTo.minute
        
        if let date = calendar.date(from: dateComponentsFrom){
            self = date
        }
    }
    
    func adding(hours: Int) -> Date {
        Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
}
