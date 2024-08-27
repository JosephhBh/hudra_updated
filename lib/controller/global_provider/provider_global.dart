import 'package:flutter/material.dart';

class ProviderGlobal extends ChangeNotifier {
  String _previousPage =
      'DailyPage'; //DailyPage//CalendarPage//HolidayPrayerPage//RitualsPage//PrayersPage//BiblePage//SettingsPage//DiscoverPage//NotificationsPage//SavedVersesPage//InfoPage
  String _currentPage =
      'DailyPage'; //DailyPage//CalendarPage//HolidayPrayerPage//RitualsPage//PrayersPage//BiblePage//SettingsPage//DiscoverPage//NotificationsPage//SavedVersesPage//InfoPage
  int _isCalendar = 0;
  String _holidayName = '';

  String get previousPage => _previousPage;

  String get currentPage => _currentPage;

  int get isCalendar => _isCalendar;

  String get holidayName => _holidayName;

  goTo(String newPage) {
    // _previousPage = _currentPage;
    _currentPage = newPage;
    notifyListeners();
  }

  goToFromHome(String newPage) {
    // _previousPage = 'DailyPage';
    _currentPage = newPage;
    notifyListeners();
  }

  gotoCalendarHoliday(String holidayName) {
    _currentPage = 'CalendarPage';
    _isCalendar = 1;
    _holidayName = holidayName;
    notifyListeners();
  }

  _goBackHome() {
    // _previousPage = 'DailyPage';
    _currentPage = 'DailyPage';
    notifyListeners();
  }

  _goBackPrevious() {
    // String tmp = _currentPage;
    // _currentPage = _previousPage;
    // _previousPage = tmp;
    _currentPage = 'DailyPage';
    notifyListeners();
  }

  _goBackCalendar() {
    if (_isCalendar == 0) {
      // _previousPage = 'DailyPage';
      // _currentPage = _previousPage;
      _currentPage = 'DailyPage';
    } else {
      _currentPage = 'CalendarPage';
      _holidayName = '';
      _isCalendar = 0;
    }
    notifyListeners();
  }

  bool goBackAll() {
    if (_currentPage == 'RitualsPage' ||
        _currentPage == 'PrayersPage' ||
        _currentPage == 'BiblePage' ||
        _currentPage == 'SettingsPage') {
      _goBackHome();
      return true;
    }
    if (_currentPage == 'DiscoverPage' ||
        _currentPage == 'NotificationsPage' ||
        _currentPage == 'SavedVersesPage' ||
        _currentPage == 'InfoPage' ||
        _currentPage == 'ErrorPage') {
      _goBackPrevious();
      return true;
    }
    if (_currentPage == 'CalendarPage') {
      _goBackCalendar();
      return true;
    }
    return true;
  }
}
