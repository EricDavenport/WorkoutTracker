import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    @State private var selectedExercises: [Exercise] = []
    
    var body: some View {
        NavigationView {
            List {
                Section("Exercises") {
                    ForEach(selectedExercises) { exercise in
                        ExerciseRow(exercise: exercise)
                    }
                    
                    Button(action: { /* Show exercise picker */ }) {
                        Label("Add Exercise", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("New Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        workoutViewModel.startNewWorkout()
                        dismiss()
                    }
                    .disabled(selectedExercises.isEmpty)
                }
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.name)
                .font(.headline)
            Text(exercise.category.rawValue.capitalized)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
} 