# Preserve the javax.annotation.Nullable class and related annotations
#-keep class javax.annotation.Nullable { *; }

# Suppress warnings related to missing javax.annotation classes
-dontwarn javax.annotation.**

# Tink-specific keep rules (adjust based on your usage)
#-keep class com.google.crypto.tink.** { *; }
-keepattributes *Annotation*
