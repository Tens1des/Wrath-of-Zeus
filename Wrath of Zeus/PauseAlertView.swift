//
//  PauseAlertView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct PauseAlertView: View {
    @Binding var isPresented: Bool
    var gameScene: GameScene // Добавляем игровую сцену
    @State private var musicVolume: Double = 0.0
    @State private var soundVolume: Double = 0.8
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToMainMenu = false
    
    var body: some View {
        ZStack {
            // Полупрозрачный фон
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                    gameScene.isPaused = false // Снимаем с паузы
                }
            
            // Панель паузы
            VStack(spacing: 20) {
                // Заголовок PAUSED
                Image("paused_label")
                    .resizable()
                    .frame(height: 40)
                
                // Слайдер музыки
                HStack(spacing: 15) {
                    // Иконка музыки
                    Image(musicVolume > 0 ? "music_icon" : "offMusic_icon")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    // Системный слайдер музыки с кастомными элементами
                    Slider(value: $musicVolume, in: 0...1)
                        .frame(width: 150)
                        .onAppear {
                            // Настройка кастомного thumb
                            UISlider.appearance().setThumbImage(UIImage(named: "slider_thumb")?.resize(to: CGSize(width: 20, height: 15)), for: .normal)
                            // Настройка кастомной заполненной части
                            UISlider.appearance().setMinimumTrackImage(UIImage(named: "slider_fill")?.resize(to: CGSize(width: 200, height: 20)), for: .normal)
                        }
                }
                
                // Слайдер звука
                HStack(spacing: 15) {
                    // Иконка звука
                    Image(soundVolume > 0 ? "sound_icon" : "offSound_icon")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    // Системный слайдер звука с кастомными элементами
                    Slider(value: $soundVolume, in: 0...1)
                        .frame(width: 150)
                        .onAppear {
                            // Настройка кастомного thumb
                            UISlider.appearance().setThumbImage(UIImage(named: "slider_thumb")?.resize(to: CGSize(width: 12, height: 12)), for: .normal)
                            // Настройка кастомной заполненной части
                            UISlider.appearance().setMinimumTrackImage(UIImage(named: "slider_fill")?.resize(to: CGSize(width: 100, height: 50)), for: .normal)
                        }
                }
                
                // Кнопки управления
                HStack(spacing: 20) {
                    // Кнопка домой
                    Button(action: {
                        navigateToMainMenu = true
                    }) {
                        Image("home_button")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    
                    // Кнопка продолжить
                    Button(action: {
                        isPresented = false
                        gameScene.isPaused = false // Снимаем с паузы
                    }) {
                        Image("continue_button")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .padding(30)
            .background(
                Image("settings_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            ).frame(width: 250, height: 200)
        }
        .fullScreenCover(isPresented: $navigateToMainMenu) {
            MainMenuView()
        }
    }
}

#Preview {
    PauseAlertView(isPresented: .constant(true), gameScene: GameScene(size: .zero))
}
