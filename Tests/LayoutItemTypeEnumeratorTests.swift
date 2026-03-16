// Created by Bryan Keller on 4/4/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

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

import XCTest
@testable import HorizonCalendar

// MARK: - LayoutItemTypeEnumeratorTests

final class LayoutItemTypeEnumeratorTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    let lowerBoundMonth = Month(era: 1, year: 2020, month: 11, isInGregorianCalendar: true)
    let upperBoundMonth = Month(era: 1, year: 2021, month: 1, isInGregorianCalendar: true)
    let monthRange = lowerBoundMonth...upperBoundMonth

    let lowerBoundDay = Day(month: lowerBoundMonth, day: 12)
    let upperBoundDay = Day(month: upperBoundMonth, day: 20)
    let dayRange = lowerBoundDay...upperBoundDay

    verticalItemTypeEnumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
      monthRange: monthRange,
      dayRange: dayRange
    )
    verticalPinnedDaysOfWeekItemTypeEnumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: true)),
      monthRange: monthRange,
      dayRange: dayRange
    )
    horizontalItemTypeEnumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .horizontal(
        options: HorizontalMonthsLayoutOptions(maximumFullyVisibleMonths: 305 / 300)
      ),
      monthRange: monthRange,
      dayRange: dayRange
    )

    expectedItemTypeStackBackwards = [
      .dayOfWeekInMonth(
        position: .last,
        month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .sixth,
        month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .fifth,
        month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .fourth,
        month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .third,
        month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .second,
        month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .first,
        month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
      ),
      .monthHeader(Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)),
      .day(calendar.day(byAddingDays: -1, to: startDay)),
      .day(calendar.day(byAddingDays: -2, to: startDay)),
      .day(calendar.day(byAddingDays: -3, to: startDay)),
      .day(calendar.day(byAddingDays: -4, to: startDay)),
      .day(calendar.day(byAddingDays: -5, to: startDay)),
      .day(calendar.day(byAddingDays: -6, to: startDay)),
      .day(calendar.day(byAddingDays: -7, to: startDay)),
      .day(calendar.day(byAddingDays: -8, to: startDay)),
      .day(calendar.day(byAddingDays: -9, to: startDay)),
      .day(calendar.day(byAddingDays: -10, to: startDay)),
      .day(calendar.day(byAddingDays: -11, to: startDay)),
      .day(calendar.day(byAddingDays: -12, to: startDay)),
      .day(calendar.day(byAddingDays: -13, to: startDay)),
      .day(calendar.day(byAddingDays: -14, to: startDay)),
      .day(calendar.day(byAddingDays: -15, to: startDay)),
      .day(calendar.day(byAddingDays: -16, to: startDay)),
      .day(calendar.day(byAddingDays: -17, to: startDay)),
      .day(calendar.day(byAddingDays: -18, to: startDay)),
      .day(calendar.day(byAddingDays: -19, to: startDay)),
    ]

    expectedItemTypeStackForwards = [
      .day(startDay),
      .day(calendar.day(byAddingDays: 1, to: startDay)),
      .day(calendar.day(byAddingDays: 2, to: startDay)),
      .day(calendar.day(byAddingDays: 3, to: startDay)),
      .day(calendar.day(byAddingDays: 4, to: startDay)),
      .day(calendar.day(byAddingDays: 5, to: startDay)),
      .day(calendar.day(byAddingDays: 6, to: startDay)),
      .day(calendar.day(byAddingDays: 7, to: startDay)),
      .day(calendar.day(byAddingDays: 8, to: startDay)),
      .day(calendar.day(byAddingDays: 9, to: startDay)),
      .day(calendar.day(byAddingDays: 10, to: startDay)),
      .day(calendar.day(byAddingDays: 11, to: startDay)),
      .day(calendar.day(byAddingDays: 12, to: startDay)),
      .day(calendar.day(byAddingDays: 13, to: startDay)),
      .day(calendar.day(byAddingDays: 14, to: startDay)),
      .day(calendar.day(byAddingDays: 15, to: startDay)),
      .day(calendar.day(byAddingDays: 16, to: startDay)),
      .day(calendar.day(byAddingDays: 17, to: startDay)),
      .day(calendar.day(byAddingDays: 18, to: startDay)),
      .day(calendar.day(byAddingDays: 19, to: startDay)),
      .day(calendar.day(byAddingDays: 20, to: startDay)),
      .day(calendar.day(byAddingDays: 21, to: startDay)),
      .day(calendar.day(byAddingDays: 22, to: startDay)),
      .day(calendar.day(byAddingDays: 23, to: startDay)),
      .day(calendar.day(byAddingDays: 24, to: startDay)),
      .day(calendar.day(byAddingDays: 25, to: startDay)),
      .day(calendar.day(byAddingDays: 26, to: startDay)),
      .day(calendar.day(byAddingDays: 27, to: startDay)),
      .day(calendar.day(byAddingDays: 28, to: startDay)),
      .day(calendar.day(byAddingDays: 29, to: startDay)),
      .day(calendar.day(byAddingDays: 30, to: startDay)),
      .monthHeader(Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)),
      .dayOfWeekInMonth(
        position: .first,
        month: Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .second,
        month: Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .third,
        month: Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .fourth,
        month: Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .fifth,
        month: Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .sixth,
        month: Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)
      ),
      .dayOfWeekInMonth(
        position: .last,
        month: Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)
      ),
      .day(calendar.day(byAddingDays: 31, to: startDay)),
      .day(calendar.day(byAddingDays: 32, to: startDay)),
      .day(calendar.day(byAddingDays: 33, to: startDay)),
      .day(calendar.day(byAddingDays: 34, to: startDay)),
      .day(calendar.day(byAddingDays: 35, to: startDay)),
      .day(calendar.day(byAddingDays: 36, to: startDay)),
      .day(calendar.day(byAddingDays: 37, to: startDay)),
      .day(calendar.day(byAddingDays: 38, to: startDay)),
      .day(calendar.day(byAddingDays: 39, to: startDay)),
      .day(calendar.day(byAddingDays: 40, to: startDay)),
      .day(calendar.day(byAddingDays: 41, to: startDay)),
      .day(calendar.day(byAddingDays: 42, to: startDay)),
      .day(calendar.day(byAddingDays: 43, to: startDay)),
      .day(calendar.day(byAddingDays: 44, to: startDay)),
      .day(calendar.day(byAddingDays: 45, to: startDay)),
      .day(calendar.day(byAddingDays: 46, to: startDay)),
      .day(calendar.day(byAddingDays: 47, to: startDay)),
      .day(calendar.day(byAddingDays: 48, to: startDay)),
      .day(calendar.day(byAddingDays: 49, to: startDay)),
      .day(calendar.day(byAddingDays: 50, to: startDay)),
    ]
  }

  func testEnumeratingVerticalItems() {
    verticalItemTypeEnumerator.enumerateItemTypes(
      startingAt: .day(startDay),
      itemTypeHandlerLookingBackwards: { itemType, shouldStop in
        let expectedItemType = expectedItemTypeStackBackwards.remove(at: 0)
        XCTAssert(
          itemType == expectedItemType,
          "Unexpected item type encountered while enumerating."
        )

        shouldStop = expectedItemTypeStackBackwards.isEmpty
      },
      itemTypeHandlerLookingForwards: { itemType, shouldStop in
        let expectedItemType = expectedItemTypeStackForwards.remove(at: 0)
        XCTAssert(
          itemType == expectedItemType,
          "Unexpected item type encountered while enumerating."
        )

        shouldStop = expectedItemTypeStackForwards.isEmpty
      }
    )
  }

  func testEnumeratingVerticalPinnedDaysOfWeekItemsBackwards() {
    verticalPinnedDaysOfWeekItemTypeEnumerator.enumerateItemTypes(
      startingAt: .day(startDay),
      itemTypeHandlerLookingBackwards: { itemType, shouldStop in
        var expectedItemType = expectedItemTypeStackBackwards.remove(at: 0)
        // Skip days of the week since they're pinned to the top / outside of individual months
        while case .dayOfWeekInMonth = expectedItemType {
          expectedItemType = expectedItemTypeStackBackwards.remove(at: 0)
        }

        XCTAssert(
          itemType == expectedItemType,
          "Unexpected item type encountered while enumerating."
        )

        shouldStop = expectedItemTypeStackBackwards.isEmpty
      },
      itemTypeHandlerLookingForwards: { itemType, shouldStop in
        var expectedItemType = expectedItemTypeStackForwards.remove(at: 0)
        // Skip days of the week since they're pinned to the top / outside of individual months
        while case .dayOfWeekInMonth = expectedItemType {
          expectedItemType = expectedItemTypeStackForwards.remove(at: 0)
        }

        XCTAssert(
          itemType == expectedItemType,
          "Unexpected item type encountered while enumerating."
        )

        shouldStop = expectedItemTypeStackForwards.isEmpty
      }
    )
  }

  func testEnumeratingHorizontalItemsBackwards() {
    verticalItemTypeEnumerator.enumerateItemTypes(
      startingAt: .day(startDay),
      itemTypeHandlerLookingBackwards: { itemType, shouldStop in
        let expectedItemType = expectedItemTypeStackBackwards.remove(at: 0)
        XCTAssert(
          itemType == expectedItemType,
          "Unexpected item type encountered while enumerating."
        )

        shouldStop = expectedItemTypeStackBackwards.isEmpty
      },
      itemTypeHandlerLookingForwards: { itemType, shouldStop in
        let expectedItemType = expectedItemTypeStackForwards.remove(at: 0)
        XCTAssert(
          itemType == expectedItemType,
          "Unexpected item type encountered while enumerating."
        )

        shouldStop = expectedItemTypeStackForwards.isEmpty
      }
    )
  }

  func testEnumeratingVerticalItemsWithNoDaysMonth() {
    let dec2020 = Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
    let nov2020 = Month(era: 1, year: 2020, month: 11, isInGregorianCalendar: true)
    let jan2021 = Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)

    let monthRange = nov2020...jan2021
    let dayRange = Day(month: nov2020, day: 12)...Day(month: jan2021, day: 20)

    let enumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
      monthRange: monthRange,
      dayRange: dayRange,
      monthDayRange: { month in
        month == dec2020 ? .noDays : nil
      }
    )

    var forwardItems: [LayoutItem.ItemType] = []
    var backwardItems: [LayoutItem.ItemType] = []

    enumerator.enumerateItemTypes(
      startingAt: .monthHeader(dec2020),
      itemTypeHandlerLookingBackwards: { itemType, _ in
        backwardItems.append(itemType)
      },
      itemTypeHandlerLookingForwards: { itemType, _ in
        forwardItems.append(itemType)
      }
    )

    // Forward: Dec header → Jan header (skips Dec days/dow) → Jan dow×7 → Jan 1..20
    XCTAssertEqual(forwardItems.first, .monthHeader(dec2020))
    XCTAssertEqual(forwardItems[1], .monthHeader(jan2021))
    XCTAssertEqual(
      forwardItems[2],
      .dayOfWeekInMonth(position: .first, month: jan2021)
    )

    // Verify no Dec day or dayOfWeek items appear in the forward sequence
    for item in forwardItems {
      if case .day(let day) = item {
        XCTAssertNotEqual(day.month, dec2020, "No Dec days should be enumerated for .noDays month")
      }
      if case .dayOfWeekInMonth(_, let month) = item {
        XCTAssertNotEqual(month, dec2020, "No Dec dayOfWeek should be enumerated for .noDays month")
      }
    }

    // Backward: Nov 30...Nov 12, then Nov dow×7, then Nov header
    // First backward item should be a Nov day (Nov 30)
    XCTAssertEqual(
      backwardItems.first,
      .day(Day(month: nov2020, day: 30))
    )

    // Verify no Dec day items in backward sequence either
    for item in backwardItems {
      if case .day(let day) = item {
        XCTAssertNotEqual(day.month, dec2020, "No Dec days should appear going backwards")
      }
      if case .dayOfWeekInMonth(_, let month) = item {
        XCTAssertNotEqual(month, dec2020, "No Dec dayOfWeek should appear going backwards")
      }
    }

    // Last backward item should be Nov header
    XCTAssertEqual(backwardItems.last, .monthHeader(nov2020))
  }

  func testEnumeratingVerticalItemsWithPartialRangeMonth() {
    let dec2020 = Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
    let nov2020 = Month(era: 1, year: 2020, month: 11, isInGregorianCalendar: true)
    let jan2021 = Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)

    let monthRange = nov2020...jan2021
    let dayRange = Day(month: nov2020, day: 12)...Day(month: jan2021, day: 20)

    let partialLowerDate = calendar.date(from: DateComponents(year: 2020, month: 12, day: 10))!
    let partialUpperDate = calendar.date(from: DateComponents(year: 2020, month: 12, day: 20))!
    let partialDateRange = partialLowerDate...partialUpperDate

    let enumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
      monthRange: monthRange,
      dayRange: dayRange,
      monthDayRange: { month in
        month == dec2020 ? .partialRange(partialDateRange) : nil
      }
    )

    var forwardItems: [LayoutItem.ItemType] = []
    var backwardItems: [LayoutItem.ItemType] = []

    enumerator.enumerateItemTypes(
      startingAt: .monthHeader(dec2020),
      itemTypeHandlerLookingBackwards: { itemType, _ in
        backwardItems.append(itemType)
      },
      itemTypeHandlerLookingForwards: { itemType, _ in
        forwardItems.append(itemType)
      }
    )

    // Forward: Dec header → Dec dow×7 → Dec 10..20 → Jan header → Jan dow×7 → Jan 1..20
    XCTAssertEqual(forwardItems[0], .monthHeader(dec2020))
    XCTAssertEqual(
      forwardItems[1],
      .dayOfWeekInMonth(position: .first, month: dec2020)
    )
    XCTAssertEqual(
      forwardItems[8],
      .day(Day(month: dec2020, day: 10)),
      "First Dec day should be day 10 (start of partial range)"
    )

    // Collect all Dec days from the forward enumeration
    let decDays = forwardItems.compactMap { item -> Day? in
      if case .day(let day) = item, day.month == dec2020 { return day }
      return nil
    }
    XCTAssertEqual(decDays.first?.day, 10)
    XCTAssertEqual(decDays.last?.day, 20)
    XCTAssertEqual(decDays.count, 11)

    // After Dec 20, the next item should be the Jan header
    let indexOfLastDecDay = forwardItems.lastIndex(of: .day(Day(month: dec2020, day: 20)))!
    XCTAssertEqual(forwardItems[indexOfLastDecDay + 1], .monthHeader(jan2021))
  }

  func testEnumeratingHorizontalItemsWithNoDaysMonth() throws {
    let dec2020 = Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
    let nov2020 = Month(era: 1, year: 2020, month: 11, isInGregorianCalendar: true)
    let jan2021 = Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)

    let monthRange = nov2020...jan2021
    let dayRange = Day(month: nov2020, day: 1)...Day(month: jan2021, day: 31)

    let enumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .horizontal(
        options: HorizontalMonthsLayoutOptions(maximumFullyVisibleMonths: 1)
      ),
      monthRange: monthRange,
      dayRange: dayRange,
      monthDayRange: { month in
        month == dec2020 ? .noDays : nil
      }
    )

    var forwardItems: [LayoutItem.ItemType] = []

    enumerator.enumerateItemTypes(
      startingAt: .monthHeader(nov2020),
      itemTypeHandlerLookingBackwards: { _, _ in },
      itemTypeHandlerLookingForwards: { itemType, _ in
        forwardItems.append(itemType)
      }
    )

    for item in forwardItems {
      if case .day(let day) = item {
        XCTAssertNotEqual(
          day.month, dec2020,
          "No Dec days should appear in horizontal layout for .noDays month"
        )
      }
      if case .dayOfWeekInMonth(_, let month) = item {
        XCTAssertNotEqual(
          month, dec2020,
          "No Dec dayOfWeek should appear in horizontal layout for .noDays month"
        )
      }
    }
    let decemberHeaderIndex = try XCTUnwrap(forwardItems.firstIndex { $0 == .monthHeader(dec2020) }, "Dec month header should appear")
    XCTAssertEqual(
      forwardItems[decemberHeaderIndex + 1],
      .monthHeader(jan2021),
      "Jan month header should follow Dec header"
    )
  }

  func testEnumeratingVerticalItemsWithNonOverlappingPartialRange() {
    let nov2020 = Month(era: 1, year: 2020, month: 11, isInGregorianCalendar: true)
    let dec2020 = Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
    let jan2021 = Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)

    let monthRange = nov2020...jan2021
    let dayRange = Day(month: nov2020, day: 12)...Day(month: jan2021, day: 20)

    let nonOverlappingLowerDate = calendar.date(from: DateComponents(year: 2021, month: 6, day: 1))!
    let nonOverlappingUpperDate = calendar.date(from: DateComponents(year: 2021, month: 6, day: 15))!

    let enumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .vertical(options: VerticalMonthsLayoutOptions()),
      monthRange: monthRange,
      dayRange: dayRange,
      monthDayRange: { month in
        month == dec2020 ? .partialRange(nonOverlappingLowerDate...nonOverlappingUpperDate) : nil
      }
    )

    var forwardItems: [LayoutItem.ItemType] = []
    var backwardItems: [LayoutItem.ItemType] = []

    enumerator.enumerateItemTypes(
      startingAt: .monthHeader(dec2020),
      itemTypeHandlerLookingBackwards: { itemType, _ in
        backwardItems.append(itemType)
      },
      itemTypeHandlerLookingForwards: { itemType, _ in
        forwardItems.append(itemType)
      }
    )

    XCTAssertEqual(forwardItems.first, .monthHeader(dec2020))
    XCTAssertEqual(forwardItems[1], .monthHeader(jan2021))
    XCTAssertEqual(
      forwardItems[2],
      .dayOfWeekInMonth(position: .first, month: jan2021)
    )

    for item in forwardItems {
      if case .day(let day) = item {
        XCTAssertNotEqual(
          day.month, dec2020,
          "No Dec days should be enumerated for non-overlapping partialRange month"
        )
      }
      if case .dayOfWeekInMonth(_, let month) = item {
        XCTAssertNotEqual(
          month, dec2020,
          "No Dec dayOfWeek should be enumerated for non-overlapping partialRange month"
        )
      }
    }

    XCTAssertEqual(backwardItems.last, .monthHeader(nov2020))
  }

  func testEnumeratingHorizontalItemsWithNonOverlappingPartialRange() throws {
    let nov2020 = Month(era: 1, year: 2020, month: 11, isInGregorianCalendar: true)
    let dec2020 = Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
    let jan2021 = Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)

    let monthRange = nov2020...jan2021
    let dayRange = Day(month: nov2020, day: 1)...Day(month: jan2021, day: 31)

    let nonOverlappingLowerDate = calendar.date(from: DateComponents(year: 2021, month: 6, day: 1))!
    let nonOverlappingUpperDate = calendar.date(from: DateComponents(year: 2021, month: 6, day: 15))!

    let enumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .horizontal(
        options: HorizontalMonthsLayoutOptions(maximumFullyVisibleMonths: 1)
      ),
      monthRange: monthRange,
      dayRange: dayRange,
      monthDayRange: { month in
        month == dec2020 ? .partialRange(nonOverlappingLowerDate...nonOverlappingUpperDate) : nil
      }
    )

    var forwardItems: [LayoutItem.ItemType] = []

    enumerator.enumerateItemTypes(
      startingAt: .monthHeader(nov2020),
      itemTypeHandlerLookingBackwards: { _, _ in },
      itemTypeHandlerLookingForwards: { itemType, _ in
        forwardItems.append(itemType)
      }
    )

    for item in forwardItems {
      if case .day(let day) = item {
        XCTAssertNotEqual(
          day.month, dec2020,
          "No Dec days should appear in horizontal layout for non-overlapping partialRange"
        )
      }
      if case .dayOfWeekInMonth(_, let month) = item {
        XCTAssertNotEqual(
          month, dec2020,
          "No Dec dayOfWeek should appear in horizontal layout for non-overlapping partialRange"
        )
      }
    }

    let decHeaderIndex = try XCTUnwrap(forwardItems.firstIndex(of: .monthHeader(dec2020)), "Dec month header should still appear")
      XCTAssertEqual(
        forwardItems[decHeaderIndex + 1],
        .monthHeader(jan2021),
        "Jan header should immediately follow Dec header for non-overlapping partialRange"
      )
  }

  func testEnumeratingHorizontalItemsWithPartialRangeMonth() {
    let dec2020 = Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true)
    let nov2020 = Month(era: 1, year: 2020, month: 11, isInGregorianCalendar: true)
    let jan2021 = Month(era: 1, year: 2021, month: 01, isInGregorianCalendar: true)

    let monthRange = nov2020...jan2021
    let dayRange = Day(month: nov2020, day: 1)...Day(month: jan2021, day: 31)

    let partialLowerDate = calendar.date(from: DateComponents(year: 2020, month: 12, day: 15))!
    let partialUpperDate = calendar.date(from: DateComponents(year: 2020, month: 12, day: 25))!

    let enumerator = LayoutItemTypeEnumerator(
      calendar: calendar,
      monthsLayout: .horizontal(
        options: HorizontalMonthsLayoutOptions(maximumFullyVisibleMonths: 1)
      ),
      monthRange: monthRange,
      dayRange: dayRange,
      monthDayRange: { month in
        month == dec2020 ? .partialRange(partialLowerDate...partialUpperDate) : nil
      }
    )

    var forwardItems: [LayoutItem.ItemType] = []

    enumerator.enumerateItemTypes(
      startingAt: .monthHeader(nov2020),
      itemTypeHandlerLookingBackwards: { _, _ in },
      itemTypeHandlerLookingForwards: { itemType, _ in
        forwardItems.append(itemType)
      }
    )

    let decDays = forwardItems.compactMap { item -> Day? in
      if case .day(let day) = item, day.month == dec2020 { return day }
      return nil
    }

    XCTAssertEqual(decDays.first?.day, 15, "First Dec day should be 15")
    XCTAssertEqual(decDays.last?.day, 25, "Last Dec day should be 25")
    XCTAssertEqual(decDays.count, 11, "Should have exactly 11 Dec days (15-25)")

    XCTAssert(
      forwardItems.contains(.monthHeader(jan2021)),
      "Jan header should appear after partial Dec range"
    )
  }

  // MARK: Private

  private let calendar = Calendar(identifier: .gregorian)
  private let startDay = Day(
    month: Month(era: 1, year: 2020, month: 12, isInGregorianCalendar: true),
    day: 1
  )

  // swiftlint:disable implicitly_unwrapped_optional

  private var verticalItemTypeEnumerator: LayoutItemTypeEnumerator!
  private var verticalPinnedDaysOfWeekItemTypeEnumerator: LayoutItemTypeEnumerator!
  private var horizontalItemTypeEnumerator: LayoutItemTypeEnumerator!

  private var expectedItemTypeStackBackwards: [LayoutItem.ItemType]!
  private var expectedItemTypeStackForwards: [LayoutItem.ItemType]!

}
