#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <Adafruit_MLX90640.h>
#include <ArduinoJson.h>

const char* ssid = "ESP32-Thermal1";
const char* password = "1234567890";

// MLX90640 setup
Adafruit_MLX90640 mlx;
#define WIDTH 32
#define HEIGHT 24
float frame[WIDTH * HEIGHT];

// Web server
AsyncWebServer server(80);

void setup() {
  Serial.begin(115200);
  // Initialize MLX90640
  Wire.begin();
  Wire.setClock(400000);
  if (!mlx.begin(0x33, &Wire)) {
    Serial.println("MLX90640 not found!");
    while (1) delay(10);
  }
  mlx.setMode(MLX90640_CHESS);
  mlx.setResolution(MLX90640_ADC_18BIT);
  mlx.setRefreshRate(MLX90640_8_HZ);

  // Start WiFi AP
  WiFi.softAP(ssid, password);
  Serial.print("AP IP address: ");
  Serial.println(WiFi.softAPIP());

  // /status endpoint
  server.on("/status", HTTP_GET, [](AsyncWebServerRequest* request) {
    DynamicJsonDocument doc(128);
    doc["ssid"] = ssid;
    doc["uptime"] = millis();
    String json;
    serializeJson(doc, json);
    request->send(200, "application/json", json);
  });

  // /thermal-data endpoint
  server.on("/thermal-data", HTTP_GET, [](AsyncWebServerRequest* request) {
    if (mlx.getFrame(frame) != 0) {
      request->send(500, "application/json", "{\"error\":\"MLX90640 error\"}");
      return;
    }
    float minTemp = frame[0], maxTemp = frame[0], sum = 0;
    for (int i = 0; i < WIDTH * HEIGHT; i++) {
      if (frame[i] < minTemp) minTemp = frame[i];
      if (frame[i] > maxTemp) maxTemp = frame[i];
      sum += frame[i];
    }
    float avgTemp = sum / (WIDTH * HEIGHT);

    DynamicJsonDocument doc(4096);
    doc["width"] = WIDTH;
    doc["height"] = HEIGHT;
    doc["minTemp"] = minTemp;
    doc["maxTemp"] = maxTemp;
    doc["avgTemp"] = avgTemp;

    JsonArray arr = doc.createNestedArray("data");
    for (int i = 0; i < WIDTH * HEIGHT; i++) arr.add(frame[i]);

    String json;
    serializeJson(doc, json);
    request->send(200, "application/json", json);
  });

  server.begin();
}

void loop() {
  // Nothing needed
}