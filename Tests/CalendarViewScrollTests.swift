// Created by Cursor on 3/16/26.
// Copyright © 2026 Airbnb Inc. All rights reserved.

import XCTest
@testable import HorizonCalendar

// MARK: - CalendarViewScrollTests

final class CalendarViewScrollTests: XCTestCase {

  // MARK: Internal

  func testScrollToDayInNoDaysMonthFallsBackToMonthHeader() throws {
    let calendarView = makeCalendarView()

    let dateInJune = try XCTUnwrap(calendar.date(from: DateComponents(year: 2020, month: 6, day: 15)))
    calendarView.scroll(
      toDayContaining: dateInJune,
      scrollPosition: .centered,
      animated: false
    )

    switch calendarView.scrollToItemContext?.targetItem {
    case .month(let month):
      let expectedMonth = calendar.month(containing: dateInJune)
      XCTAssertEqual(month, expectedMonth, "Should fall back to month header for a .noDays month.")

    default:
      XCTFail("Expected .month target item when scrolling to a day in a .noDays month.")
    }
  }

  func testScrollToHiddenDayOutsidePartialRangeFallsBackToMonthHeader() throws {
    let calendarView = makeCalendarView()

    let hiddenDateInAugust = try XCTUnwrap(calendar.date(from: DateComponents(year: 2020, month: 8, day: 5)))
    calendarView.scroll(
      toDayContaining: hiddenDateInAugust,
      scrollPosition: .centered,
      animated: false
    )

    switch calendarView.scrollToItemContext?.targetItem {
    case .month(let month):
      let expectedMonth = calendar.month(containing: hiddenDateInAugust)
      XCTAssertEqual(
        month,
        expectedMonth,
        "Should fall back to month header for a day hidden by .partialRange."
      )

    default:
      XCTFail("Expected .month target item when scrolling to a day hidden by .partialRange.")
    }
  }

  func testScrollToVisibleDayInPartialRangeUsesDay() throws {
    let calendarView = makeCalendarView()

    let visibleDateInJuly = try XCTUnwrap(calendar.date(from: DateComponents(year: 2020, month: 7, day: 15)))
    calendarView.scroll(
      toDayContaining: visibleDateInJuly,
      scrollPosition: .centered,
      animated: false
    )

    switch calendarView.scrollToItemContext?.targetItem {
    case .day(let day):
      let expectedDay = calendar.day(containing: visibleDateInJuly)
      XCTAssertEqual(day, expectedDay, "Should scroll to the day directly when it is visible.")

    default:
      XCTFail("Expected .day target item when scrolling to a visible day in a .partialRange month.")
    }
  }

  // MARK: Private

  private let calendar = Calendar(identifier: .gregorian)

}

extension CalendarViewScrollTests {
  private func makeCalendarView() -> CalendarView {
    let startDate = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1))!
    let endDate = calendar.date(from: DateComponents(year: 2020, month: 12, day: 31))!

    let june2020 = Month(era: 1, year: 2020, month: 6, isInGregorianCalendar: true)
    let july2020 = Month(era: 1, year: 2020, month: 7, isInGregorianCalendar: true)
    let august2020 = Month(era: 1, year: 2020, month: 8, isInGregorianCalendar: true)

    let content = CalendarViewContent(
      calendar: calendar,
      visibleDateRange: startDate...endDate,
      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
    )
    .monthDayRangeProvider { month in
      if month == june2020 {
        return .noDays
      } else if month == july2020 {
        let lower = self.calendar.date(from: DateComponents(year: 2020, month: 7, day: 10))!
        let upper = self.calendar.date(from: DateComponents(year: 2020, month: 7, day: 20))!
        return .partialRange(lower...upper)
      } else if month == august2020 {
        let lower = self.calendar.date(from: DateComponents(year: 2020, month: 8, day: 15))!
        let upper = self.calendar.date(from: DateComponents(year: 2020, month: 8, day: 25))!
        return .partialRange(lower...upper)
      }
      return nil
    }

    return CalendarView(initialContent: content)
  }
}
