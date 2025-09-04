//
//  SettingsAlertView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct SettingsAlertView: View {
    @Binding var isPresented: Bool
    @State private var musicVolume: Double = 0.0
    @State private var soundVolume: Double = 0.8
    
    var body: some View {
        ZStack {
            // Полупрозрачный фон
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // Панель настроек
            VStack(spacing: 20) {
                // Заголовок
                Image("settings_label")
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
                
                // Кнопка закрытия
                Button(action: {
                    isPresented = false
                }) {
                    Image("close_button")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            .padding(30)
            .background(
                Image("settings_panel")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            ).frame(width: 250 ,height: 150)
        }
    }
}

#Preview {
    SettingsAlertView(isPresented: .constant(true))
}

// Расширение для изменения размера UIImage
extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
