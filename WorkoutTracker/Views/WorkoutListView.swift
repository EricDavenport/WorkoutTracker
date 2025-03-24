import SwiftUI

struct WorkoutListView: View {
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    @State private var showingNewWorkout = false
    
    var body: some View {
        NavigationView {
            List {
                if let currentSession = workoutViewModel.currentSession {
                    Section("Current Workout") {
                        CurrentWorkoutCard(session: currentSession)
                    }
                }
                
                Section("Quick Start") {
                    Button(action: { showingNewWorkout = true }) {
                        Label("Start New Workout", systemImage: "plus.circle.fill")
                    }
                }
                
                Section("Recent Workouts") {
                    ForEach(workoutViewModel.workoutHistory.prefix(5)) { session in
                        WorkoutHistoryRow(session: session)
                    }
                }
            }
            .navigationTitle("Workouts")
            .sheet(isPresented: $showingNewWorkout) {
                NewWorkoutView()
            }
        }
    }
}

struct CurrentWorkoutCard: View {
    @ObservedObject var session: WorkoutSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("In Progress")
                .font(.headline)
                .foregroundColor(.green)
            
            Text("Duration: \(formatDuration(session.duration))")
            
            if let calories = session.caloriesBurned {
                Text("Calories: \(Int(calories))")
            }
            
            if let heartRate = session.averageHeartRate {
                Text("Avg HR: \(Int(heartRate)) BPM")
            }
            
            Text("Exercises: \(session.exercises.count)")
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "00:00:00"
    }
} 