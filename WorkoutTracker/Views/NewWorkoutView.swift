import SwiftUI

struct NewWorkoutView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    @State private var selectedExercises: [Exercise] = []
    @State private var showingExercisePicker = false
    @State private var workoutName = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Workout Name", text: $workoutName)
                }
                
                Section("Exercises") {
                    ForEach(selectedExercises) { exercise in
                        ExerciseRow(exercise: exercise)
                            .swipeActions {
                                Button(role: .destructive) {
                                    if let index = selectedExercises.firstIndex(where: { $0.id == exercise.id }) {
                                        selectedExercises.remove(at: index)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    
                    Button(action: { showingExercisePicker = true }) {
                        Label("Add Exercise", systemImage: "plus")
                    }
                }
                
                if !selectedExercises.isEmpty {
                    Section("Summary") {
                        Text("\(selectedExercises.count) exercises selected")
                        Text("Estimated time: \(estimatedTime) min")
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
                        startWorkout()
                        dismiss()
                    }
                    .disabled(selectedExercises.isEmpty)
                }
            }
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView(selectedExercises: $selectedExercises)
            }
        }
    }
    
    private var estimatedTime: Int {
        selectedExercises.reduce(0) { total, exercise in
            // Estimate 2 minutes per set plus rest time
            let setTime = exercise.sets.isEmpty ? 2 : exercise.sets.count * 2
            return total + setTime + (exercise.restPeriodSeconds / 60)
        }
    }
    
    private func startWorkout() {
        let session = WorkoutSession(
            startTime: Date(),
            exercises: selectedExercises,
            status: .inProgress
        )
        workoutViewModel.currentSession = session
    }
}

struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedExercises: [Exercise]
    @State private var searchText = ""
    
    // Sample exercises - In a real app, this would come from a database or API
    let availableExercises: [Exercise] = [
        Exercise(name: "Bench Press", category: .strength, muscleGroups: [.chest, .shoulders]),
        Exercise(name: "Squats", category: .strength, muscleGroups: [.legs]),
        Exercise(name: "Pull-ups", category: .strength, muscleGroups: [.back, .arms]),
        // Add more exercises as needed
    ]
    
    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return availableExercises
        }
        return availableExercises.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredExercises) { exercise in
                    ExerciseRow(exercise: exercise)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if !selectedExercises.contains(where: { $0.id == exercise.id }) {
                                selectedExercises.append(exercise)
                            }
                        }
                }
            }
            .searchable(text: $searchText, prompt: "Search exercises")
            .navigationTitle("Add Exercise")
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

#Preview {
    NewWorkoutView()
}
