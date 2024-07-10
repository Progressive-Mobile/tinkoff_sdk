# Run me if your iOS build doesn't work
rm -rf ~/Library/Developer/Xcode/DerivedData/
rm -rf ~/Library/Caches/CocoaPods/
rm -rf /ios/Pods/
flutter clean
flutter pub get
# dart run build_runner build
cd ios
rm Podfile.lock
pod deintegrate
pod cache clean --all
pod install --repo-update