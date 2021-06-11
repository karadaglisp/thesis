// Code for wifi-scanning callibration

#include <WiFi.h>
#include <HTTPClient.h>

#define buttonPin 0 
#define LEDPin 5

// Network information
const char* ssid = "hotspot";
const char* password = "kaleidoscope";

// Global variables
int measurementNumber = 0;
long averageRSSI = 0;
const int sendInterval = 500;

//Google Script ID
//String GOOGLE_SCRIPT_ID = "AKfycbw69bQZH4QyZrvw9gcMBOsHb9V2rb_hmeHFKzAYvziJdu1k1eI";


void setup(){
  
    Serial.begin(115200);
    pinMode(buttonPin,INPUT);
    pinMode(LEDPin, OUTPUT);
    connectWiFi();
    
}

void loop(){
   if (digitalRead(buttonPin) == LOW){
const int numberPoints = 7;
float wifiStrength;
  if (digitalRead(buttonPin) == LOW){
  
  // In each loop, make sure there is an Internet connection.
    if (WiFi.status() != WL_CONNECTED) { 
        connectWiFi();
    }
    wifiStrength = getStrength(numberPoints); 
    measurementNumber++;
Serial.println(averageRSSI);
//    sendData("&info1="+String(averageRSSI));

};
};}

void connectWiFi(){
    while (WiFi.status() != WL_CONNECTED){
        WiFi.begin(ssid, password);
        delay(1000);
    }

    // Display a notification that the connection is successful. 
    Serial.println("Connected");
}

// Take measurements of the Wi-Fi strength and return the average result.
int getStrength(int points){
    long rssi = 0;
    
    for (int i=0;i < points;i++){
        rssi += WiFi.RSSI();
        delay(20);
    }

   averageRSSI = rssi/points;
   
   return averageRSSI;
}

//Send data to google sheets function
//void sendData(String params) {
  // HTTPClient http;
   //String url="https://script.google.com/macros/s/"+GOOGLE_SCRIPT_ID+"/exec?"+params;
   //Serial.print(url);
   //Serial.print("Making a request");\
   http.begin(url, root_ca); //Specify the URL and certificate
   //int httpCode = http.GET();  
   //http.end();
   //Serial.println(": done "+httpCode);
//}
