// Created by HorizonCalendar contributors.
// Copyright © 2024 Airbnb Inc. All rights reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import HorizonCalendar
import UIKit

// MARK: - MonthOverlayDemoViewController

final class MonthOverlayDemoViewController: BaseDemoViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Month Days Overlay"
  }

  override func makeContent() -> CalendarViewContent {
    let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 10))!
    let endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!

    return CalendarViewContent(
      calendar: calendar,
      visibleDateRange: startDate...endDate,
      monthsLayout: monthsLayout
    )
    .interMonthSpacing(24)
    .verticalDayMargin(8)
    .horizontalDayMargin(8)
    .monthOverlayItemProvider { monthLayoutContext in
      guard monthLayoutContext.month.month == 2 else { return nil }
      return MonthDaysTintOverlayView.calendarItemModel(
        invariantViewProperties: .init(),
        content: .init(daysRect: monthLayoutContext.monthDaysAreaBounds)
      )
    }
  }

}

// MARK: - MonthDaysTintOverlayView

final class MonthDaysTintOverlayView: UIView {

  // MARK: Lifecycle

  fileprivate init(invariantViewProperties: InvariantViewProperties) {
    self.invariantViewProperties = invariantViewProperties
    super.init(frame: .zero)
    backgroundColor = .clear
    isUserInteractionEnabled = false

    blurView.clipsToBounds = true
    addSubview(blurView)

    blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [blurView] in
      blurView.effect = UIBlurEffect(style: invariantViewProperties.blurStyle)
    }
    blurAnimator?.fractionComplete = invariantViewProperties.blurIntensity
    blurAnimator?.pausesOnCompletion = true
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    blurAnimator?.stopAnimation(true)
  }

  // MARK: Internal

  override func layoutSubviews() {
    super.layoutSubviews()
    blurView.frame = daysRect ?? .zero
    blurView.isHidden = daysRect == nil
  }

  // MARK: Fileprivate

  fileprivate var daysRect: CGRect? {
    didSet {
      guard daysRect != oldValue else { return }
      setNeedsLayout()
    }
  }

  // MARK: Private

  private let invariantViewProperties: InvariantViewProperties
  private let blurView = UIVisualEffectView()
  private var blurAnimator: UIViewPropertyAnimator?

}

// MARK: CalendarItemViewRepresentable

extension MonthDaysTintOverlayView: CalendarItemViewRepresentable {

  struct InvariantViewProperties: Hashable {
    var blurStyle = UIBlurEffect.Style.extraLight
    var blurIntensity: CGFloat = 0.1
  }

  struct Content: Equatable {
    let daysRect: CGRect?
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties
  ) -> MonthDaysTintOverlayView {
    MonthDaysTintOverlayView(invariantViewProperties: invariantViewProperties)
  }

  static func setContent(_ content: Content, on view: MonthDaysTintOverlayView) {
    view.daysRect = content.daysRect
  }

}
