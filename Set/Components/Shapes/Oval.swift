//
//  Oval.swift
//  Set
//
//  Created by Andrew on 1/8/22.
//

import SwiftUI

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let startAngle = Angle(degrees: 90)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.height, rect.width) / 2
        let start = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        let leftTopPoint = CGPoint(
            x: start.x - radius/2,
            y: start.y
        )
        
        
//        p.addRoundedRect(
//            in: rect,
//            cornerSize: CGSize(
//                width: rect.width,
//                height: rect.width
//            )
//        )
        p.move(to: center)
        p.move(to: start)
        p.addLine(to: leftTopPoint)
        p.addArc(center: center, radius: radius, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 90), clockwise: true)
//        p.addLine(to: <#T##CGPoint#>)
        
        return p
    }
}


struct Oval_Previews: PreviewProvider {
    static var previews: some View {
        Oval()
    }
}
