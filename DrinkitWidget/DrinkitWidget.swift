//
//  DrinkitWidget.swift
//  DrinkitWidget
//
//  Created by Riccardo Cipolleschi on 12/12/2020.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> DrinkitEntry {
    DrinkitEntry(date: Date(), waterDrank: Storage.drankWater)
  }

  func getSnapshot(in context: Context, completion: @escaping (DrinkitEntry) -> ()) {
    let entry = DrinkitEntry(date: Date(), waterDrank: Storage.drankWater)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let entries: [DrinkitEntry] = [
      DrinkitEntry(date: Date(), waterDrank: Storage.drankWater)
    ]
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct DrinkitEntry: TimelineEntry {
  let date: Date
  let waterDrank: Int
  let goal = 2000

  init(date: Date, waterDrank: Int) {
    self.date = date
    self.waterDrank = waterDrank
  }

  var goalMessage: String {
    if waterDrank >= goal {
      return "Goal Achieved!\n\(CGFloat(waterDrank) / 1000.0) L"
    }

    return "\(CGFloat(self.waterDrank) / 1000.0) L / \(CGFloat(self.goal) / 1000.0) L"
  }

  var ratio: CGFloat {
    return CGFloat(self.waterDrank) / CGFloat(self.goal)
  }
}

struct WidgetView : View {
  @Environment(\.widgetFamily) var family: WidgetFamily
  var entry: Provider.Entry

  @ViewBuilder
  var body: some View {
    switch self.family {
    case .systemSmall:
      SmallView(entry: entry)
    case .systemMedium:
      MediumView(entry: entry)
    case .systemLarge:
      LargeView(entry: entry)
    @unknown default:
      SmallView(entry: entry)
    }
  }

  struct SmallView: View {
    var entry: Provider.Entry
    @ViewBuilder
    var body: some View {
    VStack(spacing: 20) {
      Text(entry.goalMessage)
        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
      Text("Add Water")
        .widgetURL(URL(string: "drinkit://widget.co/add")!)
        .foregroundColor(.white)
        .padding(5)
        .background(Color.blue)
        .cornerRadius(5.0)
      }
    }
  }

  struct MediumView: View {
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
      HStack(spacing: 20) {

        Link("-", destination: URL(string: "drinkit://widget.co/rem")!)
          .foregroundColor(.white)
          .padding(5)
          .background(Color.blue)
          .cornerRadius(5.0)
        Text(entry.goalMessage)
          .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
          .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        Link("+", destination: URL(string: "drinkit://widget.co/add")!)
          .foregroundColor(.white)
          .padding(5)
          .background(Color.blue)
          .cornerRadius(5.0)
      }
    }
  }

  struct LargeView: View {
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {

      VStack(spacing: 20) {
        ZStack(alignment: .bottom) {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 104, height: 204, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 2)
          Rectangle()
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 200 * entry.ratio, alignment: .bottom)
            .padding(2)

      }
        HStack(spacing: 20) {
          Link("-", destination: URL(string: "drinkit://widget.co/rem")!)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(Color.blue)
            .cornerRadius(5.0)
          Link("+", destination: URL(string: "drinkit://widget.co/add")!)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
            .background(Color.blue)
            .cornerRadius(5.0)
        }
        .padding(10)
      }
    }
  }
}

@main
struct DrinkitWidget: Widget {
  let kind: String = "DrinkitWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      WidgetView(entry: entry)
    }
    .configurationDisplayName("DrinkIt Widget")
    .description("Widget of the DrinkIt app")
    .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
  }
}

struct DrinkitWidget_Previews: PreviewProvider {
  static var previews: some View {
    WidgetView(entry: DrinkitEntry(date: Date(), waterDrank: 250))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
