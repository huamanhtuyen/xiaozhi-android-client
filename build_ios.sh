rm -rf ~/Library/Developer/Xcode/DerivedDatarm -rf ~/Library/Developer/Xcode/DerivedData#!/bin/bash
set -e

echo "🔹 Step 1: Flutter clean..."
flutter clean

echo "🔹 Step 2: Get dependencies..."
flutter pub get

echo "🔹 Step 3: Clean iOS Pods..."
cd ios
pod deintegrate
pod install
cd ..

echo "🔹 Step 4: Remove Xcode DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData

echo "🔹 Step 5: Build iOS release..."
flutter build ios --release

echo "✅ Build completed successfully!"
