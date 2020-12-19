//
//  InfoView.swift
//  DrinkIt
//
//  Created by Riccardo Cipolleschi on 17/12/2020.
//

import SwiftUI

struct InfoView: View {

  @ObservedObject var model: InfoVM

  var body: some View {
    ZStack {

      Rectangle()
        .foregroundColor(.blue)
        .ignoresSafeArea()
      Image("waterBG")
        .aspectRatio(contentMode: .fill)
        .opacity(0.70)

      VStack(alignment: .center, spacing: 50) {
        HStack {
          Button(action: self.model.dismiss ?? {}) {
            Image(systemName: "xmark")
          }
          .foregroundColor(.white)
          .position(x: 50, y: 30)
          Spacer()
          Text("Water Facts")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .position(x: 0, y: 30)
          Spacer()
        }
        ForEach(model.waterFacts) {
          self.waterReason(text: $0.text, color: $0.color)
        }


        Spacer()
        VStack {
          Text("\(self.model.supportingPeople) People supports DrinkIt")
            .foregroundColor(.white)
            .font(.title3)
          Button(action: self.model.supportApp ?? {}) {
            Text("Support the App: 0.99$")
              .fontWeight(.bold)
              .padding(15)
          }.background(Color.white)
          .cornerRadius(25)
          .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        }
      }
    }
  }

  func waterReason(text: String, color: Color) -> Text {
    Text(text)
      .foregroundColor(color)
      .fontWeight(.semibold)
      .font(.title)

  }
}

struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    InfoView(model: InfoVM())
  }
}
