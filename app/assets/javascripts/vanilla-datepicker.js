/*!
 * Vanilla JS Datepicker v1.2.0
 * https://github.com/mymth/vanillajs-datepicker
 *
 * @license MIT
 * Copyright 2019 Hidenao Miyamoto
 */
(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(exports) :
  typeof define === 'function' && define.amd ? define(['exports'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.Datepicker = {}));
}(this, (function (exports) { 'use strict';

  function hasProperty(obj, prop) {
    return Object.prototype.hasOwnProperty.call(obj, prop);
  }

  function lastItemOf(arr) {
    return arr[arr.length - 1];
  }

  // push only the items not included in the array
  function pushUnique(arr, ...items) {
    items.forEach((item) => {
      if (arr.includes(item)) {
        return;
      }
      arr.push(item);
    });
    return arr;
  }

  function stringToArray(str, separator) {
    // convert empty string to an empty array
    return str ? str.split(separator) : [];
  }

  function isInRange(testVal, min, max) {
    const minOK = min === undefined || testVal >= min;
    const maxOK = max === undefined || testVal <= max;
    return minOK && maxOK;
  }

  function limitToRange(val, min, max) {
    if (val < min) {
      return min;
    }
    if (val > max) {
      return max;
    }
    return val;
  }

  function createTagRepeat(tagName, repeat, attributes = {}, index = 0, html = '') {
    const openTagSrc = Object.keys(attributes).reduce((src, attr) => {
      let val = attributes[attr];
      if (typeof val === 'function') {
        val = val(index);
      }
      return `${src} ${attr}="${val}"`;
    }, tagName);
    html += `<${openTagSrc}></${tagName}>`;

    const next = index + 1;
    return next < repeat
      ? createTagRepeat(tagName, repeat, attributes, next, html)
      : html;
  }

  // Remove the spacing surrounding tags for HTML parser not to create text nodes
  // before/after elements
  function optimizeTemplateHTML(html) {
    return html.replace(/>\s+/g, '>').replace(/\s+</, '<');
  }

  function stripTime(timeValue) {
    return new Date(timeValue).setHours(0, 0, 0, 0);
  }

  function today() {
    return new Date().setHours(0, 0, 0, 0);
  }

  // Get the time value of the start of given date or year, month and day
  function dateValue(...args) {
    switch (args.length) {
      case 0:
        return today();
      case 1:
        return stripTime(args[0]);
    }

    // use setFullYear() to keep 2-digit year from being mapped to 1900-1999
    const newDate = new Date(0);
    newDate.setFullYear(...args);
    return newDate.setHours(0, 0, 0, 0);
  }

  function addDays(date, amount) {
    const newDate = new Date(date);
    return newDate.setDate(newDate.getDate() + amount);
  }

  function addWeeks(date, amount) {
    return addDays(date, amount * 7);
  }

  function addMonths(date, amount) {
    // If the day of the date is not in the new month, the last day of the new
    // month will be returned. e.g. Jan 31 + 1 month → Feb 28 (not Mar 3)
    const newDate = new Date(date);
    const monthsToSet = newDate.getMonth() + amount;
    let expectedMonth = monthsToSet % 12;
    if (expectedMonth < 0) {
      expectedMonth += 12;
    }

    const time = newDate.setMonth(monthsToSet);
    return newDate.getMonth() !== expectedMonth ? newDate.setDate(0) : time;
  }

  function addYears(date, amount) {
    // If the date is Feb 29 and the new year is not a leap year, Feb 28 of the
    // new year will be returned.
    const newDate = new Date(date);
    const expectedMonth = newDate.getMonth();
    const time = newDate.setFullYear(newDate.getFullYear() + amount);
    return expectedMonth === 1 && newDate.getMonth() === 2 ? newDate.setDate(0) : time;
  }

  // Calculate the distance bettwen 2 days of the week
  function dayDiff(day, from) {
    return (day - from + 7) % 7;
  }

  // Get the date of the specified day of the week of given base date
  function dayOfTheWeekOf(baseDate, dayOfWeek, weekStart = 0) {
    const baseDay = new Date(baseDate).getDay();
    return addDays(baseDate, dayDiff(dayOfWeek, weekStart) - dayDiff(baseDay, weekStart));
  }

  // Get the ISO week number of a date (1-53)
  // based on https://en.wikipedia.org/wiki/ISO_week_date#Calculating_the_week_number_from_a_month_and_day_of_the_month_or_ordinal_date
  function getWeek(date) {
    // get day of the first Thursday of the year
    const thuOfTheFirstWeek = dayOfTheWeekOf(new Date(new Date(date).getFullYear(), 0, 4), 4, 1);
    const firstMonday = addDays(thuOfTheFirstWeek, -3);
    const daysDiff = (date - firstMonday) / 86400000;
    return Math.floor(daysDiff / 7) + 1;
  }

  // Get the start and end dates of given month
  function monthRange(year, month) {
    if (month > 11) {
      throw new RangeError('Invalid month value');
    }
    const start = dateValue(year, month, 1);
    const end = dateValue(year, month + 1, 0);
    return [start, end];
  }

  // Get the start and end dates of given quarter
  function quarterRange(year, quarter) {
    if (quarter > 4) {
      throw new RangeError('Invalid quarter value');
    }
    const month = quarter * 3 - 3;
    return [dateValue(year, month, 1), dateValue(year, month + 3, 0)];
  }

  // Get the start and end dates of given year
  function yearRange(year) {
    return [dateValue(year, 0, 1), dateValue(year, 11, 31)];
  }

  // format Date object or time value in given format and language
  function formatDate(date, format, lang) {
    return lang.format(date, format);
  }

  // parse date string
  function parseDate(dateStr, format, lang) {
    return lang.parse(dateStr, format);
  }

  // @see https://en.wikipedia.org/wiki/Fiscal_year
  function getFiscalYearStart(date, startMonth = 0) {
    const year = new Date(date).getFullYear();
    return dateValue(startMonth > 0 && new Date(date).getMonth() >= startMonth ? year : year - 1, startMonth, 1);
  }

  // Get the number of days in a month
  function getDaysInMonth(date) {
    return new Date(new Date(date).getFullYear(), new Date(date).getMonth() + 1, 0).getDate();
  }

  // provided by datepicker.js
  const defaultOptions = {
    autohide: false,
    beforeShowDay: null,
    beforeShowDecade: null,
    beforeShowMonth: null,
    beforeShowYear: null,
    calendarWeeks: false,
    clearBtn: false,
    dateDelimiter: ',',
    datesDisabled: [],
    daysOfWeekDisabled: [],
    daysOfWeekHighlighted: [],
    defaultViewDate: undefined, // placeholder, defaults to today() by the program
    disableTouchKeyboard: false,
    format: 'mm/dd/yyyy',
    language: 'en',
    maxDate: null,
    maxNumberOfDates: 1,
    maxView: 3,
    minDate: null,
    nextArrow: '»',
    orientation: 'auto',
    pickLevel: 0,
    prevArrow: '«',
    showDaysOfWeek: true,
    showOnClick: true,
    showOnFocus: true,
    startView: 0,
    title: '',
    todayBtn: false,
    todayBtnMode: 0,
    todayHighlight: false,
    updateOnBlur: true,
    weekStart: 0,
  };

  const range = document.createRange();

  function parseHTML(html) {
    return range.createContextualFragment(html);
  }

  function hideElement(element) {
    if (!(element instanceof HTMLElement)) {
      return;
    }
    element.style.display = 'none';
  }

  function showElement(element) {
    if (!(element instanceof HTMLElement)) {
      return;
    }
    element.style.display = '';
  }

  function isVisible(element) {
    if (!(element instanceof HTMLElement)) {
      return false;
    }
    return element.style.display !== 'none';
  }

  function emptyChildNodes(el) {
    if (!(el instanceof HTMLElement)) {
      return;
    }
    while (el.firstChild) {
      el.removeChild(el.firstChild);
    }
  }

  // Replace the children of element with newChildren
  function replaceChildNodes(element, newChildren) {
    emptyChildNodes(element);
    if (newChildren instanceof DocumentFragment) {
      element.appendChild(newChildren);
    } else if (newChildren instanceof Node) {
      element.appendChild(newChildren);
    } else if (typeof newChildren === 'string') {
      element.appendChild(parseHTML(newChildren));
    } else if (newChildren) {
      element.append(...newChildren);
    }
  }

  const directionPadding = 4;

  // Check if element's first child element is fully visible in the container
  function isOnScreen(container, element) {
    const containerRect = container.getBoundingClientRect();
    const elementRect = element.getBoundingClientRect();
    const containerComputedStyle = window.getComputedStyle(container);
    const containerBorderLeftWidth = parseInt(containerComputedStyle.borderLeftWidth, 10);
    const containerBorderTopWidth = parseInt(containerComputedStyle.borderTopWidth, 10);
    const containerBorderRightWidth = parseInt(containerComputedStyle.borderRightWidth, 10);
    const containerBorderBottomWidth = parseInt(containerComputedStyle.borderBottomWidth, 10);
    const elementComputedStyle = window.getComputedStyle(element);
    const elementMarginLeft = parseInt(elementComputedStyle.marginLeft, 10);
    const elementMarginTop = parseInt(elementComputedStyle.marginTop, 10);
    const elementMarginRight = parseInt(elementComputedStyle.marginRight, 10);
    const elementMarginBottom = parseInt(elementComputedStyle.marginBottom, 10);

    const containerRect2 = {
      left: containerRect.left + containerBorderLeftWidth,
      top: containerRect.top + containerBorderTopWidth,
      right: containerRect.right - containerBorderRightWidth,
      bottom: containerRect.bottom - containerBorderBottomWidth
    };
    const elementRect2 = {
      left: elementRect.left - elementMarginLeft,
      top: elementRect.top - elementMarginTop,
      right: elementRect.right + elementMarginRight,
      bottom: elementRect.bottom + elementMarginBottom
    };

    return containerRect2.left <= elementRect2.left + directionPadding
      && elementRect2.right - directionPadding <= containerRect2.right
      && containerRect2.top <= elementRect2.top + directionPadding
      && elementRect2.bottom - directionPadding <= containerRect2.bottom;
  }

  function dateToLocalDateString(date, calendar, locale) {
    return (calendar && calendar.toLocalDateString(date, locale))
      || (date.getMonth() + 1 + '/' + date.getDate() + '/' + date.getFullYear());
  }

  function cleanDate(date) {
    return new Date(date.getFullYear(), date.getMonth(), date.getDate());
  }

  // Parse `date` which can be
  // - Date object
  // - time value
  // - string in date or datetime format or a format parsable by Date.parse()
  // - null (=> today)
  function parseInputDate(date, format, locale, calendar) {
    if (date === null) {
      return new Date();
    }
    if (date === undefined) {
      return undefined;
    }
    if (date instanceof Date) {
      return cleanDate(date);
    }
    if (typeof date === 'number') {
      return cleanDate(new Date(date));
    }
    if (typeof date === 'string') {
      const parsedDate = parseDate(date, format, locale, calendar);
      if (parsedDate !== undefined) {
        return cleanDate(parsedDate);
      }
      return cleanDate(new Date(date));
    }
    return undefined;
  }

  // Get the distance in days from input date to the reference date
  function computeRelativeDist(date, refDate) {
    const newDate = new Date(date);
    const newRefDate = new Date(refDate);
    return Math.round((newDate.getTime() - newRefDate.getTime()) / 86400000);
  }

  function registerListeners(listeners, target, options) {
    Object.keys(listeners).forEach((eventType) => {
      target.addEventListener(eventType, listeners[eventType], options);
    });
  }

  function unregisterListeners(listeners, target) {
    Object.keys(listeners).forEach((eventType) => {
      target.removeEventListener(eventType, listeners[eventType]);
    });
  }

  function findElementInEventPath(ev, selector) {
    const path = ev.composedPath ? ev.composedPath() : composedPath(ev.target);
    return path.find(el => el instanceof HTMLElement && el.matches(selector));
  }

  // Simplified polyfill for Event.composedPath() for browsers that don't support it (IE)
  // from https://gist.github.com/rockinghelvetica/00b9f7b5c97a16d3de75ba99192ff05c
  function composedPath(el) {
    const path = [];
    while (el) {
      path.push(el);
      if (el.tagName === 'HTML') {
        path.push(document);
        path.push(window);
        return path;
      }
      el = el.parentElement;
    }
    return path;
  }

  // Return the element whose scrolling area is scrolled
  function getScrollParent(element) {
    if (element instanceof HTMLBodyElement) {
      return window;
    }
    const style = window.getComputedStyle(element);
    const excludeStaticParent = style.position === 'absolute';
    const overflowRegex = /(auto|scroll)/;

    if (style.position === 'fixed') {
      return window;
    }
    for (let parent = element; (parent = parent.parentElement);) {
      const style = window.getComputedStyle(parent);
      if (excludeStaticParent && style.position === 'static') {
        continue;
      }
      if (overflowRegex.test(style.overflow + style.overflowY + style.overflowX)) {
        return parent;
      }
    }
    return window;
  }

  // Calculate the offset from document.body of an element
  function computeRelativePosition(element, container) {
    const elementRect = element.getBoundingClientRect();
    const containerRect = container.getBoundingClientRect();
    return {
      top: elementRect.top - containerRect.top,
      left: elementRect.left - containerRect.left,
    };
  }

  // Create a Datepicker instance for each target element in the selector
  function createDatepickerInstance(element, options) {
    if (element._datepicker) {
      return element._datepicker;
    }
    return new Datepicker(element, options);
  }

  // Shortcut functions for date arithmetic
  const date = {
    addDays,
    addWeeks,
    addMonths,
    addYears,
    dayDiff,
    dayOfTheWeekOf,
    getWeek,
    monthRange,
    quarterRange,
    yearRange,
    formatDate,
    parseDate,
    getFiscalYearStart,
    getDaysInMonth,
  };

  // Shortcut functions for DOM manipulation
  const dom = {
    parseHTML,
    hideElement,
    showElement,
    isVisible,
    emptyChildNodes,
    replaceChildNodes,
    isOnScreen,
    dateToLocalDateString,
    cleanDate,
    parseInputDate,
    computeRelativeDist,
    registerListeners,
    unregisterListeners,
    findElementInEventPath,
    getScrollParent,
    computeRelativePosition,
    createDatepickerInstance,
  };

  // language
  const defaultLang = {
    days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    daysMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
    months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
    monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
    today: "Today",
    clear: "Clear",
    titleFormat: "MM y",
    format: "mm/dd/yyyy",
    weekStart: 0
  };

  // Class representing the picker UI
  class Datepicker {
    constructor(element, options = {}) {
      this.element = element;
      this.options = Object.assign({}, defaultOptions, options);
      this.lang = defaultLang;
      this.viewDate = new Date();
      this.selectedDates = [];
      this.isInput = this.element.tagName.toLowerCase() === 'input';
      this.inline = !this.isInput;
      this.inputField = this.isInput ? this.element : this.element.querySelector('input');
      this.container = document.createElement('div');
      this.container.className = 'datepicker';
      this.calendar = document.createElement('div');
      this.calendar.className = 'datepicker-calendar';
      this.container.appendChild(this.calendar);
      this.header = document.createElement('div');
      this.header.className = 'datepicker-header';
      this.calendar.appendChild(this.header);
      this.title = document.createElement('div');
      this.title.className = 'datepicker-title';
      this.header.appendChild(this.title);
      this.prevBtn = document.createElement('button');
      this.prevBtn.className = 'datepicker-prev-btn';
      this.prevBtn.innerHTML = this.options.prevArrow;
      this.header.appendChild(this.prevBtn);
      this.nextBtn = document.createElement('button');
      this.nextBtn.className = 'datepicker-next-btn';
      this.nextBtn.innerHTML = this.options.nextArrow;
      this.header.appendChild(this.nextBtn);
      this.view = document.createElement('div');
      this.view.className = 'datepicker-view';
      this.calendar.appendChild(this.view);
      this.footer = document.createElement('div');
      this.footer.className = 'datepicker-footer';
      this.calendar.appendChild(this.footer);
      this.todayBtn = document.createElement('button');
      this.todayBtn.className = 'datepicker-today-btn';
      this.todayBtn.textContent = this.lang.today;
      this.footer.appendChild(this.todayBtn);
      this.clearBtn = document.createElement('button');
      this.clearBtn.className = 'datepicker-clear-btn';
      this.clearBtn.textContent = this.lang.clear;
      this.footer.appendChild(this.clearBtn);
      
      if (this.inline) {
        this.element.appendChild(this.container);
        this.show();
      } else {
        document.body.appendChild(this.container);
        this.hide();
        this.inputField.addEventListener('focus', () => this.show());
        this.inputField.addEventListener('click', () => this.show());
        document.addEventListener('click', (e) => {
          if (!this.container.contains(e.target) && e.target !== this.inputField) {
            this.hide();
          }
        });
      }
      
      this.prevBtn.addEventListener('click', () => this.prev());
      this.nextBtn.addEventListener('click', () => this.next());
      this.todayBtn.addEventListener('click', () => this.today());
      this.clearBtn.addEventListener('click', () => this.clear());
      this.view.addEventListener('click', (e) => {
        if (e.target.classList.contains('datepicker-day') && !e.target.classList.contains('disabled')) {
          this.select(new Date(parseInt(e.target.dataset.date)));
        }
      });
      
      this.update();
    }
    
    show() {
      this.container.style.display = 'block';
      this.update();
    }
    
    hide() {
      this.container.style.display = 'none';
    }
    
    update() {
      this.updateView();
    }
    
    updateView() {
      const year = this.viewDate.getFullYear();
      const month = this.viewDate.getMonth();
      this.title.textContent = `${this.lang.months[month]} ${year}`;
      
      const firstDay = new Date(year, month, 1).getDay();
      const daysInMonth = new Date(year, month + 1, 0).getDate();
      const daysInPrevMonth = new Date(year, month, 0).getDate();
      const weekStart = this.options.weekStart;
      const leadDays = (firstDay - weekStart + 7) % 7;
      
      let html = '<table class="datepicker-table"><thead><tr>';
      for (let i = 0; i < 7; i++) {
        const dayIndex = (i + weekStart) % 7;
        html += `<th class="datepicker-weekday">${this.lang.daysMin[dayIndex]}</th>`;
      }
      html += '</tr></thead><tbody>';
      
      let day = 1;
      let prevMonthDay = daysInPrevMonth - leadDays + 1;
      let nextMonthDay = 1;
      
      for (let i = 0; i < 6; i++) {
        html += '<tr>';
        for (let j = 0; j < 7; j++) {
          if (i === 0 && j < leadDays) {
            html += `<td class="datepicker-day disabled" data-date="${new Date(year, month - 1, prevMonthDay).getTime()}">${prevMonthDay}</td>`;
            prevMonthDay++;
          } else if (day > daysInMonth) {
            html += `<td class="datepicker-day disabled" data-date="${new Date(year, month + 1, nextMonthDay).getTime()}">${nextMonthDay}</td>`;
            nextMonthDay++;
          } else {
            const date = new Date(year, month, day);
            const isSelected = this.selectedDates.some(d => d.getFullYear() === year && d.getMonth() === month && d.getDate() === day);
            const isToday = date.setHours(0, 0, 0, 0) === new Date().setHours(0, 0, 0, 0);
            const classes = ['datepicker-day'];
            if (isSelected) classes.push('selected');
            if (isToday) classes.push('today');
            html += `<td class="${classes.join(' ')}" data-date="${date.getTime()}">${day}</td>`;
            day++;
          }
        }
        html += '</tr>';
        if (day > daysInMonth) break;
      }
      
      html += '</tbody></table>';
      this.view.innerHTML = html;
    }
    
    prev() {
      this.viewDate = new Date(this.viewDate.getFullYear(), this.viewDate.getMonth() - 1, 1);
      this.update();
    }
    
    next() {
      this.viewDate = new Date(this.viewDate.getFullYear(), this.viewDate.getMonth() + 1, 1);
      this.update();
    }
    
    today() {
      this.viewDate = new Date();
      this.update();
    }
    
    clear() {
      this.selectedDates = [];
      this.inputField.value = '';
      this.update();
    }
    
    select(date) {
      this.selectedDates = [date];
      this.inputField.value = this.formatDate(date);
      this.update();
      if (!this.inline) {
        this.hide();
      }
    }
    
    formatDate(date) {
      const day = date.getDate();
      const month = date.getMonth() + 1;
      const year = date.getFullYear();
      return `${month}/${day}/${year}`;
    }
  }

  // Create a datepicker on all elements with the 'datepicker' class
  document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.datepicker').forEach(function(element) {
      new Datepicker(element);
    });
  });

  exports.Datepicker = Datepicker;
  exports.date = date;
  exports.dom = dom;

  Object.defineProperty(exports, '__esModule', { value: true });

})));