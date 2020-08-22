//
//  ColorExtension.swift
//  AYSwiftUIElements
//
//  Created by Alan Yan on 2020-06-07.
//  Copyright © 2020 Alan Yan. All rights reserved.
//

import SwiftUI

extension Color {
    init(hex: Int) {
        let blue = hex % 256
        let green = (hex >> 8) % 256
        let red = (hex >> 16)
        self.init(red: Double(red)/255, green: Double(green)/255, blue: Double(blue)/255)
    }
    
    static var customPrimary: Color {
        return Color(hex: 0xD8EAFD)
    }
    static var customSecondary: Color {
        return Color(hex: 0x9EC1E6)
    }
    static var customTernary: Color {
        return Color(hex: 0x1E344B)
    }
    static var customWhite: Color {
        return Color(hex: 0xFFFFFF)
    }
    static var bottomLeftGradient: Color {
        return Color(hex: 0xEC9E51)
    }
    static var topRightGradient: Color {
        return Color(hex: 0xF9EB6B)
    }
    static var darkTextColor: Color {
        return Color(hex: 0x5D2F00)
    }
    static var customOrange: Color {
        return Color(hex: 0xFD7C00)
    }
    static var regularGradient: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [bottomLeftGradient, topRightGradient]), startPoint: .bottomLeading, endPoint: .topTrailing)
    }
    static var topGradient: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [bottomLeftGradient, topRightGradient]), startPoint: .topLeading, endPoint: .topTrailing)
    }
    static var radialGradient: RadialGradient {
        return RadialGradient(gradient: Gradient(colors: [bottomLeftGradient, topRightGradient]), center: .topLeading, startRadius: 0, endRadius: 800)
    }
}


struct RoundedCorners: View {
    var color: Color = .blue
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    var body: some View {
        GeometryReader { geometry in
            Path { path in

                let w = geometry.size.width
                let h = geometry.size.height

                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)

                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}

struct RoundedCornersShape: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.size.width
        let h = rect.size.height

        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)

        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)

        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)

        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)

        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)

        return path
    }
}
struct ColorExtension_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}


struct GeometryGetter: View {
    @Binding var rect: CGRect

    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }

    func makeView(geometry: GeometryProxy) -> some View {
        let newRect = geometry.frame(in: .global)
        DispatchQueue.main.async {
            if abs(self.rect.width - newRect.width) > 5 || abs(self.rect.height - newRect.height) > 5
                || abs(self.rect.midX - newRect.midX) > 20 || abs(self.rect.midY - newRect.midY) > 20 {
                self.rect = newRect
            }
        }

        return Rectangle().fill(Color.clear)
    }
}
