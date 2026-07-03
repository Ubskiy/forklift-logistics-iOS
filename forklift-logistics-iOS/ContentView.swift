import SwiftUI

struct ContentView: View {
    @State private var viewModel: DashboardViewModel

    init() {
        let httpClient = URLSessionHTTPClient()
        let repository = LogisticsRepository(httpClient: httpClient)
        let useCase = CompareStrategiesUseCase(repository: repository)
        _viewModel = State(initialValue: DashboardViewModel(compareUseCase: useCase))
    }

    var body: some View {
        MainTabView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
