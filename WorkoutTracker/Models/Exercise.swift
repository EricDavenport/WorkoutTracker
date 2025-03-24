import Foundation

struct Exercise: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ExerciseCategory
    var muscleGroups: Set<MuscleGroup>
    var sets: [ExerciseSet]
    var notes: String?
    var restPeriodSeconds: Int
    
    init(
        id: UUID = UUID(),
        name: String,
        category: ExerciseCategory,
        muscleGroups: Set<MuscleGroup> = [],
        sets: [ExerciseSet] = [],
        notes: String? = nil,
        restPeriodSeconds: Int = 90
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.muscleGroups = muscleGroups
        self.sets = sets
        self.notes = notes
        self.restPeriodSeconds = restPeriodSeconds
    }
}

struct ExerciseSet: Identifiable, Codable {
    let id: UUID
    var reps: Int
    var weight: Double
    var isCompleted: Bool
    var timestamp: Date?
    
    init(id: UUID = UUID(), reps: Int, weight: Double, isCompleted: Bool = false, timestamp: Date? = nil) {
        self.id = id
        self.reps = reps
        self.weight = weight
        self.isCompleted = isCompleted
        self.timestamp = timestamp
    }
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case strength
    case cardio
    case flexibility
    case hiit
}

enum MuscleGroup: String, Codable, CaseIterable {
    case chest
    case back
    case legs
    case shoulders
    case arms
    case core
} 