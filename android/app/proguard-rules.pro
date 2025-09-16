
# Flutter and specific plugins rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.**  { *; }

# Rules for awesome_notifications
-keep class me.carda.awesome_notifications.** { *; }

# Rules for android_alarm_manager_plus
-keep class dev.fluttercommunity.plus.androidalarmmanager.** { *; }

# Rules for Google Play Core library
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Keep Flutter SplitCompat Application
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }

# Broader rules for common Flutter plugins and AndroidX libraries
-keep class androidx.core.app.CoreComponentFactory { *; }
-keep public class * extends io.flutter.app.FlutterApplication {
    <init>();
}
-keep public class * extends io.flutter.plugin.common.PluginRegistry {
    <init>();
}
-keep public class * extends java.lang.Object {
    public static java.lang.String get$resName();
}
-dontwarn com.google.android.play.core.splitinstall.**
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.splitinstall.testing.** { *; }

# More comprehensive Play Core rules
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.splitinstall.model.SplitInstallErrorCode
-dontwarn com.google.android.play.core.splitinstall.model.SplitInstallSessionStatus
