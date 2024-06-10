import SwiftUI

struct HideAdsToggle<Content: View>: View {
    @Binding var isOn: Bool
    var label: Content

    init(isOn: Binding<Bool>, @ViewBuilder label: () -> Content) {
        self._isOn = isOn
        self.label = label()
    }

    var body: some View {
        Toggle(isOn: $isOn) {
            label
        }
        .toggleStyle(HideAdsToggleStyle())
    }
}

struct HideAdsToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 60, height: 30, alignment: .center)
                .overlay(
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 15 : -15, y: 0)
                        .animation(.linear(duration: 0.15), value: configuration.isOn)
                )
                .foregroundColor(
                    configuration.isOn ? Color.accentColor : Color(hex: "#BCC9D2")
                )
                .onHover { inside in
                    if inside {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                .onTapGesture(perform: {
                    configuration.isOn.toggle()
                })

        }
    }

}

struct HideAdsToggle_Previews: PreviewProvider {
    @State static var isOn: Bool = true
    @State static var isOn2: Bool = false

    static var previews: some View {
        VStack {
            HideAdsToggle(isOn: $isOn) {
                Text("On")
            }
            HideAdsToggle(isOn: $isOn2) {
                Text("Off")
            }
        }
    }
}
