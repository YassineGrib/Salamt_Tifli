import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../models/vaccination.dart';
import '../models/child_profile.dart';
import '../constants/app_constants.dart';

class NotificationService {
  static NotificationService? _instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._();

  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  /// Initialize notification service
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for iOS
    await _requestPermissions();
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    final bool? result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    final bool? androidResult = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    return result ?? androidResult ?? false;
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (payload != null) {
      // Handle navigation based on payload
      _handleNotificationPayload(payload);
    }
  }

  /// Handle notification payload for navigation
  void _handleNotificationPayload(String payload) {
    // Parse payload and navigate to appropriate screen
    // Format: "type:id" e.g., "vaccination:child_id_vaccine_name"
    final parts = payload.split(':');
    if (parts.length >= 2) {
      final type = parts[0];
      final id = parts[1];

      switch (type) {
        case 'vaccination':
          // Navigate to vaccination screen
          break;
        case 'checkup':
          // Navigate to checkup screen
          break;
        case 'medication':
          // Navigate to medication screen
          break;
      }
    }
  }

  /// Schedule vaccination reminder
  Future<void> scheduleVaccinationReminder(
    VaccinationReminder reminder,
    ChildProfile child,
  ) async {
    final int notificationId = reminder.id.hashCode;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'vaccination_reminders',
      'تذكيرات التطعيمات',
      channelDescription: 'تذكيرات مواعيد التطعيمات للأطفال',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF4CAF50),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final String title = 'تذكير تطعيم ${child.name}';
    final String body = 'موعد تطعيم ${reminder.vaccineNameArabic} خلال ${_getDaysUntilDue(reminder)} أيام';

    await _flutterLocalNotificationsPlugin.schedule(
      notificationId,
      title,
      body,
      reminder.reminderDate,
      platformChannelSpecifics,
      payload: 'vaccination:${reminder.id}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedule multiple vaccination reminders
  Future<void> scheduleVaccinationReminders(
    List<VaccinationReminder> reminders,
    ChildProfile child,
  ) async {
    for (final reminder in reminders) {
      await scheduleVaccinationReminder(reminder, child);
    }
  }

  /// Schedule daily medication reminder
  Future<void> scheduleMedicationReminder(
    Medication medication,
    ChildProfile child,
    TimeOfDay reminderTime,
  ) async {
    final int notificationId = '${child.id}_${medication.id}'.hashCode;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_reminders',
      'تذكيرات الأدوية',
      channelDescription: 'تذكيرات مواعيد الأدوية للأطفال',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2196F3),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final String title = 'تذكير دواء ${child.name}';
    final String body = 'وقت إعطاء دواء ${medication.name} - الجرعة: ${medication.dosage}';

    // Schedule daily at the specified time
    await _flutterLocalNotificationsPlugin.periodicallyShow(
      notificationId,
      title,
      body,
      RepeatInterval.daily,
      platformChannelSpecifics,
      payload: 'medication:${child.id}_${medication.id}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedule checkup reminder
  Future<void> scheduleCheckupReminder(
    ChildProfile child,
    DateTime checkupDate,
    String checkupType,
  ) async {
    final int notificationId = '${child.id}_checkup_${checkupDate.millisecondsSinceEpoch}'.hashCode;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'checkup_reminders',
      'تذكيرات الفحوصات',
      channelDescription: 'تذكيرات مواعيد الفحوصات الطبية',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF87CEEB),
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final String title = 'تذكير فحص ${child.name}';
    final String body = 'موعد $checkupType غداً';

    // Schedule reminder one day before
    final reminderDate = checkupDate.subtract(const Duration(days: 1));

    await _flutterLocalNotificationsPlugin.schedule(
      notificationId,
      title,
      body,
      reminderDate,
      platformChannelSpecifics,
      payload: 'checkup:${child.id}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Schedule seasonal health tip
  Future<void> scheduleSeasonalHealthTip(
    SeasonalHealthTip tip,
    DateTime scheduleDate,
  ) async {
    final int notificationId = tip.id.hashCode;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'health_tips',
      'نصائح صحية',
      channelDescription: 'نصائح صحية موسمية للأطفال',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF4CAF50),
      playSound: false,
      enableVibration: false,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: null,
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.schedule(
      notificationId,
      tip.title,
      tip.content,
      scheduleDate,
      platformChannelSpecifics,
      payload: 'health_tip:${tip.id}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int notificationId) async {
    await _flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  /// Cancel all notifications for a child
  Future<void> cancelChildNotifications(String childId) async {
    final pendingNotifications = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    
    for (final notification in pendingNotifications) {
      if (notification.payload?.contains(childId) == true) {
        await _flutterLocalNotificationsPlugin.cancel(notification.id);
      }
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Show immediate notification
  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'immediate_notifications',
      'إشعارات فورية',
      channelDescription: 'إشعارات فورية مهمة',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      sound: 'default',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Helper method to get days until due
  int _getDaysUntilDue(VaccinationReminder reminder) {
    return reminder.dueDate.difference(DateTime.now()).inDays;
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final bool? result = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    return result ?? false;
  }
}
