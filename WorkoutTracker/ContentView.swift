import SwiftUI

struct ContentView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    
    var body: some View {
        TabView {
            WorkoutListView()
                .tabItem {
                    Label("Workouts", systemImage: "figure.run")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person")
//                }
        }
        .environmentObject(workoutViewModel)
    }
} 

#Preview {
    ContentView()
}
