//
//  WidgetThemesView.swift
//  JustCalendar
//
//  Created by yeri on 2/22/25.
//

import SwiftUI

struct WidgetThemesView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
//        ZStack {
//            Color.white
        WidgetThemesItemsView(viewModel: WidgetSettingModel())
//                .ignoresSafeArea(.all)
                .navigationBarBackButtonHidden()
                
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("이전")
                            }
                        }

                    }
                }
                
                
//        }
    }
}

#Preview {
    WidgetThemesView()
}
