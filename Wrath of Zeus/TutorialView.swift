//
//  TutorialView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showGame: Bool // Binding для запуска игры
    @State private var currentTutorialIndex = 0
    
    private let tutorialImages = ["tutorial1", "tutorial2", "tutorial3", "tutorial4", "tutorial5"]
    
    var body: some View {
        ZStack {
            // Фоновое изображение
            Image("bg_main")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Изображение туториала
                Image(tutorialImages[currentTutorialIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        nextTutorial()
                    }
                
                Spacer()
                
                // Индикаторы страниц
                HStack(spacing: 8) {
                    ForEach(0..<tutorialImages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentTutorialIndex ? Color.yellow : Color.gray)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
    
    private func nextTutorial() {
        if currentTutorialIndex < tutorialImages.count - 1 {
            currentTutorialIndex += 1
        } else {
            // Последний туториал - переходим к игре
            dismiss() // Закрываем туториал
            showGame = true // Запускаем игру
        }
    }
}

#Preview {
    TutorialView(showGame: .constant(false))
}
