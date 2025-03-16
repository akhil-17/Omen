//
//  OmenWidgetBundle.swift
//  OmenWidget
//
//  Created by Akhil Dakinedi on 3/16/25.
//

import WidgetKit
import SwiftUI

@main
struct OmenWidgetBundle: WidgetBundle {
    var body: some Widget {
        OmenWidget()
        OmenWidgetControl()
        OmenWidgetLiveActivity()
    }
}
