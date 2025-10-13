//
//  DeepFlowWidgetLiveActivity.swift
//  DeepFlowWidget
//
//  Created by Leonardo Guardado Bermúdez on 10/10/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DeepFlowWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DeepFlowWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeepFlowWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DeepFlowWidgetAttributes {
    fileprivate static var preview: DeepFlowWidgetAttributes {
        DeepFlowWidgetAttributes(name: "World")
    }
}

extension DeepFlowWidgetAttributes.ContentState {
    fileprivate static var smiley: DeepFlowWidgetAttributes.ContentState {
        DeepFlowWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DeepFlowWidgetAttributes.ContentState {
         DeepFlowWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DeepFlowWidgetAttributes.preview) {
   DeepFlowWidgetLiveActivity()
} contentStates: {
    DeepFlowWidgetAttributes.ContentState.smiley
    DeepFlowWidgetAttributes.ContentState.starEyes
}
