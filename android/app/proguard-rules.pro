# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core / Split deferred components
-dontwarn com.google.android.play.core.**

# Google Mobile Ads (AdMob)
-keep class com.google.android.gms.ads.** { *; }
-keep interface com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }
-keep public class com.google.android.gms.ads.initialization.OnInitializationCompleteListener { *; }
-keep public class com.google.android.gms.ads.AdRequest { *; }
-keep public class com.google.android.gms.ads.AdSize { *; }
-keep public class com.google.android.gms.ads.AdView { *; }
-dontwarn com.google.android.gms.**

# WebView
-keepattributes JavascriptInterface
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keep class android.webkit.** { *; }

# General keep attributes
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
