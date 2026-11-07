// Renders the CmpctWthr app icon (1024×1024; watchOS masks it to a circle).
// Usage: swift Tools/make-icon.swift App/Assets.xcassets/AppIcon.appiconset/AppIcon.png

import AppKit

let size: CGFloat = 1024
let out = CommandLine.arguments.dropFirst().first ?? "AppIcon.png"

let space = CGColorSpace(name: CGColorSpace.sRGB)!
let ctx = CGContext(data: nil, width: Int(size), height: Int(size), bitsPerComponent: 8,
                    bytesPerRow: 0, space: space,
                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

func rgb(_ hex: UInt32, _ alpha: CGFloat = 1) -> CGColor {
    CGColor(srgbRed: CGFloat((hex >> 16) & 0xFF) / 255, green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255, alpha: alpha)
}

// Daytime sky: bright blue at the top, deeper blue at the bottom.
let sky = CGGradient(colorsSpace: space, colors: [rgb(0x4FA3F7), rgb(0x1D4FB8)] as CFArray,
                     locations: [0, 1])!
ctx.drawLinearGradient(sky, start: CGPoint(x: 0, y: size), end: CGPoint(x: 0, y: 0), options: [])

// Thermometer (left of center): white tube and bulb, warm mercury inside.
let tubeX: CGFloat = 330, tubeW: CGFloat = 130
let bulbCenter = CGPoint(x: tubeX + tubeW / 2, y: 300)
let bulbR: CGFloat = 125
ctx.setFillColor(rgb(0xFFFFFF))
ctx.addPath(CGPath(roundedRect: CGRect(x: tubeX, y: bulbCenter.y, width: tubeW, height: 500),
                   cornerWidth: tubeW / 2, cornerHeight: tubeW / 2, transform: nil))
ctx.fillPath()
ctx.fillEllipse(in: CGRect(x: bulbCenter.x - bulbR, y: bulbCenter.y - bulbR, width: bulbR * 2, height: bulbR * 2))

let mercury = rgb(0xFF6A3D)
let inset: CGFloat = 32
ctx.setFillColor(mercury)
ctx.addPath(CGPath(roundedRect: CGRect(x: tubeX + inset, y: bulbCenter.y, width: tubeW - inset * 2, height: 330),
                   cornerWidth: (tubeW - inset * 2) / 2, cornerHeight: (tubeW - inset * 2) / 2, transform: nil))
ctx.fillPath()
let innerR = bulbR - inset
ctx.fillEllipse(in: CGRect(x: bulbCenter.x - innerR, y: bulbCenter.y - innerR, width: innerR * 2, height: innerR * 2))

// Tick marks on the tube's right side.
ctx.setStrokeColor(rgb(0xFFFFFF, 0.9))
ctx.setLineWidth(18)
ctx.setLineCap(.round)
for y in stride(from: 560.0, through: 740.0, by: 60.0) {
    ctx.move(to: CGPoint(x: tubeX + tubeW + 28, y: y))
    ctx.addLine(to: CGPoint(x: tubeX + tubeW + 78, y: y))
}
ctx.strokePath()

// Water drop (right of center): pointed top, round bottom.
let dropCenter = CGPoint(x: 700, y: 400)
let dropR: CGFloat = 130
let drop = CGMutablePath()
drop.move(to: CGPoint(x: dropCenter.x, y: dropCenter.y + dropR * 2.25))   // tip
drop.addCurve(to: CGPoint(x: dropCenter.x + dropR, y: dropCenter.y),
              control1: CGPoint(x: dropCenter.x + dropR * 0.35, y: dropCenter.y + dropR * 1.5),
              control2: CGPoint(x: dropCenter.x + dropR, y: dropCenter.y + dropR * 0.75))
drop.addArc(center: dropCenter, radius: dropR, startAngle: 0, endAngle: .pi, clockwise: true)
drop.addCurve(to: CGPoint(x: dropCenter.x, y: dropCenter.y + dropR * 2.25),
              control1: CGPoint(x: dropCenter.x - dropR, y: dropCenter.y + dropR * 0.75),
              control2: CGPoint(x: dropCenter.x - dropR * 0.35, y: dropCenter.y + dropR * 1.5))
drop.closeSubpath()
ctx.addPath(drop)
ctx.setFillColor(rgb(0x9BE7FF))
ctx.fillPath()

// Highlight on the drop.
ctx.setFillColor(rgb(0xFFFFFF, 0.55))
ctx.fillEllipse(in: CGRect(x: dropCenter.x - 75, y: dropCenter.y - 10, width: 50, height: 80))

let image = ctx.makeImage()!
let rep = NSBitmapImageRep(cgImage: image)
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
print("wrote \(out)")
