#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define data_pin 13
#define led_status_pin 12
#define animation_wait 50

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define bleServerName "ESP32 Test"

Adafruit_NeoPixel strip = Adafruit_NeoPixel(59, data_pin, NEO_GRB + NEO_KHZ800);

BLEServer* pServer = NULL;
BLEService* pService = NULL;
BLECharacteristic* pCharacteristic = NULL;
BLEAdvertising* pAdvertising = NULL;

bool deviceConnected = false;
bool isAnimationRunning = true;
uint8_t led_status = 0;
uint8_t led_animation = 16;
uint8_t led_animation_old = 0;
uint8_t led_brightness = 64;
uint8_t led_red = 64;
uint8_t led_green = 64;
uint8_t led_blue = 64;


void changeLedStatus() {
  if (led_status == 0) {
    digitalWrite(led_status_pin, LOW);
    digitalWrite(LED_BUILTIN, LOW);
  } else if (led_status == 1) {
    digitalWrite(led_status_pin, HIGH);
    digitalWrite(LED_BUILTIN, HIGH);
  }
}

void changeLedAnimation() {
  if (led_animation == 16) {
    singleColor(strip.Color(led_red, led_green, led_blue));  // Combine led-green-blue
  } else if (led_animation == 17) {
    rainbow();  // static colors
  } else if (led_animation == 18) {
    rainbowCycle();  // static colors
  } else if (led_animation == 19) {
    colorWipe(strip.Color(led_red, 0, 0));    // Red
    colorWipe(strip.Color(0, led_green, 0));  // Green
    colorWipe(strip.Color(0, 0, led_blue));   // Blue
  } else if (led_animation == 20) {
    theaterChase(strip.Color(led_red, led_green, led_blue));  // Combine led-green-blue
  } else if (led_animation == 21) {
    theaterChaseRainbow();  // static colors
  } else {
    rainbowCycle();  // static colors
  }
}

void changeLedBrightness() {
  strip.setBrightness(led_brightness);
}

class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("connected!");
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("disconnected!");
    BLEDevice::startAdvertising();
  }
};

class CharacteristicCallback : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) {
    Serial.println("START RECEIVE");
    uint8_t* received_data = pCharacteristic->getData();
    //led status
    if (received_data[0] == 2) {
      led_status = received_data[1];
    }
    //animation
    else if (received_data[0] == 9) {
      isAnimationRunning = true;
      led_animation = received_data[1];
      if (led_animation != led_animation) {
        led_animation_old = led_animation;
        isAnimationRunning = false;
        delay(20);
        isAnimationRunning = true;
      }
    }
    //single color
    else if (received_data[0] == 16) {
      led_red = received_data[1];
      led_green = received_data[2];
      led_blue = received_data[3];
    }
    //brightness
    else if (received_data[0] == 32) {
      led_brightness = received_data[1];
    }
    //send info
    else if (received_data[0] == 48) {
      if (received_data[1] == 1) {
        sendInfo();
      }
      Serial.println("END RECEIVE");
    }

    changeLedStatus();
    changeLedBrightness();
  }
};

void setupBle() {
  Serial.println("Starting BLE!");

  BLEDevice::init(bleServerName);

  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  pService = pServer->createService(SERVICE_UUID);

  pCharacteristic = pService->createCharacteristic(
    CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_NOTIFY
      | BLECharacteristic::PROPERTY_READ
      | BLECharacteristic::PROPERTY_WRITE);

  //pCharacteristic->setValue("Hello World!");
  pCharacteristic->addDescriptor(new BLE2902());
  pCharacteristic->setCallbacks(new CharacteristicCallback());

  pService->start();

  pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);

  BLEDevice::startAdvertising();

  Serial.println("Waiting a client connection...");
}

void sendInfo() {
  uint8_t ledInfoArr[] = { led_status, led_animation, led_brightness, led_red, led_green, led_blue };
  uint8_t* ledInfo = ledInfoArr;
  pCharacteristic->setValue(ledInfo, 6);
  for (int i = 0; i < 7; i++) {
    Serial.println("Send info values: " + String(ledInfoArr[i]));
  }
}

void setup() {
#if defined(__AVR_ATtiny85__)
  if (F_CPU == 16000000) clock_prescale_set(clock_div_1);
#endif
  pinMode(led_status_pin, OUTPUT);
  strip.begin();
  changeLedBrightness();
  strip.show();
  Serial.begin(115200);
  setupBle();
}

void loop() {
  if (isAnimationRunning) {
    changeLedAnimation();
  }

  if (deviceConnected) {
    sendInfo();
    delay(10);
  }
}

// Fill the dots one after the other with a color
void singleColor(uint32_t c) {
  for (uint16_t i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(10);
  }
}

// Fill the dots one after the other with a color
void colorWipe(uint32_t c) {
  for (uint16_t i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, c);
    strip.show();
    delay(animation_wait);
  }
}

void rainbow() {
  uint16_t i, j;

  for (j = 0; j < 256; j++) {
    for (i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel((i + j) & 255));
    }
    strip.show();
    delay(animation_wait);
  }
}

// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycle() {
  uint16_t i, j;

  for (j = 0; j < 256 * 5; j++) {  // 5 cycles of all colors on wheel
    for (i = 0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, Wheel(((i * 256 / strip.numPixels()) + j) & 255));
    }
    strip.show();
    delay(animation_wait);
  }
}

//Theatre-style crawling lights.
void theaterChase(uint32_t c) {
  for (int j = 0; j < 10; j++) {  //do 10 cycles of chasing
    for (int q = 0; q < 3; q++) {
      for (uint16_t i = 0; i < strip.numPixels(); i = i + 3) {
        strip.setPixelColor(i + q, c);  //turn every third pixel on
      }
      strip.show();

      delay(animation_wait);

      for (uint16_t i = 0; i < strip.numPixels(); i = i + 3) {
        strip.setPixelColor(i + q, 0);  //turn every third pixel off
      }
    }
  }
}

//Theatre-style crawling lights with rainbow effect
void theaterChaseRainbow() {
  for (int j = 0; j < 256; j++) {  // cycle all 256 colors in the wheel
    for (int q = 0; q < 3; q++) {
      for (uint16_t i = 0; i < strip.numPixels(); i = i + 3) {
        strip.setPixelColor(i + q, Wheel((i + j) % 255));  //turn every third pixel on
      }
      strip.show();

      delay(animation_wait);

      for (uint16_t i = 0; i < strip.numPixels(); i = i + 3) {
        strip.setPixelColor(i + q, 0);  //turn every third pixel off
      }
    }
  }
}

// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if (WheelPos < 85) {
    return strip.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  }
  if (WheelPos < 170) {
    WheelPos -= 85;
    return strip.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
  WheelPos -= 170;
  return strip.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
}