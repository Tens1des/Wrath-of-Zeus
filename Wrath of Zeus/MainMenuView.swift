//
//  MainMenuView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct MainMenuView: View {
    @State private var navigateToGame = false
    @State private var showSettings = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Фоновое изображение
                Image("bg_main")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
                
                VStack {
                    // Элементы навигационной панели
                    HStack {
                        // Левая секция: Плашка с монетой и счётчиком
                        ZStack {
                            Image("money_panel")
                                .resizable()
                                .frame(width: 80, height: 35)
                            
                            HStack(spacing: 4) {
                                Text("25")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                            }
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        // Центральная секция: Лучший счёт
                        VStack(spacing: 2) {
                            Text("Best Score:")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.yellow)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                            
                            Text("1557")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                        }
                        
                        Spacer()
                        
                        // Правая секция: Кнопка настроек
                        Button(action: {
                            showSettings = true
                        }) {
                            Image("settings_button")
                                .resizable()
                                .frame(width: 35, height: 35)
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 8)
                    
                    Spacer()
                    
                    // Центральная кнопка Play с отступом сверху
                    VStack(spacing: 8) {
                        
                        
                        Button(action: {
                            navigateToGame = true
                        }) {
                            Image("play_button")
                                .resizable()
                                .frame(width: 150, height: 150)
                        }
                    }
                    .padding(.top, -150)
                    
                    // Уменьшенное расстояние между кнопками
                    Spacer()
                        .frame(height: 20)
                    
                    // Нижняя кнопка Shop
                    Button(action: {
                        // Действие для кнопки магазина
                        print("Магазин нажат")
                    }) {
                        Image("shop_button")
                            .resizable()
                            .frame(width: 250, height: 100)
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToGame) {
            ContentView()
        }
        .overlay(
            // Алерт настроек
            Group {
                if showSettings {
                    SettingsAlertView(isPresented: $showSettings)
                }
            }
        )
    }
}

#Preview {
    MainMenuView()
}
