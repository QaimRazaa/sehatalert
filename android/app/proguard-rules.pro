# Flutter Local Notifications - preserve Gson TypeToken generic signatures
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Gson
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

# Flutter Local Notifications plugin internals
-keep class com.dexterous.** { *; }

# Alarm Activity
-keep class com.example.sehatalert.AlarmActivity { *; }

-keep class com.example.sehatalert.AlarmReceiver { *; }

-keep class com.example.sehatalert.AlarmForegroundService { *; }