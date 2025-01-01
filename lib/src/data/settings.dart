Map<String, String> cameraSettings = {};

void clearcameraSettings() {
  cameraSettings.clear();
}

void addCameraSettings(Map settingsMap) {
  for (String key in settingsMap.keys) {
    cameraSettings[key] = settingsMap[key];
  }
}

void addCameraSetting(String key, String value) {
  cameraSettings[key] = value;
}
