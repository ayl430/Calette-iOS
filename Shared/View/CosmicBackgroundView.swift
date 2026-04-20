//
//  CosmicBackgroundView.swift
//  Calette
//

import SwiftUI

struct CosmicBackgroundView: View {
    var body: some View {
        ZStack {
            // Layer 1: 베이스 그라데이션 (짙은 남색 → 흑색)
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.07, blue: 0.14),  // 상단: 짙은 남보라
                    Color(red: 0.03, green: 0.04, blue: 0.09),  // 중앙
                    Color(red: 0.02, green: 0.03, blue: 0.06)   // 하단: 거의 흑색
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Layer 2: 성운 glow (중앙~상단에 희미한 보라빛)
            nebulaLayer

            // Layer 3: 별
            starsLayer
        }
        .ignoresSafeArea()
    }

    // MARK: - 성운

    private var nebulaLayer: some View {
        ZStack {
            // 주 성운: 중앙 약간 위에 큰 보라빛 glow
            RadialGradient(
                colors: [
                    Color(red: 0.20, green: 0.15, blue: 0.35).opacity(0.08),
                    Color.clear
                ],
                center: UnitPoint(x: 0.4, y: 0.35),
                startRadius: 20,
                endRadius: 350
            )

            // 보조 성운: 우상단에 남색 glow
            RadialGradient(
                colors: [
                    Color(red: 0.12, green: 0.15, blue: 0.30).opacity(0.06),
                    Color.clear
                ],
                center: UnitPoint(x: 0.7, y: 0.25),
                startRadius: 10,
                endRadius: 250
            )

            // 보조 성운: 좌하단에 미세한 푸른 glow
            RadialGradient(
                colors: [
                    Color(red: 0.10, green: 0.12, blue: 0.25).opacity(0.05),
                    Color.clear
                ],
                center: UnitPoint(x: 0.25, y: 0.65),
                startRadius: 10,
                endRadius: 200
            )
        }
    }

    // MARK: - 별

    private var starsLayer: some View {
        Canvas { context, size in
            // seed 기반 난수로 항상 같은 별 패턴 생성
            var rng = SeededRNG(seed: 42)

            // 작은 별 (200개)
            for _ in 0..<200 {
                let x = CGFloat.random(in: 0..<size.width, using: &rng)
                let y = CGFloat.random(in: 0..<size.height, using: &rng)
                let radius = CGFloat.random(in: 0.3...0.6, using: &rng)
                let opacity = Double.random(in: 0.15...0.4, using: &rng)

                let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
                context.fill(Circle().path(in: rect), with: .color(.white.opacity(opacity)))
            }

            // 중간 별 (60개)
            for _ in 0..<60 {
                let x = CGFloat.random(in: 0..<size.width, using: &rng)
                let y = CGFloat.random(in: 0..<size.height, using: &rng)
                let radius = CGFloat.random(in: 0.6...1.0, using: &rng)
                let opacity = Double.random(in: 0.35...0.6, using: &rng)

                let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
                context.fill(Circle().path(in: rect), with: .color(.white.opacity(opacity)))
            }

            // 밝은 별 (15개)
            for _ in 0..<15 {
                let x = CGFloat.random(in: 0..<size.width, using: &rng)
                let y = CGFloat.random(in: 0..<size.height, using: &rng)
                let radius = CGFloat.random(in: 1.0...1.8, using: &rng)
                let opacity = Double.random(in: 0.6...0.85, using: &rng)

                // 글로우 (큰 반투명 원)
                let glowRadius = radius * 3
                let glowRect = CGRect(x: x - glowRadius, y: y - glowRadius, width: glowRadius * 2, height: glowRadius * 2)
                context.fill(Circle().path(in: glowRect), with: .color(.white.opacity(opacity * 0.08)))

                // 본체
                let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
                context.fill(Circle().path(in: rect), with: .color(.white.opacity(opacity)))
            }
        }
    }
}

// MARK: - Seed 기반 난수 생성기 (매번 동일한 별 패턴)

private struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        // xorshift64
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
