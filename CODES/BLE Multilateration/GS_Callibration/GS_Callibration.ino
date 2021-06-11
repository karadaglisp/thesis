//This is the code for Callibration.

//Libraries
//#include <WiFi.h>
#include <HTTPClient.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEScan.h>
#include <BLEAdvertisedDevice.h>

#define buttonPin 0 
#define LEDPin 5

//Needed Variables to store data
float RSSI_VAL;
String knownBLEAddresses = "c0:00:d9:1b:01:52";
//float RSSI_AVG;
int i;
bool device_found;

//Delay
const int sendInterval = 500;

//BLE Scan Function-Class
int scanTime = 5; //In seconds
BLEScan* pBLEScan;
class MyAdvertisedDeviceCallbacks: public BLEAdvertisedDeviceCallbacks {
    void onResult(BLEAdvertisedDevice advertisedDevice) {
        if (strcmp(advertisedDevice.getAddress().toString().c_str(), knownBLEAddresses.c_str()) == 0)
                        {
          device_found = true;
         Serial.printf("Advertised Device: %s \n", advertisedDevice.toString().c_str());
                                 }
        else
          device_found = false;
      }
    };
    



void setup() {
  
  Serial.begin(115200); //Initialize Serial Monitor
  delay(10);
  Serial.println("Started");
  Serial.println("Ready to go");
  
  //Perform Scan
  Serial.println("Scanning...");
  BLEDevice::init("");
  pBLEScan = BLEDevice::getScan(); //create new scan
  pBLEScan->setAdvertisedDeviceCallbacks(new MyAdvertisedDeviceCallbacks());
  pBLEScan->setActiveScan(true); //active scan uses more power, but get results faster
  pBLEScan->setInterval(100);
  pBLEScan->setWindow(99);  // less or equal setInterval value
}

void loop() {
  // If a button press is detected, write the data to ThingSpeak.
  if (digitalRead(buttonPin) == LOW){
    //Print Scan Results
    
    BLEScanResults foundDevices = pBLEScan->start(scanTime, false);
    Serial.print("Devices found: ");
    Serial.println(foundDevices.getCount());
    Serial.println("Scan done!");

    pBLEScan->clearResults();
    RSSI_VAL = 0; }
   
  
    delay(sendInterval);
  };
