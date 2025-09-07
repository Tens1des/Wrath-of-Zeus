//
//  MainMenuView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct MainMenuView: View {
    @State private var showTutorial = false
    @State private var showSettings = false
    @State private var showShop = false
    @State private var showGame = false // Добавляем состояние для игры
    
    // Используем менеджер магазина
    @ObservedObject var shopManager = ShopManager.shared
    
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
                                Text("\(shopManager.totalCoins)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                                    .padding(.leading, 20) // Сдвигаем текст правее, как в игре
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
                            
                            Text("\(getHighScore())")
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
                            showTutorial = true
                        }) {
                            Image("play_button")
                                .resizable()
                                .frame(width: 150, height: 150)
                        }
                    }
                    .padding(.top, -100)
                    
                    // Уменьшенное расстояние между кнопками
                    Spacer()
                        .frame(height: 40)
                    
                    // Нижняя кнопка Shop
                    Button(action: {
                        showShop = true
                    }) {
                        Image("shop_button")
                            .resizable()
                            .frame(width: 250, height: 100)
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                }
            }
        }
        .onAppear {
            loadGameStats()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // Обновляем данные при возвращении в приложение
            loadGameStats()
        }
        .onReceive(NotificationCenter.default.publisher(for: .restartGame)) { _ in
            // При получении уведомления о перезапуске - запускаем туториал
            print("Получено уведомление о перезапуске - запускаем туториал")
            showTutorial = true
        }
        .fullScreenCover(isPresented: $showTutorial) {
            TutorialView(showGame: $showGame) // Передаем binding для игры
        }
        .fullScreenCover(isPresented: $showGame) {
            ContentView() // Показываем игру напрямую
        }
        .sheet(isPresented: $showShop) {
            ShopView()
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
    
    private func loadGameStats() {
        // Загружаем рекорд из UserDefaults
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: "highScore")
        print("MainMenu - High Score loaded: \(highScore)")
    }
    
    private func getHighScore() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: "highScore")
    }
}

#Preview {
    MainMenuView()
}
