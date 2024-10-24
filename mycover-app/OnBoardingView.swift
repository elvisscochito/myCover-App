import SwiftUI

struct OnBoardingView: View {
    
    @State private var isOnBoardingFinish = false
    @State private var currentPageIndex = 0
    
    private let pages: [PageModel] = PageModel.samplePages
    
    var body: some View {
        ZStack {
            if isOnBoardingFinish {
                Home()
            } else {
                VStack{
                    
                    TabView(selection: $currentPageIndex) {
                        ForEach(pages.indices, id: \.self) { index in
                            PageView(page: pages[index])
                                .tag(index)
                        }
                    }
                    
                    .animation(.easeInOut, value: currentPageIndex)
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    .onAppear {
                        UIPageControl.appearance().currentPageIndicatorTintColor = .white
                        UIPageControl.appearance().pageIndicatorTintColor = .gray
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            if currentPageIndex < pages.count - 1 {
                                withAnimation{
                                    currentPageIndex += 1
                                }
                            } else {
                                withAnimation{
                                    isOnBoardingFinish = true
                                }
                            }
                        }) {
                            if (currentPageIndex < pages.count - 1) {
                                Text("Next")
                                Image(systemName: "arrow.forward")
                            } else {
                                Text("Start")
                                Image(systemName: "arrow.right.circle.fill")
                            }
//                            Image(systemName: currentPageIndex < pages.count - 1 ? "arrow.forward" : "arrow.right.circle.fill")
                        }
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .font(.title3)
                    }
                    .padding()
                }
            }
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    OnBoardingView()
}
