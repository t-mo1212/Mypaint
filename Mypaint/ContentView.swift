//
//  ContentView.swift
//  Mypaint
//
//  Created by 白川琢茂 on 2021/01/11.
//

import SwiftUI

// メイン画面処理
struct ContentView: View {
    @State var isDrawing: Drawer = Drawer()
    @State var drawers: [Drawer] = [Drawer]()
    @State var colorSet: Color = Color.blue
    @State var drawWidth: CGFloat = 4.0
    
    var body: some View {
        VStack(spacing:nil){
            DrawingArea(isDrawing: $isDrawing,
                        drawers: $drawers,
                        colorSet: $colorSet,
                        drawWidth: $drawWidth)
            HStack(alignment: .bottom,spacing:20) {
            Button(action: {
                self.isDrawing = Drawer()
                self.drawers = [Drawer]()
            }, label: {
                Text("Clear")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding(.all)
                    .frame(width: 160.0, height: 40.0)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.gray/*@END_MENU_TOKEN@*/)
                    .cornerRadius(/*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/)
            })
            }
        }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .edgesIgnoringSafeArea(.all)
        }
}
// プレビュー用
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
// 点の位置情報を取得
struct Drawer{
    var points:[CGPoint] = [CGPoint]()
}

//
struct DrawingArea: View {
    @Binding var isDrawing: Drawer
    @Binding var drawers: [Drawer]
    @Binding var colorSet: Color
    @Binding var drawWidth: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { linePath in
                for Drawer in self.drawers {
                    self.addAction(Drawer: Drawer, toPath: &linePath)
                }
                self.addAction(Drawer: self.isDrawing, toPath: &linePath)
            }
                .stroke(self.colorSet, lineWidth: self.drawWidth)
                .background(Color.white)
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .gesture(
                    DragGesture(minimumDistance: 0.05)
                        .onChanged({ (value) in
                            let currentPoint = value.location
                            if currentPoint.y >= 0 && currentPoint.y < geometry.size.height {
                                self.isDrawing.points.append(currentPoint)
                            }
                        })
                        .onEnded({ (value) in
                            self.drawers.append(self.isDrawing)
                            self.isDrawing = Drawer()
                        })
                    )
        }
    }
// 点と点を繋げる
    func addAction(Drawer: Drawer, toPath linePath: inout Path) {
                let points = Drawer.points
                if points.count > 1 {
                    for i in 0..<points.count-1 {
                        let previous = points[i]
                        let next = points[i+1]
                        linePath.move(to: previous)
                        linePath.addLine(to: next)
                    }
                }
            }
}


    
