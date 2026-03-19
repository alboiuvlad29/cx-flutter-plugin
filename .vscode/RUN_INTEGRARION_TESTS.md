# Running Integration Tests Manually

## iOS

### Boot the simulator
```bash
open -a Simulator && xcrun simctl boot "iPhone 16 Pro"
```

### Run integration tests
```bash
cd /Users/tomer.haryoffi/Development/cx-flutter-plugin/example && flutter test integration_test/app_e2e_test.dart -d "iPhone 16 Pro"
```

### One-liner (boot + run)
```bash
open -a Simulator && sleep 3 && cd /Users/tomer.haryoffi/Development/cx-flutter-plugin/example && flutter test integration_test/app_e2e_test.dart -d "iPhone 16 Pro"
```

---

## Android

### Boot the emulator
```bash
emulator -avd Medium_Phone_API_35 &
```

### Wait for boot to complete
```bash
adb wait-for-device && adb shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done'
```

### Run integration tests
```bash
cd /Users/tomer.haryoffi/Development/cx-flutter-plugin/example && flutter test integration_test/app_e2e_test.dart -d emulator-5554
```

### One-liner (boot + run)
```bash
emulator -avd Medium_Phone_API_35 & sleep 20 && cd /Users/tomer.haryoffi/Development/cx-flutter-plugin/example && flutter test integration_test/app_e2e_test.dart -d emulator-5554
```

---

## Useful Commands

### List available iOS simulators
```bash
xcrun simctl list devices available | grep -i iphone
```

### List available Android emulators
```bash
emulator -list-avds
```

### Check connected devices
```bash
flutter devices
```

### Check Android emulator status
```bash
adb devices
```
