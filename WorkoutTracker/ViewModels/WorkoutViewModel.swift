import Foundation
import Combine
import HealthKit

class WorkoutViewModel: ObservableObject {
    @Published var currentSession: WorkoutSession?
    @Published var workoutHistory: [WorkoutSession] = []
    private var healthStore: HKHealthStore?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupHealthKit()
    }
    
    private func setupHealthKit() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestHealthKitPermissions()
        }
    }
    
    private func requestHealthKitPermissions() {
        guard let healthStore = healthStore else { return }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        let typesToWrite: Set<HKSampleType> = [
            HKObjectType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { success, error in
            if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    func startNewWorkout() {
        currentSession = WorkoutSession(status: .inProgress)
    }
    
    func endCurrentWorkout() {
        guard var session = currentSession else { return }
        session.endTime = Date()
        session.status = .completed
        workoutHistory.append(session)
        currentSession = nil
    }
} 