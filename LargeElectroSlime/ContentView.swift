import Playgrounds
import SwiftUI

// MARK: - 自訂形狀：蛋形（以三次貝茲曲線繪製）
/// 用於繪製上窄下寬的圓潤水滴／蛋形幾何圖案，應用於史萊姆頭頂發光觸角
struct EggShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // 取得繪圖區域的尺寸與邊界座標
        let width = rect.width
        let height = rect.height
        let minX = rect.minX
        let minY = rect.minY
        let maxX = rect.maxX
        let maxY = rect.maxY
        let midX = rect.midX

        // 蛋形的最寬處約在整體高度 65% 處（下半部較寬圓，上半部較尖窄）
        let yWidest = minY + height * 0.65
        let halfWidth = width / 2

        // 1. 從頂部中心開始繪製（尖端起點）
        path.move(to: CGPoint(x: midX, y: minY))

        // 2. 右上弧線：平滑過渡至右側最寬處
        path.addCurve(
            to: CGPoint(x: maxX, y: yWidest),
            control1: CGPoint(x: midX + halfWidth * 0.45, y: minY),
            control2: CGPoint(x: maxX, y: yWidest - (yWidest - minY) * 0.55)
        )

        // 3. 右下弧線：延伸至底部中心（較寬圓的蛋底）
        path.addCurve(
            to: CGPoint(x: midX, y: maxY),
            control1: CGPoint(x: maxX, y: yWidest + (maxY - yWidest) * 0.55),
            control2: CGPoint(x: midX + halfWidth * 0.55, y: maxY)
        )

        // 4. 左下弧線：從底部中心延伸至左側最寬處
        path.addCurve(
            to: CGPoint(x: minX, y: yWidest),
            control1: CGPoint(x: midX - halfWidth * 0.55, y: maxY),
            control2: CGPoint(x: minX, y: yWidest + (maxY - yWidest) * 0.55)
        )

        // 5. 左上弧線：平滑收回頂部中心
        path.addCurve(
            to: CGPoint(x: midX, y: minY),
            control1: CGPoint(x: minX, y: yWidest - (yWidest - minY) * 0.55),
            control2: CGPoint(x: midX - halfWidth * 0.45, y: minY)
        )

        // 閉合路徑完成蛋形
        path.closeSubpath()
        return path
    }
}

// MARK: - 主畫面視圖：大型雷史萊姆
struct ContentView: View {
    var body: some View {
        // 使用 ZStack 由底至頂層層堆疊圖元（背景 -> 陰影 -> 身體 -> 頭飾 -> 眼睛 -> 角飾 -> 粒子 -> 標題）
        ZStack {
            // MARK: 【背景層】
            // 全螢幕淺灰底色
            Color(red: 0.94, green: 0.94, blue: 0.94)
                .ignoresSafeArea()

            // MARK: 【地面陰影與光暈】
            // 部位：底部地面紫色外擴光暈（雷元素能量反射）
            Ellipse()
                .foregroundStyle(
                    Color(red: 0.72, green: 0.29, blue: 0.88).opacity(0.5)
                )
                .frame(width: 250, height: 55)
                .blur(radius: 7)
                .offset(y: 66)

            // 部位：底部地面核心接觸深色陰影（本體與地面接觸的接觸面陰影）
            Capsule()
                .foregroundStyle(Color.black.opacity(0.5))
                .frame(width: 210, height: 22)
                .blur(radius: 4)
                .offset(y: 66)

            // MARK: 【頭頂發光觸角 / 花蕾】
            // 部位：觸角頂端發光外圈光暈（紫色外擴模糊效果）
            EggShape()
                .foregroundStyle(Color(red: 0.84, green: 0.47, blue: 1.0))
                .frame(width: 29, height: 40)
                .blur(radius: 5)
                .offset(y: -113)

            // 部位：觸角頂端發光核心球體（白色光源核心）
            EggShape()
                .foregroundStyle(Color.white)
                .frame(width: 20, height: 27)
                .offset(y: -113)

            // 部位：觸角暗紫主莖幹（垂直連接頭頂與頂部光源的莖）
            Capsule()
                .foregroundStyle(Color(red: 0.19, green: 0.03, blue: 0.27))
                .frame(width: 6, height: 38)
                .offset(y: -90)

            // 部位：觸角莖幹兩側的托葉（左右斜向小葉片）
            HStack(spacing: 4) {
                // 左側托葉（逆時針傾斜 -35 度）
                Capsule()
                    .foregroundStyle(Color(red: 0.19, green: 0.03, blue: 0.27))
                    .frame(width: 3.5, height: 11)
                    .rotationEffect(.degrees(-35))
                // 右側托葉（順時針傾斜 35 度）
                Capsule()
                    .foregroundStyle(Color(red: 0.19, green: 0.03, blue: 0.27))
                    .frame(width: 3.5, height: 11)
                    .rotationEffect(.degrees(35))
            }
            .offset(y: -100)

            // MARK: 【史萊姆身體主體】
            // 部位：史萊姆果凍身體（上方大圓弧、下方微收攏的不對稱圓角矩形，搭配垂直雷元素暗紫到亮紫漸層）
            UnevenRoundedRectangle(
                topLeadingRadius: 115,
                bottomLeadingRadius: 55,
                bottomTrailingRadius: 55,
                topTrailingRadius: 115
            )
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.19, green: 0.03, blue: 0.27),  // 頂部深暗紫
                        Color(red: 0.31, green: 0.08, blue: 0.43),  // 上段紫黑
                        Color(red: 0.60, green: 0.18, blue: 0.74),  // 中段紫羅蘭
                        Color(red: 0.72, green: 0.29, blue: 0.88),  // 底部亮紫色
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 250, height: 155)
            .offset(y: -10)

            // MARK: 【頭頂／額頭雷元素圖騰花紋】
            // 部位：頭部圖騰——左右兩側縱向長飾條
            HStack(spacing: 55) {
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 8, height: 70)
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 8, height: 70)
            }
            .offset(y: -51.6)

            // 部位：頭部圖騰——中層左右橫向短飾條
            HStack(spacing: 20) {
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 20, height: 6)
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 20, height: 6)
            }
            .offset(y: -65)

            // 部位：頭部圖騰——上層左右縱向短飾條
            HStack(spacing: 20) {
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 5, height: 25)
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 5, height: 25)
            }
            .offset(y: -75)

            // 部位：頭部圖騰——頂部左右橫向橫飾條
            HStack(spacing: 70) {
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 33, height: 3)
                Rectangle()
                    .foregroundStyle(Color(red: 0.93, green: 0.89, blue: 1.0))
                    .frame(width: 33, height: 3)
            }
            .offset(y: -78)

            // MARK: 【雙眼結構：左眼】
            // 部位：左眼外層紫色霓虹發光光暈
            Capsule()
                .foregroundStyle(Color(red: 0.76, green: 0.25, blue: 0.97))
                .frame(width: 24, height: 54)
                .blur(radius: 5)
                .offset(x: -30)

            // 部位：左眼紫色外眼眶／描邊
            Capsule()
                .stroke(
                    Color(red: 0.76, green: 0.25, blue: 0.97),
                    lineWidth: 3.5
                )
                .frame(width: 20, height: 48)
                .offset(x: -30)

            // 部位：左眼淡黃色眼白／眼球本體
            Capsule()
                .foregroundStyle(Color(red: 1.0, green: 1.0, blue: 0.82))
                .frame(width: 15, height: 42)
                .offset(x: -30)

            // 部位：左眼白色高光亮點
            Capsule()
                .foregroundStyle(Color.white)
                .frame(width: 7, height: 32)
                .blur(radius: 0.8)
                .offset(x: -30)

            // MARK: 【雙眼結構：右眼】
            // 部位：右眼外層紫色霓虹發光光暈
            Capsule()
                .foregroundStyle(Color(red: 0.76, green: 0.25, blue: 0.97))
                .frame(width: 24, height: 54)
                .blur(radius: 5)
                .offset(x: 30)

            // 部位：右眼紫色外眼眶／描邊
            Capsule()
                .stroke(
                    Color(red: 0.76, green: 0.25, blue: 0.97),
                    lineWidth: 3.5
                )
                .frame(width: 20, height: 48)
                .offset(x: 30)

            // 部位：右眼淡黃色眼白／眼球本體
            Capsule()
                .foregroundStyle(Color(red: 1.0, green: 1.0, blue: 0.82))
                .frame(width: 15, height: 42)
                .offset(x: 30)

            // 部位：右眼白色高光亮點
            Capsule()
                .foregroundStyle(Color.white)
                .frame(width: 7, height: 32)
                .blur(radius: 0.8)
                .offset(x: 30)

            // MARK: 【身體兩側雷電螺旋角／卷角圖騰】
            HStack {
                // 部位：身體左側的雷電螺旋角圖案
                ZStack(alignment: .topTrailing) {
                    // 螺旋角的圓形描邊外環
                    Circle()
                        .stroke(
                            Color(red: 0.93, green: 0.89, blue: 1.0),
                            lineWidth: 5
                        )
                        .frame(width: 36, height: 36)

                    // 螺旋角頂部的縱向延伸端點
                    Capsule()
                        .foregroundStyle(
                            Color(red: 0.93, green: 0.89, blue: 1.0)
                        )
                        .frame(width: 5, height: 20)
                        .offset(x: -16, y: -20)

                    // 螺旋角頂部的橫向延伸端點
                    Capsule()
                        .foregroundStyle(
                            Color(red: 0.93, green: 0.89, blue: 1.0)
                        )
                        .frame(width: 21, height: 5)
                        .offset(x: -16, y: -20)
                }

                Spacer()

                // 部位：身體右側的雷電螺旋角圖案（以 scaleEffect 進行水平鏡像翻轉）
                ZStack(alignment: .topTrailing) {
                    // 螺旋角的圓形描邊外環
                    Circle()
                        .stroke(
                            Color(red: 0.93, green: 0.89, blue: 1.0),
                            lineWidth: 5
                        )
                        .frame(width: 36, height: 36)

                    // 螺旋角頂部的縱向延伸端點
                    Capsule()
                        .foregroundStyle(
                            Color(red: 0.93, green: 0.89, blue: 1.0)
                        )
                        .frame(width: 5, height: 20)
                        .offset(x: -16, y: -20)

                    // 螺旋角頂部的橫向延伸端點
                    Capsule()
                        .foregroundStyle(
                            Color(red: 0.93, green: 0.89, blue: 1.0)
                        )
                        .frame(width: 21, height: 5)
                        .offset(x: -16, y: -20)
                }
                .scaleEffect(x: -1, y: 1)  // 水平鏡像
            }
            .frame(width: 235)
            .offset(y: 10)

            // MARK: 【環境特效：漂浮雷元素粒子與星芒】
            // 部位：左上方大菱形星芒粒子（旋轉 45 度的正方形）
            Rectangle()
                .foregroundStyle(
                    Color(red: 0.72, green: 0.53, blue: 0.96)
                )
                .frame(width: 9, height: 9)
                .rotationEffect(.degrees(45))
                .offset(x: -80, y: -105)

            // 部位：右上方中菱形星芒粒子
            Rectangle()
                .foregroundStyle(
                    Color(red: 0.6, green: 0.4, blue: 0.96)
                )
                .frame(width: 6, height: 6)
                .rotationEffect(.degrees(45))
                .offset(x: 30, y: -125)

            // 部位：左上方高處小菱形星芒粒子
            Rectangle()
                .foregroundStyle(
                    Color(red: 0.7, green: 0.3, blue: 0.96)
                )
                .frame(width: 6, height: 6)
                .rotationEffect(.degrees(45))
                .offset(x: -50, y: -145)

            // 部位：右側中型菱形星芒粒子
            Rectangle()
                .foregroundStyle(
                    Color(red: 0.8, green: 0.53, blue: 0.96)
                )
                .frame(width: 8, height: 8)
                .rotationEffect(.degrees(45))
                .offset(x: 75, y: -90)

            // 部位：右上方細小微粒圓點
            Circle()
                .foregroundStyle(
                    Color(red: 0.6, green: 0.4, blue: 0.8)
                )
                .frame(width: 3.5, height: 3.5)
                .offset(x: 55, y: -135)

            // 部位：左上方細小微粒圓點
            Circle()
                .foregroundStyle(
                    Color(red: 0.8, green: 0.53, blue: 0.96)
                )
                .frame(width: 3.5, height: 3.5)
                .offset(x: -35, y: -110)

            // MARK: 【文字資訊層】底部名稱標題
            VStack {
                Spacer()  // 將文字推擠至視圖下方

                VStack(spacing: 6) {
                    // 中文名稱標題
                    Text("大型雷史萊姆")
                        .font(.system(size: 28, weight: .bold))

                    // 英文名稱副標題
                    Text("Large Electro Slime")
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold,
                                design: .rounded
                            )
                        )
                }
                .foregroundStyle(
                    // 文字藍色漸層效果
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.12, blue: 0.45),
                            Color.blue,
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(
                    color: Color.black.opacity(0.2),
                    radius: 2,
                    x: 0,
                    y: 1
                )  // 文字輕微立體陰影
                .padding(.bottom, 230)  // 與底部的間距留白
            }
        }
    }
}

// MARK: - Xcode 畫布即時預覽
#Preview {
    ContentView()
}

// MARK: - Playground 測試區塊
#Playground {
    _ = 1 + 2
}
