//
//  FAQSheetView.swift
//  Calette
//
//  Created by yeri on 6/29/25.
//

import SwiftUI

// MARK: - FAQ 시트 뷰
struct FAQItem {
    let index: Int
    let title: String
    let content: String
}

struct FAQList {
    static let widget = FAQItem(index: 1, title: "위젯은 어떻게 추가하나요?", content: "- 홈 화면의 빈 영역을 길게 터치 → 좌측 상단의 ‘+’ 버튼 선택 → 위젯 추가\n- 홈 화면의 앱 아이콘을 길게 터치 → 위젯 추가 (iOS18 이상인 경우)")
    static let marking = FAQItem(index: 2, title: "일정 표시가 되지 않아요", content: "- 일정 데이터는 캘린더 앱에서 가져옵니다\n- 설정 > '\(AppInfo.appName)' > 캘린더로\n 이동하여 전체 접근 설정을 켜주세요")
    static let lunar = FAQItem(index: 3, title: "음력 표시 기준이 궁금해요", content: "음력은 한국천문연구원 데이터를 기준으로 합니다")
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
                        .foregroundStyle(Color(hex: "5E5E5E"))
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
                            .foregroundStyle(Color.textBlack)
                        Spacer()
                        Text("v\(AppData.version)")
                            .foregroundStyle(Color.textBlack)
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
                            .foregroundStyle(Color.caletteDefault)
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
