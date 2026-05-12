import 'dart:async';

import 'package:agen_nusantara/shared/services/database_service.dart';
import 'package:agen_nusantara/shared/services/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartData {
  final String day;
  final int completedCount;

  ChartData({required this.day, required this.completedCount});
}

class HomeController extends GetxController with WidgetsBindingObserver {
  static HomeController get to => Get.find();

  late UserSessionService _userSessionService;
  late DatabaseService _databaseService;
  Timer? _refreshTimer;

  var username = ''.obs;
  var currentDate = ''.obs;
  var chartData = <ChartData>[].obs;
  var completedTaskCount = 0.obs;
  var pendingTaskCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _userSessionService = UserSessionService.instance;
    _databaseService = DatabaseService();
    _loadUsername();
    _loadCurrentDate();
    _loadChartData();
    _loadTaskCounts();

    // Start periodic refresh every 2 seconds
    _startAutoRefresh();

    // Listen to app lifecycle
    WidgetsBinding.instance.addObserver(this);
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _loadChartData();
      _loadTaskCounts();
      _loadCurrentDate();
    });
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Resume refresh when app is brought back to foreground
      _startAutoRefresh();
    } else if (state == AppLifecycleState.paused) {
      // Pause refresh when app is hidden
      _stopAutoRefresh();
    }
  }

  @override
  void onClose() {
    _stopAutoRefresh();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  void _loadUsername() {
    username.value = _userSessionService.username ?? 'Guest';
  }

  void _loadCurrentDate() {
    final now = DateTime.now();
    currentDate.value = _formatDate(now);
  }

  Future<void> _loadChartData() async {
    try {
      String? currentUsername = _userSessionService.username;
      if (currentUsername == null) return;

      final allTasks = await _databaseService.getTasksByUsername(
        currentUsername,
      );

      // Initialize last 7 days with date-based key
      final now = DateTime.now();
      final lastSevenDaysMap = <String, int>{};
      final dayNamesList = <String>[];

      // Create entries for last 7 days in order
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dayName = _getDayName(date.weekday);
        final dateKey = '${date.year}-${date.month}-${date.day}';
        lastSevenDaysMap[dateKey] = 0;
        dayNamesList.add(dayName);
      }

      // Count completed tasks for each day (by date, not by weekday)
      for (var task in allTasks) {
        if (task['status'] == 'completed') {
          final taskDate = DateTime.parse(task['createdAt'] as String);
          final dateKey = '${taskDate.year}-${taskDate.month}-${taskDate.day}';

          // Only count if within last 7 days
          if (lastSevenDaysMap.containsKey(dateKey)) {
            lastSevenDaysMap[dateKey] = lastSevenDaysMap[dateKey]! + 1;
          }
        }
      }

      // Convert to ChartData list maintaining order
      final data = lastSevenDaysMap.entries
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => ChartData(
              day: dayNamesList[entry.key],
              completedCount: entry.value.value,
            ),
          )
          .toList();

      chartData.value = data;
    } catch (e) {
      print('Error loading chart data: $e');
    }
  }

  Future<void> _loadTaskCounts() async {
    try {
      String? currentUsername = _userSessionService.username;
      if (currentUsername == null) return;

      final allTasks = await _databaseService.getTasksByUsername(
        currentUsername,
      );
      int completed = 0;
      int pending = 0;

      for (var task in allTasks) {
        if (task['status'] == 'completed') {
          completed++;
        } else {
          pending++;
        }
      }

      completedTaskCount.value = completed;
      pendingTaskCount.value = pending;
    } catch (e) {
      print('Error loading task counts: $e');
    }
  }

  String _getDayName(int weekday) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[weekday - 1];
  }

  String _formatDate(DateTime date) {
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];

    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  String getUsername() {
    return _userSessionService.username ?? 'Guest';
  }
}
