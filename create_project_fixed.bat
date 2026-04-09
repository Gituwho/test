@echo off

cd /d %~dp0

mkdir StreamioClone
cd StreamioClone

mkdir app
mkdir app\src\main\java\com\streamio\app
mkdir app\src\main\res\layout

:: settings.gradle
echo rootProject.name = "StreamioClone" > settings.gradle
echo include ':app' >> settings.gradle

:: project build.gradle
(
echo buildscript {
echo     repositories { google(); mavenCentral() }
echo     dependencies { classpath "com.android.tools.build:gradle:8.2.2" }
echo }
echo allprojects {
echo     repositories { google(); mavenCentral() }
echo }
) > build.gradle

:: app build.gradle
(
echo plugins {
echo     id 'com.android.application'
echo     id 'org.jetbrains.kotlin.android'
echo }
echo android {
echo     namespace 'com.streamio.app'
echo     compileSdk 34
echo     defaultConfig {
echo         applicationId "com.streamio.app"
echo         minSdk 21
echo         targetSdk 34
echo         versionCode 1
echo         versionName "1.0"
echo     }
echo     buildFeatures { viewBinding true }
echo }
echo dependencies {
echo     implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.22"
echo     implementation "androidx.core:core-ktx:1.12.0"
echo     implementation "androidx.appcompat:appcompat:1.6.1"
echo     implementation "com.google.android.exoplayer:exoplayer:2.19.1"
echo }
) > app\build.gradle

:: AndroidManifest.xml
(
echo ^<manifest xmlns:android="http://schemas.android.com/apk/res/android"^>
echo ^<application android:label="StreamioClone" android:theme="@style/Theme.AppCompat.Light.NoActionBar"^>
echo ^<activity android:name=".PlayerActivity"/^>
echo ^<activity android:name=".MainActivity"^>
echo ^<intent-filter^>
echo ^<action android:name="android.intent.action.MAIN"/^>
echo ^<category android:name="android.intent.category.LAUNCHER"/^>
echo ^</intent-filter^>
echo ^</activity^>
echo ^</application^>
echo ^</manifest^>
) > app\src\main\AndroidManifest.xml

:: MainActivity.kt
(
echo package com.streamio.app
echo
echo import android.content.Intent
echo import android.os.Bundle
echo import androidx.appcompat.app.AppCompatActivity
echo
echo class MainActivity : AppCompatActivity() {
echo     override fun onCreate(savedInstanceState: Bundle?) {
echo         super.onCreate(savedInstanceState)
echo         startActivity(
echo             Intent(this, PlayerActivity::class.java)
echo             .putExtra("url","https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8")
echo         )
echo     }
echo }
) > app\src\main\java\com\streamio\app\MainActivity.kt

:: PlayerActivity.kt
(
echo package com.streamio.app
echo
echo import android.net.Uri
echo import android.os.Bundle
echo import androidx.appcompat.app.AppCompatActivity
echo import com.google.android.exoplayer2.ExoPlayer
echo import com.google.android.exoplayer2.MediaItem
echo import com.google.android.exoplayer2.ui.PlayerView
echo
echo class PlayerActivity : AppCompatActivity() {
echo     private lateinit var player: ExoPlayer
echo
echo     override fun onCreate(savedInstanceState: Bundle?) {
echo         super.onCreate(savedInstanceState)
echo
echo         val view = PlayerView(this)
echo         setContentView(view)
echo
echo         player = ExoPlayer.Builder(this).build()
echo         view.player = player
echo
echo         val mediaItem = MediaItem.fromUri(
echo             Uri.parse(intent.getStringExtra("url")!!)
echo         )
echo
echo         player.setMediaItem(mediaItem)
echo         player.prepare()
echo         player.play()
echo     }
echo
echo     override fun onDestroy() {
echo         super.onDestroy()
echo         player.release()
echo     }
echo }
) > app\src\main\java\com\streamio\app\PlayerActivity.kt

echo.
echo ✅ Project created successfully!
pause