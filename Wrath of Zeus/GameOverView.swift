import SwiftUI

struct GameOverView: View {
    var finalScore: Int
    var sessionCoins: Int
    var isNewRecord: Bool
    
    // Функции-замыкания для обработки нажатий кнопок
    var onHome: () -> Void
    var onAgain: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.75).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                // Лейбл "DEFEAT!" или "NEW RECORD!"
                Image(isNewRecord ? "newRecord_label" : "defeat_label")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                // Панель со счетом
                VStack {
                    Text("Score:")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.yellow)
                    Text("\(finalScore)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Панель с монетами
                HStack(spacing: 10) {
                    Image("money_icon") // Заменяем money_panel на money_icon
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("\(sessionCoins)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                }
                
                // Кнопки - МЕНЯЕМ МЕСТАМИ
                HStack(spacing: 30) {
                    // СИНЯЯ КНОПКА (Again) - теперь слева
                    Button(action: onAgain) {
                        VStack {
                            Image("play_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text("Again")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    
                    // КРАСНАЯ КНОПКА (Home) - теперь справа
                    Button(action: onHome) {
                        VStack {
                            Image("home_button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                            Text("Home")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

#Preview {
    GameOverView(
        finalScore: 1557,
        sessionCoins: 500,
        isNewRecord: false,
        onHome: {},
        onAgain: {}
    )
}
