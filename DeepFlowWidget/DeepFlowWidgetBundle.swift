//
//  DeepFlowWidgetBundle.swift
//  DeepFlowWidget
//
//  Created by Leonardo Guardado Bermúdez on 10/10/25.
//

import WidgetKit
import SwiftUI

@main
struct DeepFlowWidgetBundle: WidgetBundle {
    var body: some Widget {
        DeepFlowWidget()
        DeepFlowWidgetControl()
        DeepFlowWidgetLiveActivity()
    }
}
