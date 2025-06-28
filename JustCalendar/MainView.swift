//
//  MainView.swift
//  JustCalendar
//
//  Created by yeri on 1/30/25.
//

import SwiftUI

// MARK: - 아이콘 정보
struct AppIcon: Identifiable {
    let id = UUID()
    let index: Int
    var name: String {
        "App \(index)"
    }
    let type: String
    let image: String
}

enum AppIconType: CaseIterable {
    case type1
    case type2
    case type3
    case type4
    
    case theme
    case FirstDay
    case lunarDay
    case faq
    
    case addEvent
    
    var name: String {
        switch self {
        case .type1:
            return "type1"
        case .type2:
            return "type2"
        case .type3:
            return "type3"
        case .type4:
            return "type4"
            
        case .theme:
            return "테마색"
        case .FirstDay:
            return "첫번째 요일"
        case .lunarDay:
            return "음력"
        case .faq:
            return "FAQ"
            
        case .addEvent:
            return "일정 추가"
        }
    }
    
    var image: String {
        switch self {
        case .type1, .type2, .type3, .type4:
            return "imgNothing"
            
        case .theme:
            return "imgDockIcon1"
        case .FirstDay:
            return "imgDockIcon2"
        case .lunarDay:
            return "imgDockIcon3"
        case .faq:
            return "imgDockIcon4"
            
        case .addEvent:
            return "imgButtonPlus"
        }
    }
    
    static func name(for index: Int) -> String {
        guard index >= 0 && index < AppIconType.allCases.count else {
            return ""
        }
        return AppIconType.allCases[index].name
    }
    
    static func image(for index: Int) -> String {
        guard index >= 0 && index < AppIconType.allCases.count else {
            return ""
        }
        return AppIconType.allCases[index].image
    }
}


// MARK: - 아이콘 그리드 정보
struct IconGridInfo {
    let columns: Int
    let rows: Int
    let totalIcons: Int
    let dockCount: Int = 4
    var totalWithDock: Int { totalIcons + dockCount }
}

// MARK: - 아이콘 그리드 레이아웃 계산기
struct IconLayoutCalculator {
    static func calculateIconGrid(screenSize: CGSize, spacing: CGFloat = 16, widgetHeight: CGFloat = 160, maxColumns: Int = 4, dockHeight: CGFloat = 120) -> IconGridInfo {
        // 가로당 최대 아이콘
        var columns = maxColumns
        
        // 아이콘 최소 사이즈 (60-80)
        let minIconWidth: CGFloat = 70.0
        
        // 아이콘 수
        while columns > 1 {
            let totalSpacing = spacing * CGFloat(columns + 1)
            let iconWidth = (screenSize.width - totalSpacing) / CGFloat(columns)
            if iconWidth >= minIconWidth {
                break
            }
            columns -= 1
        }
        
        let iconWidth = (screenSize.width - spacing * CGFloat(columns + 1)) / CGFloat(columns)
        let usableHeight = screenSize.height - widgetHeight - dockHeight - spacing * 4
        let rowHeight = iconWidth + spacing
        let rows = Int(usableHeight / rowHeight)
        
        let totalIcons = rows * columns
        return IconGridInfo(columns: columns, rows: rows, totalIcons: totalIcons)
    }
}

// MARK: - 위젯 뷰 (systemLarge)
struct LargeWidgetView: View {
    let height: CGFloat
    
    var body: some View {
        CalendarThemeView(viewModel: WidgetSettingModel())
            .padding()
            .background(Color(hex: "EFEFF0"))
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 25)
    }
}

// MARK: - 아이콘 개별 뷰
struct AppIconView: View {
    let icon: AppIcon
    let size: CGFloat
    let tapped: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .frame(width: size, height: size)
                .overlay(
                    Image(icon.image)
                        .resizable()
                        .scaledToFit()
                        .padding(size * 0.2)
                )
            
            Text(icon.type)
                .font(.caption)
                .lineLimit(1)
        }
        .onTapGesture {
            tapped()
        }
    }
}

// MARK: - 일정 추가 뷰
struct AddEventView: View {
    let icon: AppIcon
    let size: CGFloat
    let tapped: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.9))
                .frame(width: size * 0.7, height: size * 0.7)
                .clipShape(.circle)
                .shadow(color: Color.black.opacity(0.15),radius: 10)
                .overlay(
                    Image(icon.image)
                        .frame(width: size * 0.5, height: size * 0.5)
                )
        }
        .onTapGesture {
            tapped()
        }
    }
}

// MARK: - 홈 화면 뷰(앱 아이콘 + 위젯)
/* 버튼 별 인덱스
 1 2 3 4
       9
 5 6 7 8
 */
struct HomeScreenWithWidget: View {
    @Binding var selectedApp: AppIcon?
    @Binding var selectedIndex: Int
    
    @State var showAddEventView: Bool = false
    @State var showFaqView: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 20
            let widgetHeight: CGFloat = 160
            let screenSize = geometry.size
            let gridInfo = IconLayoutCalculator.calculateIconGrid(screenSize: screenSize, spacing: spacing, widgetHeight: widgetHeight)
            let iconSize = (screenSize.width - spacing * CGFloat(gridInfo.columns + 1)) / CGFloat(gridInfo.columns)
//            let columns = Array(repeating: GridItem(.fixed(iconSize), spacing: spacing), count: gridInfo.columns)
            
            ZStack {
                // 배경
                Image("imgBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: spacing) {
                    // 위젯
                    LargeWidgetView(height: screenSize.width - spacing * 2)
                    
//                    // 아이콘 그리드 //TBD
//                    LazyVGrid(columns: columns, spacing: spacing) {
//                        ForEach(0..<4, id: \.self) { index in
//                            let appIcon = AppIcon(index: index + 1, type: AppIconType.name(for: index), image: AppIconType.image(for: index))
//                            AppIconView(icon: appIcon, size: iconSize) {
//                                withAnimation(.easeInOut(duration: 0.25)) {
//                                    selectedApp = appIcon
//                                    selectedIndex = index + 1
//                                }
//                            }
//                            .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
//                                [index + 1: anchor]
//                            }
//                        }
//                    }
//                    .padding(.horizontal, spacing)
                    Spacer().padding(.vertical)
                    
                    // 이벤트 추가
                    HStack {
                        Spacer()
                        let appIcon = AppIcon(index: 9, type: AppIconType.name(for: 8), image: AppIconType.addEvent.image)
                        AddEventView(icon: appIcon, size: iconSize) {
                            selectedApp = appIcon
                            selectedIndex = 9
                            
                            showAddEventView.toggle()
                        }
                        .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                            [9: anchor]
                        }
                        .sheet(isPresented: $showAddEventView) {
                            AddEvent()
                        }
                    }
                    .padding(.horizontal, spacing)
                    .padding(.vertical, 2)
                    
                    // Dock
                    HStack(spacing: spacing) {
                        ForEach(4..<8, id: \.self) { index in
                            let iconIndex = index + 1
                            let appIcon = AppIcon(index: iconIndex, type: AppIconType.name(for: index), image: AppIconType.image(for: index))
                            if iconIndex == 8 {
                                AppIconView(icon: appIcon, size: iconSize) {
                                    selectedApp = appIcon
                                    selectedIndex = iconIndex
                                    
                                    showFaqView.toggle()
                                }
                                .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                                    [iconIndex: anchor]
                                }
                                .sheet(isPresented: $showFaqView) {
                                    FAQSheetView {
                                        showFaqView.toggle()
                                    }
                                }
                            } else {
                                AppIconView(icon: appIcon, size: iconSize) {
                                    selectedApp = appIcon
                                    selectedIndex = iconIndex
                                }
                                .anchorPreference(key: AppIconViewPreferenceKey.self, value: .bounds) { anchor in
                                    [iconIndex: anchor]
                                }
                            }
                        }
                    }
                    .padding()
                    .background(
                        VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                    .padding(.bottom, spacing + safeAreaBottomInset())
                }
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )
                .ignoresSafeArea(edges: [.top, .bottom])
            }
        }
    }
    
    private func safeAreaBottomInset() -> CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
}


#Preview(body: {
    MainView()
})

// MARK: - FAQ 시트 뷰
struct FAQItem {
    let index: Int
    let title: String
    let content: String
}

struct FAQList {
    static let widget = FAQItem(index: 1, title: "위젯은 어디서 추가하나요?", content: "1. 홈 화면에서 빈 영역을 길게 터치\n2. 좌측 상단의 '+' 탭\n3. 위젯을 선택, 추가합니다")
    static let marking = FAQItem(index: 2, title: "일정 표시가 되지 않아요", content: "설정 > '앱 이름' > 캘린더\n이동하여 전체 접근 설정을 켜주세요")
    static let lunar = FAQItem(index: 3, title: "음력 표시 기준은?", content: "음력은 한국천문연구원 데이터를 기준으로 합니다")
}

struct FAQSheetView: View {
    let onCancelTapped: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        onCancelTapped()
                    }
                }) {
                    Text("닫기")
                        .font(.headline)
                        .foregroundStyle(Color.secondary)
                        .padding()
                }
                Spacer()
                Text("FAQ")
                    .font(.headline)
                    .padding()
                Spacer()
                Button(action: {
                    
                }) {
                    Text("닫기")
                        .font(.headline)
                        .foregroundStyle(Color.white)
                        .padding()
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    FAQItemView(faqItem: FAQList.widget)
                    FAQItemView(faqItem: FAQList.marking)
                    FAQItemView(faqItem: FAQList.lunar)
                    HStack {
                        Text("버전 정보")
                        Spacer()
                        Text("v\(AppInfo.version)")
                    }
                    .font(.callout)
                    .bold()
                    .padding()
                }
                .padding(.horizontal)
            }
        }
        .background(Color.white)
    }
}

struct FAQItemView: View {
    @State var isShowing: Bool = false
    let faqItem: FAQItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isShowing.toggle()
                }
            } label: {
                HStack {
                    Text(faqItem.title)
                        .font(.callout)
                        .bold()
                    
                    Spacer()
                    
                    Image(systemName: "chevron.up")
                        .rotationEffect(.degrees(isShowing ? 180 : 0))
                        .animation(.easeInOut(duration: 0.25), value: isShowing)
                        .foregroundColor(.black)
                        .bold()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isShowing.toggle()
                    }
                }
            }
            
            if isShowing {
                VStack(alignment: .leading, spacing: 4) {
                    Text(faqItem.content)
                        .font(.subheadline)
                        .foregroundStyle(Color(hex: "5E5E5E"))
                        .padding(.top, 4)
                        .padding(.horizontal)
                    if faqItem.index == 3 {
                        Link(destination: URL(string: "https://astro.kasi.re.kr/life/pageView/8")!) {
                            HStack {
                                Text("한국천문연구원 이동하기")
                            }
                            .font(.footnote)
                            .foregroundStyle(Color.justDefaultColor)
                            .underline()
                            .padding(.top, 4)
                            .padding(.horizontal)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.25), value: isShowing)
            }
        }
        .foregroundStyle(Color.black)
        .padding()
    }
}


// MARK: - 일정 추가 sheet 뷰

import EventKit
import EventKitUI

struct AddEvent: UIViewControllerRepresentable {
    typealias UIViewControllerType = EKEventEditViewController

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let eventStore = EKEventStore()
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.editViewDelegate = context.coordinator

        // Create empty event (optional)
        let event = EKEvent(eventStore: eventStore)
        event.title = "새 일정"
        controller.event = event

        // 권한 확인 및 요청
        eventStore.requestAccess(to: .event) { granted, error in
            if !granted {
                print("Calendar access denied.")
            }
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
        // 업데이트 불필요
    }

    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: AddEvent

        init(_ parent: AddEvent) {
            self.parent = parent
        }

        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            controller.dismiss(animated: true)
        }
    }
}


// MARK: - sheet 뷰
struct AppFullScreenView: View {
    @Binding var appIcon: AppIcon?
    let position: CGPoint
    
    @Binding var showCover: Bool
    @Binding var showPopup: Bool
    
    let onTap: () -> Void
    
    var body: some View {
        if let appIcon = appIcon {
            if appIcon.index == 8 {
//                FAQSheetView(onCancelTapped: onTap)
            } else if appIcon.index == 9 {
//                AddEventSheetView(onCancelTapped: onTap)
            } else if appIcon.index == 5 || appIcon.index ==  6 || appIcon.index == 7 {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            onTap()
                        }
                    let width = appIcon.index == 7 ? 160.0 : 240.0
                    BubbleView(position: position, isPresented: $showPopup, index: appIcon.index, width: width)
                }
            } else {
                ZStack {
                    if showCover {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                onTap()
                                withAnimation {
                                    showPopup = false
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        showCover = false
                                    }
                                }
                            }
                    }
                    
                    PopupView(isPresented: $showPopup, appIcon: $appIcon)
                        .transition(.identity)
                        .zIndex(1)
                }
                .animation(.easeInOut, value: showCover)
            }
        }
    }
}


// MARK: - 1/3 팝업뷰
struct PopupView: View {
    @Binding var isPresented: Bool
    @State private var popupOffset: CGFloat = UIScreen.main.bounds.height
    @State private var offsetY: CGFloat = 0
    
    @Binding var appIcon: AppIcon?
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                SubPopupView(appIcon: $appIcon)
                    .frame(height: geo.size.height / 3)
                    .offset(y: popupOffset)
                    .onChange(of: isPresented) { oldValue, newValue in
                        withAnimation {
                            popupOffset = newValue ? 0 : geo.size.height
                        }
                    }
                    .onAppear {
                        withAnimation(.easeOut) {
                            popupOffset = 0
                        }
                    }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}


struct SubPopupView: View {
    @Binding var appIcon: AppIcon?
    
    var body: some View {
        VStack(spacing: 16) {
            Text(appIcon?.name ?? "없음")
                .font(.headline)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

// MARK: - 말풍선 뷰
struct BubbleView: View {
    let position: CGPoint //앱 아이콘의 중심 -> 말풍선 네모의 중앙 하단
    @Binding var isPresented: Bool
    
    let index: Int
    let width: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 20
            let widgetHeight: CGFloat = 160
            let screenSize = geometry.size
            let gridInfo = IconLayoutCalculator.calculateIconGrid(screenSize: screenSize, spacing: spacing, widgetHeight: widgetHeight)
            let iconSize = (screenSize.width - spacing * CGFloat(gridInfo.columns + 1)) / CGFloat(gridInfo.columns)
            
            ZStack {
                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .frame(width: width, height: 120)
                    
                    TrianglePointer()
                        .fill(Color.white)
                        .frame(width: 20, height: 15)
                        .offset(x: -(width / 2) + (iconSize / 2)) //중심에서 좌로 이동
                }
                
                SubBubbleView(isPresented: $isPresented, index: index)
            }
            .position(
                x: position.x + (width / 2),
                y: position.y - (100 / 2) - 15
            )
            
        }
    }
}

struct SubBubbleView: View {
    @Binding var isPresented: Bool
    let index: Int
    
    var body: some View {
        VStack {
            if index == 5 {
                Text("위젯의 테마색을 선택합니다")
                    .padding(.bottom)
                ColorOptionView(viewModel: WidgetSettingModel())
            } else if index == 6 {
                Text("위젯의 첫번째 요일을 선택합니다")
                    .frame(width: 235)
                    .padding(.bottom)
                    .multilineTextAlignment(.center)
                FirstDayOptionView(viewModel: WidgetSettingModel())
            } else if index == 7 {
                Text("날짜 하단에 음력을 표시합니다")
                    .frame(width: 155)
                    .padding(.bottom, 5)
                    .multilineTextAlignment(.center)
                LunarDateOptionView(viewModel: WidgetSettingModel())
            }
        }
        .font(.subheadline)
        .bold()
        .padding(.bottom)
    }
}

struct TrianglePointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // 왼쪽 위 -> 오른쪽 위 -> 중앙 아래
        path.move(to: CGPoint(x: rect.minX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct ColorOptionView: View {
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        HStack(spacing: 18) {
            ForEach(WidgetTheme.allCases, id: \.self) { theme in
                Button(action: {
                    viewModel.setTheme(color: theme.name)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(theme.color)
                            .frame(width: 20, height: 20)
                        
                        if viewModel.themeColor == theme.name {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                }
            }
        }
    }
}

//리로드 체크
struct FirstDayOptionView: View {
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<2) { index in
                Button(action: {
                    viewModel.setFirstDayOfWeek(day: index + 1)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "D9D9D9"))
                            .frame(width: 20, height: 20)
                        
                        if viewModel.firstDayOfWeek == index + 1 {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.black.opacity(0.7))
                                .font(.system(size: 13, weight: .bold))
                        }
                    }
                }
                Text(index + 1 == 1 ? "일요일" : "월요일")
            }
        }
    }
}

//리로드 체크
struct LunarDateOptionView: View {
    @ObservedObject var viewModel: WidgetSettingModel
    
    var body: some View {
        Toggle("테마 적용", isOn: $viewModel.isLunarCalendar)
            .onChange(of: viewModel.isLunarCalendar) {
                viewModel.setLunarCalendar(isOn: viewModel.isLunarCalendar)
            }
            .tint(WidgetTheme.justDefaultColor.color.opacity(0.7))
            .labelsHidden()
            .fixedSize()
            .scaleEffect(0.8)
    }
}

// MARK: - 배경 블러 뷰 (Dock용)
struct VisualEffectBlur: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - PreferenceKey
struct AppIconViewPreferenceKey: PreferenceKey {
    typealias Value = [Int: Anchor<CGRect>]
    
    static var defaultValue: [Int: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [Int: Anchor<CGRect>], nextValue: () -> [Int: Anchor<CGRect>]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

// MARK: - 메인 ContentView
struct ContentView: View {
    @State private var selectedApp: AppIcon? = nil
    @State private var selectedPosition: CGPoint? = nil
    @State private var selectedIndex = 0
    
    @State private var showCover: Bool = false
    @State private var showPopup: Bool = false
    
    var body: some View {
        ZStack {
            HomeScreenWithWidget(selectedApp: $selectedApp, selectedIndex: $selectedIndex)
                .coordinateSpace(.named("container"))
                .overlayPreferenceValue(AppIconViewPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        
                        Color.clear
                            .onChange(of: selectedIndex) { _, newValue in
                                if let anchor = preferences[newValue] {
                                    let rect = geometry[anchor]
                                    selectedPosition = CGPoint(x: rect.minX, y: rect.minY)
                                    
                                } else {
                                    selectedPosition = nil
                                }
                                showCover.toggle()
                                showPopup.toggle()
                            }
                    }
                }
            
            if let position = selectedPosition {
                AppFullScreenView(appIcon: $selectedApp, position: position, showCover: $showCover, showPopup: $showPopup) {
                    selectedApp = nil
                    selectedPosition = nil
                    selectedIndex = 0
                }
            }
        }
    }
}

// MARK: - 시작 MainView
// MainView -> (OnboardingTabView) -> ContentView
enum AppSettings {
    static let appName = "AddWidgetTestWidget"
    struct Keys {
        static let onboardingKey = "Key_onboarding"
    }
}

struct MainView: View {
    @AppStorage("onboarding") var isOnboarding: Bool = true
    
    var body: some View {
        ContentView()
            .fullScreenCover(isPresented: $isOnboarding) {
                OnboardingTabView(isOnboarding: $isOnboarding)
            }
    }
}

// MARK: - 온보딩 OnboardingTabView
struct OnboardingTabView: View {
    @Binding var isOnboarding: Bool
    
    private let totalPages = 3
    @State private var selectedPage = 0
    
    var body: some View {
        ZStack {
            Image("imgBackground")
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(index == selectedPage ? Color.black : Color.black.opacity(0.2))
                                .opacity(selectedPage == 3 ? 0 : 1)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Capsule())
                    
                }
                .padding(.top, 80)
                
                TabView(selection: $selectedPage) {
                    OnboardingCommonView(title: "심플한 캘린더 위젯을 추가해보세요!", imageName: "imgOnboarding1")
                        .tag(0)
                    
                    OnboardingCommonView(title: "기본 캘린더에 저장된 일정을 \n표시할 수 있어요!", imageName: "imgOnboarding2")
                        .tag(1)
                    
                    OnboardingLastView(title: "음력 날짜와 함께 일정을\n확인할 수 있어요!", imageName: "imgOnboarding2", isOnboarding: $isOnboarding)
                        .tag(2)
                }
                .ignoresSafeArea()
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
}

struct OnboardingCommonView: View {
    let title: String
    let imageName: String
    
    var body: some View {
        VStack() {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title3)
                .bold()
                .padding()
            Image(imageName)
                .padding()
            Spacer()
        }
    }
}

struct OnboardingLastView: View {
    let title: String
    let imageName: String
    
    @Binding var isOnboarding: Bool
    
    var body: some View {
        VStack() {
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title3)
                .bold()
                .padding()
            Image(imageName)
            Button {
                isOnboarding.toggle()
            } label: {
                Text("앱 시작하기")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .bold()
                    .padding(.horizontal, 40)
                    .padding(.vertical, 10)
                    .background(Color(hex: "DD6464"))
                    .clipShape(Capsule())
            }
            .padding(.top)
            
            Spacer()
        }
    }
}
