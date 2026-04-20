//
//  DesignSystem.swift
//  Calette
//

import SwiftUI

enum DesignSystem {

    // MARK: - Colors

    enum Colors {
        // --- Background ---
        /// 앱 전체 기본 배경 (Midnight Base)
        static let background   = Color(hex: "0D1117")
        /// 카드·모달·리스트 배경 (Cosmic Glass)
        static let surface      = Color(hex: "161B22")
        /// 유리 카드 경계선 · white 12% (배경 이미지 위 하이라이트)
        static let border       = Color.white.opacity(0.12)

        // --- Text ---
        /// 주요 텍스트·강조 아이콘 (Lunar White)
        static let primary      = Color(hex: "F0F6FC")
        /// 보조 텍스트·비활성 상태 (Stardust Grey)
        static let secondary    = Color(hex: "8B949E")

        // --- Accent ---
        /// 기본 테마 포인트 컬러 (Dusty Lavender)
        static let accent       = Color(hex: "B39DDB")
        /// 완료 일정·긍정 상태 (Sage Green)
        static let accentGreen  = Color(hex: "81C784")

        // --- Semantic ---
        /// 공휴일·경고 (Muted Coral Pink)
        static let holiday      = Color(hex: "E8A3A3")

        // --- Glassmorphism ---
        enum Glass {
            /// 아이콘·카드 베이스 fill
            static let base          = Color.white.opacity(0.08)
            /// 카드 tint 그라데이션 상단
            static let tintTop       = Color.white.opacity(0.15)
            /// 카드 tint 그라데이션 하단
            static let tintBottom    = Color.white.opacity(0.05)
            /// 보더 그라데이션 상단
            static let borderTop     = Color.white.opacity(0.30)
            /// 보더 그라데이션 하단
            static let borderBottom  = Color.white.opacity(0.08)
            /// 모달/말풍선 어두운 배경 상단
            static let modalTop      = Color.black.opacity(0.65)
            /// 모달/말풍선 어두운 배경 하단
            static let modalBottom   = Color.black.opacity(0.55)
        }

        // --- Overlay ---
        enum Overlay {
            /// 하단 시트 뒷배경
            static let dim      = Color.black.opacity(0.3)
            /// 모달·말풍선 뒷배경
            static let dimHeavy = Color.black.opacity(0.7)
        }

        // --- Button (보라 계열 FAB·선택 날짜) ---
        enum Button {
            static let purpleTop    = Color(red: 0.45, green: 0.38, blue: 0.72)
            static let purpleBottom = Color(red: 0.30, green: 0.25, blue: 0.55)
            static let purpleGlow   = Color(red: 0.40, green: 0.33, blue: 0.65)
        }

        // --- Event Accent Bar ---
        enum EventBar {
            /// 공휴일 accent 바
            static let holiday = Color(hex: "FF7A6B")
            /// 일반 일정 accent 바
            static let normal  = Color(hex: "6A8FE8")
        }

        // --- Theme Presets (설정 화면 6가지 선택지) ---
        enum Theme {
            static let dustyLavender = Color(hex: "B39DDB")
            static let softPeach     = Color(hex: "F2C6A0")
            static let mintGreen     = Color(hex: "9ED8C3")
            static let mutedCoral    = Color(hex: "E8A3A3")
            static let deepPurple    = Color(hex: "6C5CE7")
            static let midnightBase  = Color(hex: "0D1117")

            static let all: [Color] = [
                dustyLavender, softPeach, mintGreen,
                mutedCoral, deepPurple, midnightBase
            ]
        }
    }

    // MARK: - Gradient

    enum Gradient {
        /// 카드·도크 글래스 tint (white 15→5%)
        static let glassTint = LinearGradient(
            colors: [Colors.Glass.tintTop, Colors.Glass.tintBottom],
            startPoint: .top, endPoint: .bottom
        )
        /// 카드·도크 글래스 보더 (white 30→8%)
        static let glassBorder = LinearGradient(
            colors: [Colors.Glass.borderTop, Colors.Glass.borderBottom],
            startPoint: .top, endPoint: .bottom
        )
        /// 모달·말풍선 어두운 배경
        static let modalBackground = LinearGradient(
            colors: [Colors.Glass.modalTop, Colors.Glass.modalBottom],
            startPoint: .top, endPoint: .bottom
        )
        /// FAB·오늘로 버튼·선택 날짜 보라 그라데이션
        static let buttonPurple = LinearGradient(
            colors: [Colors.Button.purpleTop, Colors.Button.purpleBottom],
            startPoint: .top, endPoint: .bottom
        )
        /// 버튼 상단 하이라이트 (white 22→0%)
        static let buttonHighlight = LinearGradient(
            colors: [Color.white.opacity(0.22), Color.white.opacity(0.0)],
            startPoint: .top, endPoint: .center
        )
        /// 버튼 보더 그라데이션 (white 45→5%)
        static let buttonBorder = LinearGradient(
            colors: [Color.white.opacity(0.45), Color.white.opacity(0.05)],
            startPoint: .top, endPoint: .bottom
        )
    }

    // MARK: - Typography

    enum Typography {
        /// 월 표시 · 24pt Bold · letter spacing -2%
        static func heading1() -> Font {
            .system(size: 24, weight: .bold, design: .default)
        }

        /// 날짜 숫자 · 18pt Medium
        static func heading2() -> Font {
            .system(size: 18, weight: .medium, design: .default)
        }

        /// 이벤트 제목 · 16pt Regular
        static func body1() -> Font {
            .system(size: 16, weight: .regular, design: .default)
        }

        /// 음력·상세 정보 · 13pt Light
        static func body2() -> Font {
            .system(size: 13, weight: .light, design: .default)
        }

        /// 위젯·작은 정보 · 11pt Medium
        static func caption() -> Font {
            .system(size: 11, weight: .medium, design: .default)
        }

        // Variable Weight: 일정 밀도에 따른 날짜 숫자 두께
        static func dateNumber(hasEvent: Bool) -> Font {
            .system(size: 18, weight: hasEvent ? .semibold : .light, design: .default)
        }
    }

    // MARK: - Layout

    enum Layout {
        /// 카드·모달 코너 반경
        static let cardRadius: CGFloat   = 20
        /// 버튼 코너 반경
        static let buttonRadius: CGFloat = 12
        /// 이벤트 카드 좌측 accent 바 두께
        static let accentBarWidth: CGFloat = 2
        /// 이벤트 카드 내부 패딩 (수직)
        static let cardPaddingV: CGFloat = 16
        /// 이벤트 카드 내부 패딩 (수평)
        static let cardPaddingH: CGFloat = 20
        /// Primary 버튼 높이
        static let buttonHeight: CGFloat = 54
    }

    // MARK: - Shadow

    enum Shadow {
        /// FAB(플로팅 버튼) 그림자 · rgba(0,0,0,0.5)
        static let fab = Color.black.opacity(0.5)
        static let fabRadius: CGFloat = 24
        static let fabY: CGFloat = 8

        /// 카드 그림자
        static let card = Color.black.opacity(0.3)
        static let cardRadius: CGFloat = 12
        static let cardY: CGFloat = 4

        /// 보라 버튼 글로우 쉐도우
        static let buttonGlow = Colors.Button.purpleGlow.opacity(0.35)
        static let buttonGlowRadius: CGFloat = 10
        static let buttonGlowY: CGFloat = 1
    }
}
