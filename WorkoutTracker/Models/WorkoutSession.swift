import Foundation
import HealthKit

class WorkoutSession: Identifiable, ObservableObject {
    let id: UUID
    @Published var startTime: Date
    @Published var endTime: Date?
    @Published var exercises: [Exercise]
    @Published var caloriesBurned: Double?
    @Published var averageHeartRate: Double?
    @Published var status: WorkoutStatus
    
    init(
        id: UUID = UUID(),
        startTime: Date = Date(),
        endTime: Date? = nil,
        exercises: [Exercise] = [],
        caloriesBurned: Double? = nil,
        averageHeartRate: Double? = nil,
        status: WorkoutStatus = .notStarted
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.exercises = exercises
        self.caloriesBurned = caloriesBurned
        self.averageHeartRate = averageHeartRate
        self.status = status
    }
    
    var duration: TimeInterval {
        guard let endTime = endTime else {
            return Date().timeIntervalSince(startTime)
        }
        return endTime.timeIntervalSince(startTime)
    }
}

enum WorkoutStatus: String, Codable {
    case notStarted
    case inProgress
    case completed
    case paused
} 