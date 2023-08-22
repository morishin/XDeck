import SwiftUI

struct MoonIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.68331*width, y: 0.67022*height))
        path.addCurve(to: CGPoint(x: 0.32978*width, y: 0.67022*height), control1: CGPoint(x: 0.58591*width, y: 0.76772*height), control2: CGPoint(x: 0.42728*width, y: 0.76772*height))
        path.addCurve(to: CGPoint(x: 0.32978*width, y: 0.31666*height), control1: CGPoint(x: 0.23228*width, y: 0.57272*height), control2: CGPoint(x: 0.23228*width, y: 0.41412*height))
        path.addCurve(to: CGPoint(x: 0.42319*width, y: 0.25844*height), control1: CGPoint(x: 0.35559*width, y: 0.29091*height), control2: CGPoint(x: 0.38703*width, y: 0.27125*height))
        path.addCurve(to: CGPoint(x: 0.45566*width, y: 0.26584*height), control1: CGPoint(x: 0.43459*width, y: 0.25444*height), control2: CGPoint(x: 0.44719*width, y: 0.25734*height))
        path.addCurve(to: CGPoint(x: 0.46306*width, y: 0.29831*height), control1: CGPoint(x: 0.46422*width, y: 0.27437*height), control2: CGPoint(x: 0.46709*width, y: 0.287*height))
        path.addCurve(to: CGPoint(x: 0.50653*width, y: 0.49347*height), control1: CGPoint(x: 0.43856*width, y: 0.36741*height), control2: CGPoint(x: 0.45525*width, y: 0.44219*height))
        path.addCurve(to: CGPoint(x: 0.70169*width, y: 0.53694*height), control1: CGPoint(x: 0.55772*width, y: 0.54469*height), control2: CGPoint(x: 0.6325*width, y: 0.56134*height))
        path.addCurve(to: CGPoint(x: 0.73416*width, y: 0.54434*height), control1: CGPoint(x: 0.713*width, y: 0.53291*height), control2: CGPoint(x: 0.72566*width, y: 0.53581*height))
        path.addCurve(to: CGPoint(x: 0.74153*width, y: 0.57681*height), control1: CGPoint(x: 0.74269*width, y: 0.55281*height), control2: CGPoint(x: 0.74556*width, y: 0.56547*height))
        path.addCurve(to: CGPoint(x: 0.68331*width, y: 0.67022*height), control1: CGPoint(x: 0.72878*width, y: 0.61297*height), control2: CGPoint(x: 0.70909*width, y: 0.64444*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.37397*width, y: 0.36084*height))
        path.addCurve(to: CGPoint(x: 0.37397*width, y: 0.62603*height), control1: CGPoint(x: 0.30084*width, y: 0.43397*height), control2: CGPoint(x: 0.30084*width, y: 0.55294*height))
        path.addCurve(to: CGPoint(x: 0.65325*width, y: 0.61009*height), control1: CGPoint(x: 0.45209*width, y: 0.70419*height), control2: CGPoint(x: 0.58516*width, y: 0.69716*height))
        path.addCurve(to: CGPoint(x: 0.46234*width, y: 0.53766*height), control1: CGPoint(x: 0.58303*width, y: 0.6145*height), control2: CGPoint(x: 0.51384*width, y: 0.58913*height))
        path.addCurve(to: CGPoint(x: 0.38991*width, y: 0.34678*height), control1: CGPoint(x: 0.41084*width, y: 0.48619*height), control2: CGPoint(x: 0.38553*width, y: 0.417*height))
        path.addCurve(to: CGPoint(x: 0.37397*width, y: 0.36087*height), control1: CGPoint(x: 0.38428*width, y: 0.35119*height), control2: CGPoint(x: 0.37897*width, y: 0.35584*height))
        path.closeSubpath()
        return path
    }
}
