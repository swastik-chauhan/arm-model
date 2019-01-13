import netP5.*;
import oscP5.*;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorManager;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

Context context;
SensorManager manager;
Sensor sensor;
AccelerometerListener listener;
String ip = "192.168.0.27";
float ax, ay, az, val;

float x, w, h, y1, y2;
int show = 1;

String dev;

void setup() {
  fullScreen();
  
  x = width/5;
  w = 3*width/5;
  h = height/10;
  y1 = height/5;
  y2 = 2*height/5;
  
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress(ip,12000);
  
  context = getActivity();
  manager = (SensorManager)context.getSystemService(Context.SENSOR_SERVICE);
  sensor = manager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  listener = new AccelerometerListener();
  manager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_GAME);
  
  textFont(createFont("SansSerif", 30 * displayDensity));
  background(0);
  noFill();
 
  fill(255);
  stroke(255);
}

void draw() {
  if (show == 1){
     textSize(30 * displayDensity);
     noFill();
     rect(x,y1,w,h,2);
     fill(255);
     text("Upper arm", x+width/20, y1+height/20);
     noFill();
     rect(x,y2,w,h,2);
     fill(255);
     text("Lower arm", x+width/20, y2+height/20);
     if(mousePressed){
       if(mouseX>x && mouseX <x+w && mouseY>y1 && mouseY <y1+h){
         dev = "upper";
         show = 0;
        } else if(mouseX>x && mouseX <x+w && mouseY>y2 && mouseY <y2+h){
          dev = "lower";
          show = 0;
        }
     } 
   }
 else {
   background(0);
   if(dev == "lower"){
     OscMessage myMessage = new OscMessage("Value");
     myMessage.add("lower");
     myMessage.add(val);
     oscP5.send(myMessage, myRemoteLocation);
     textFont(createFont("SansSerif", 30 * displayDensity));
     text("Acting as: 'LOWER ARM'", 40, 100);
   } else if(dev == "upper"){
     OscMessage myMessage = new OscMessage("Value");
     myMessage.add("upper");
     float newVal = 360 - val;
     myMessage.add(newVal);
     oscP5.send(myMessage, myRemoteLocation);
     textFont(createFont("SansSerif", 30 * displayDensity));
     text("Acting as: 'UPPER ARM'", 40, 100);
   }
 }
}

class AccelerometerListener implements SensorEventListener {
  public void onSensorChanged(SensorEvent event) {
    ay = event.values[1];
    az = event.values[2];    
    if(az>0){
      val = 90 - ay*9;
    } else {
      val = 270 + ay*9;
    }
  }
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
  }
}
