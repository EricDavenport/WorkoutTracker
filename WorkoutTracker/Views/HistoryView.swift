import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var workoutViewModel: WorkoutViewModel
    @State private var selectedFilter: HistoryFilter = .all
    
    enum HistoryFilter {
        case all, week, month
    }
    
    var body: some View {
        NavigationView {
            List {
                Picker("Filter", selection: $selectedFilter) {
                    Text("All").tag(HistoryFilter.all)
                    Text("This Week").tag(HistoryFilter.week)
                    Text("This Month").tag(HistoryFilter.month)
                }
                .pickerStyle(.segmented)
                .listRowInsets(EdgeInsets())
                .padding()
                
                ForEach(filteredWorkouts) { session in
                    NavigationLink {
                        WorkoutDetailView(session: session)
                    } label: {
                        WorkoutHistoryRow(session: session)
                    }
                }
            }
            .navigationTitle("History")
        }
    }
    
    private var filteredWorkouts: [WorkoutSession] {
        switch selectedFilter {
        case .all:
            return workoutViewModel.workoutHistory
        case .week:
            return workoutViewModel.workoutHistory.filter {
                Calendar.current.isDate($0.startTime, equalTo: Date(), toGranularity: .weekOfYear)
            }
        case .month:
            return workoutViewModel.workoutHistory.filter {
                Calendar.current.isDate($0.startTime, equalTo: Date(), toGranularity: .month)
            }
        }
    }
}

struct WorkoutHistoryRow: View {
    let session: WorkoutSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(session.startTime, style: .date)
                .font(.headline)
            
            Text("\(session.exercises.count) exercises")
                .foregroundColor(.secondary)
            
            if let calories = session.caloriesBurned {
                Text("\(Int(calories)) calories")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 