import SwiftUI
import Charts

struct WorkoutDetailView: View {
    let session: WorkoutSession
    @State private var selectedExercise: Exercise?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Summary Card
                SummaryCard(session: session)
                
                // Heart Rate Chart (if available)
                if session.averageHeartRate != nil {
                    HeartRateSection(session: session)
                }
                
                // Exercises List
                ExercisesSection(exercises: session.exercises) { exercise in
                    selectedExercise = exercise
                }
            }
            .padding()
        }
        .navigationTitle(sessionTitle)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedExercise) { exercise in
            ExerciseDetailView(exercise: exercise)
        }
    }
    
    private var sessionTitle: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: session.startTime)
    }
}

// MARK: - Supporting Views

private struct SummaryCard: View {
    let session: WorkoutSession
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                StatItem(
                    title: "Duration",
                    value: formatDuration(session.duration),
                    icon: "clock.fill"
                )
                
                Divider()
                
                StatItem(
                    title: "Calories",
                    value: "\(Int(session.caloriesBurned ?? 0))",
                    icon: "flame.fill"
                )
                
                if let heartRate = session.averageHeartRate {
                    Divider()
                    
                    StatItem(
                        title: "Avg HR",
                        value: "\(Int(heartRate)) BPM",
                        icon: "heart.fill"
                    )
                }
            }
            
            Divider()
            
            HStack {
                Label("\(session.exercises.count) Exercises", systemImage: "figure.strengthtraining.traditional")
                Spacer()
                Label("\(totalSets) Sets", systemImage: "number.circle.fill")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var totalSets: Int {
        session.exercises.reduce(0) { $0 + $1.sets.count }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "0m"
    }
}

private struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct HeartRateSection: View {
    let session: WorkoutSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Heart Rate")
                .font(.headline)
            
            // Placeholder for actual heart rate data chart
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(height: 200)
                .overlay(
                    Text("Heart Rate Chart")
                        .foregroundColor(.secondary)
                )
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

private struct ExercisesSection: View {
    let exercises: [Exercise]
    let onExerciseTap: (Exercise) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Exercises")
                .font(.headline)
            
            ForEach(exercises) { exercise in
                ExerciseCard(exercise: exercise)
                    .onTapGesture {
                        onExerciseTap(exercise)
                    }
            }
        }
    }
}

private struct ExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.name)
                .font(.headline)
            
            Text(exercise.category.rawValue.capitalized)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Divider()
            
            ForEach(exercise.sets) { set in
                HStack {
                    Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(set.isCompleted ? .green : .secondary)
                    
                    Text("\(set.reps) reps")
                    Text("×")
                    Text("\(Int(set.weight))kg")
                    
                    if let timestamp = set.timestamp {
                        Spacer()
                        Text(timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Exercise Detail Sheet
private struct ExerciseDetailView: View {
    let exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Details") {
                    LabeledContent("Category", value: exercise.category.rawValue.capitalized)
                    LabeledContent("Muscle Groups") {
                        Text(exercise.muscleGroups.map { $0.rawValue.capitalized }.joined(separator: ", "))
                    }
                    LabeledContent("Rest Period", value: "\(exercise.restPeriodSeconds)s")
                }
                
                Section("Sets") {
                    ForEach(exercise.sets) { set in
                        HStack {
                            Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(set.isCompleted ? .green : .secondary)
                            
                            VStack(alignment: .leading) {
                                Text("\(set.reps) reps × \(Int(set.weight))kg")
                                if let timestamp = set.timestamp {
                                    Text(timestamp, style: .time)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                if let notes = exercise.notes {
                    Section("Notes") {
                        Text(notes)
                    }
                }
            }
            .navigationTitle(exercise.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 

#Preview {
    WorkoutDetailView(session: WorkoutSession(
        startTime: Date().addingTimeInterval(-3600), // 1 hour ago
        endTime: Date(),
        exercises: [
            Exercise(
                name: "Bench Press",
                category: .strength,
                muscleGroups: [.chest, .shoulders],
                sets: [
                    ExerciseSet(reps: 10, weight: 60, isCompleted: true, timestamp: Date().addingTimeInterval(-3300)),
                    ExerciseSet(reps: 10, weight: 65, isCompleted: true, timestamp: Date().addingTimeInterval(-3000)),
                    ExerciseSet(reps: 8, weight: 70, isCompleted: true, timestamp: Date().addingTimeInterval(-2700))
                ]
            ),
            Exercise(
                name: "Pull-ups",
                category: .strength,
                muscleGroups: [.back, .arms],
                sets: [
                    ExerciseSet(reps: 12, weight: 0, isCompleted: true, timestamp: Date().addingTimeInterval(-2400)),
                    ExerciseSet(reps: 10, weight: 0, isCompleted: true, timestamp: Date().addingTimeInterval(-2100))
                ]
            )
        ],
        caloriesBurned: 245.0,
        averageHeartRate: 142.0,
        status: .completed
    ))
}
