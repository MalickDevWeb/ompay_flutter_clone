import 'package:logger/logger.dart';

/// Centralized logging service for production debugging
class LoggingService {
  static final Logger _logger = Logger(
    filter: _AppLogFilter(),
    printer: _AppLogPrinter(),
    output: _AppLogOutput(),
  );

  /// Log debug information
  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info information
  static void info(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning information
  static void warning(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error information
  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log API requests
  static void logApiRequest(String method, String url, {Map<String, dynamic>? headers, dynamic body}) {
    debug('API Request: $method $url', error: {
      'headers': headers,
      'body': body,
    });
  }

  /// Log API responses
  static void logApiResponse(String method, String url, int statusCode, {dynamic response, dynamic error}) {
    if (statusCode >= 200 && statusCode < 300) {
      debug('API Response: $method $url - Status: $statusCode');
    } else {
      warning('API Response: $method $url - Status: $statusCode', error: {
        'response': response,
        'error': error,
      });
    }
  }

  /// Log user actions
  static void logUserAction(String action, {Map<String, dynamic>? parameters}) {
    info('User Action: $action', error: parameters);
  }

  /// Log authentication events
  static void logAuthEvent(String event, {String? userId, String? userType}) {
    info('Auth Event: $event', error: {
      'userId': userId,
      'userType': userType,
    });
  }

  /// Log navigation events
  static void logNavigation(String from, String to) {
    debug('Navigation: $from -> $to');
  }

  /// Log performance metrics
  static void logPerformance(String operation, Duration duration, {Map<String, dynamic>? metadata}) {
    info('Performance: $operation took ${duration.inMilliseconds}ms', error: metadata);
  }

  /// Log cache operations
  static void logCacheOperation(String operation, String key, {bool hit = false, Duration? duration}) {
    debug('Cache $operation: $key (hit: $hit)', error: {
      'duration': duration?.inMilliseconds,
    });
  }

  /// Log errors with context
  static void logErrorWithContext(String context, dynamic error, {StackTrace? stackTrace, Map<String, dynamic>? additionalData}) {
    error('Error in $context', error: {
      'error': error.toString(),
      'additionalData': additionalData,
    }, stackTrace: stackTrace);
  }
}

/// Custom log filter for production
class _AppLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // In production, only log warnings and errors
    // In development, log everything
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    if (isProduction) {
      return event.level.index >= Level.warning.index;
    }
    return true;
  }
}

/// Custom log printer with structured output
class _AppLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final color = _getColor(event.level);
    final emoji = _getEmoji(event.level);
    final timestamp = DateTime.now().toIso8601String();

    final buffer = StringBuffer()
      ..write('$color$emoji [$timestamp] ${event.level.name.toUpperCase()}: ${event.message}\x1B[0m');

    if (event.error != null) {
      buffer.write('\n${color}Error: ${event.error}\x1B[0m');
    }

    if (event.stackTrace != null) {
      buffer.write('\n${color}StackTrace: ${event.stackTrace}\x1B[0m');
    }

    return [buffer.toString()];
  }

  String _getColor(Level level) {
    const ansiColor = {
      Level.debug: '\x1B[36m',    // Cyan
      Level.info: '\x1B[32m',     // Green
      Level.warning: '\x1B[33m',  // Yellow
      Level.error: '\x1B[31m',    // Red
      Level.wtf: '\x1B[35m',      // Magenta
    };

    const resetColor = '\x1B[0m';
    return '${ansiColor[level] ?? ''}$resetColor';
  }

  String _getEmoji(Level level) {
    switch (level) {
      case Level.debug:
        return '🐛';
      case Level.info:
        return 'ℹ️';
      case Level.warning:
        return '⚠️';
      case Level.error:
        return '❌';
      case Level.wtf:
        return '💥';
      default:
        return '📝';
    }
  }
}

/// Custom log output for different platforms
class _AppLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      // In production, you might want to send logs to a service like Sentry, Firebase Crashlytics, etc.
      // For now, just print to console
      print(line);

      // TODO: Implement production logging
      // - Send to logging service (Sentry, LogRocket, etc.)
      // - Store locally for debugging
      // - Send to analytics platform
    }
  }
}
