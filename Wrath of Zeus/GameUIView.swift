//
//  GameUIView.swift
//  Wrath of Zeus
//
//  Created by Рома Котов on 04.09.2025.
//

import SwiftUI

struct GameUIView: View {
    @State private var showPauseMenu = false
    @State private var userCoins: Int = 25
    @State private var currentScore: Int = 1557
    @State private var charges: Int = 3
    @State private var isRegenerating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Навбар сверху
                VStack {
                    HStack {
                        // Левая секция: Панель с монетами
                        ZStack {
                            // Кастомная панель денег
                            Image("money_panel")
                                .resizable()
                                .frame(width: 80, height: 35)
                            
                            HStack(spacing: 4) {
                                Text("\(userCoins)")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                            }
                        }
                        .padding(.leading, 16)
                        
                        Spacer()
                        
                        // Центральная секция: Счет
                        VStack(spacing: 2) {
                            Text("Score:")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.yellow)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                            
                            Text("\(currentScore)")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 1, y: 1)
                        }
                        
                        Spacer()
                        
                        // Правая секция: Кнопка паузы
                        Button(action: {
                            showPauseMenu = true
                        }) {
                            ZStack {
                                // Золотой квадрат сверху
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.yellow)
                                    .frame(width: 12, height: 12)
                                    .offset(x: -8, y: -8)
                                
                                // Кнопка паузы
                                Image("pause_button")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                            }
                        }
                        .padding(.trailing, 16)
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 8)
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    // Таббар снизу
                    HStack {
                        // Левая секция: Индикатор зарядов
                        ChargeIndicator(
                            charges: charges,
                            isRegenerating: isRegenerating
                        )
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Центральная секция: Персонаж Zeus
                        Image("zeus_stay")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 150)
                        
                        Spacer()
                        
                        // Правая секция: Пустое место для баланса
                        Rectangle()
                            .fill(Color.clear)
                            .frame(width: 50, height: 80)
                            .padding(.trailing, 20)
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + -30)
                }
                
                // Алерт паузы
                if showPauseMenu {
                    PauseAlertView(isPresented: $showPauseMenu)
                }
            }
        }
        .onTapGesture {
            useCharge()
        }
    }
    
    private func useCharge() {
        if charges > 0 {
            charges -= 1
            
            // Запускаем регенерацию через 3 секунды
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if charges < 3 {
                    charges += 1
                }
            }
        }
    }
}

// MARK: - Индикатор заряда
struct ChargeIndicator: View {
    let charges: Int
    let isRegenerating: Bool
    
    var body: some View {
        ZStack {
            // Фон заряда - заполненный или незаполненный круг
            Image(charges > 0 ? "fill_icon" : "notFill_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
            
            // Молния
            Image("shadow_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            
            // Цифра с количеством зарядов
            Text("\(charges)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black, radius: 1, x: 1, y: 1)
                .offset(x: 15, y: 15)
        }
    }
}

#Preview {
    GameUIView()
}
