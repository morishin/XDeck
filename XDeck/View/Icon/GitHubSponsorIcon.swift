// Created by https://svg-to-swiftui.quassum.com/
import SwiftUI

struct GitHubSponsorIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.73438*width, y: 0.06246*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.18871*height), control1: CGPoint(x: 0.63771*width, y: 0.06246*height), control2: CGPoint(x: 0.55296*width, y: 0.11258*height))
        path.addCurve(to: CGPoint(x: 0.26563*width, y: 0.06246*height), control1: CGPoint(x: 0.44704*width, y: 0.11258*height), control2: CGPoint(x: 0.36229*width, y: 0.06246*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.34371*height), control1: CGPoint(x: 0.13037*width, y: 0.06246*height), control2: CGPoint(x: 0, y: 0.17721*height))
        path.addCurve(to: CGPoint(x: 0.24283*width, y: 0.76983*height), control1: CGPoint(x: 0, y: 0.52183*height), control2: CGPoint(x: 0.12783*width, y: 0.67067*height))
        path.addLine(to: CGPoint(x: 0.478*width, y: 0.93204*height))
        path.addLine(to: CGPoint(x: 0.47833*width, y: 0.93217*height))
        path.addLine(to: CGPoint(x: 0.47829*width, y: 0.93229*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.9375*height), control1: CGPoint(x: 0.48508*width, y: 0.93583*height), control2: CGPoint(x: 0.49254*width, y: 0.93754*height))
        path.addCurve(to: CGPoint(x: 0.52171*width, y: 0.93229*height), control1: CGPoint(x: 0.50746*width, y: 0.93754*height), control2: CGPoint(x: 0.51492*width, y: 0.93579*height))
        path.addLine(to: CGPoint(x: 0.52167*width, y: 0.93217*height))
        path.addLine(to: CGPoint(x: 0.522*width, y: 0.93204*height))
        path.addLine(to: CGPoint(x: 0.52317*width, y: 0.93133*height))
        path.addCurve(to: CGPoint(x: width, y: 0.34371*height), control1: CGPoint(x: 0.87217*width, y: 0.67067*height), control2: CGPoint(x: width, y: 0.52183*height))
        path.addCurve(to: CGPoint(x: 0.73438*width, y: 0.06246*height), control1: CGPoint(x: width, y: 0.17721*height), control2: CGPoint(x: 0.86962*width, y: 0.06246*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.69608*width, y: 0.69892*height))
        path.addLine(to: CGPoint(x: 0.49996*width, y: 0.837*height))
        path.addLine(to: CGPoint(x: 0.49979*width, y: 0.83708*height))
        path.addCurve(to: CGPoint(x: 0.09354*width, y: 0.34379*height), control1: CGPoint(x: 0.19229*width, y: 0.60279*height), control2: CGPoint(x: 0.09354*width, y: 0.47817*height))
        path.addCurve(to: CGPoint(x: 0.26542*width, y: 0.15629*height), control1: CGPoint(x: 0.09354*width, y: 0.22904*height), control2: CGPoint(x: 0.18192*width, y: 0.15629*height))
        path.addCurve(to: CGPoint(x: 0.45475*width, y: 0.30979*height), control1: CGPoint(x: 0.35125*width, y: 0.15629*height), control2: CGPoint(x: 0.4285*width, y: 0.21792*height))
        path.addCurve(to: CGPoint(x: 0.5*width, y: 0.34296*height), control1: CGPoint(x: 0.46071*width, y: 0.33042*height), control2: CGPoint(x: 0.47958*width, y: 0.343*height))
        path.addCurve(to: CGPoint(x: 0.54521*width, y: 0.30979*height), control1: CGPoint(x: 0.52042*width, y: 0.343*height), control2: CGPoint(x: 0.53929*width, y: 0.33038*height))
        path.addCurve(to: CGPoint(x: 0.73454*width, y: 0.15629*height), control1: CGPoint(x: 0.57146*width, y: 0.21792*height), control2: CGPoint(x: 0.64871*width, y: 0.15629*height))
        path.addCurve(to: CGPoint(x: 0.90642*width, y: 0.34379*height), control1: CGPoint(x: 0.81804*width, y: 0.15629*height), control2: CGPoint(x: 0.90642*width, y: 0.22904*height))
        path.addCurve(to: CGPoint(x: 0.69608*width, y: 0.69892*height), control1: CGPoint(x: 0.90642*width, y: 0.47817*height), control2: CGPoint(x: 0.80767*width, y: 0.60279*height))
        path.closeSubpath()
        return path
    }
}
