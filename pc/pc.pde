import oscP5.*;
import netP5.*;

Time lastTimeUpper = new Time();
Time lastTimeLower = new Time();
  
OscP5 oscP5;
float angleUpper, angleLower, angleBetween;
float segLength = 0;

void setup() {
  fullScreen();
  frameRate(25);
  segLength = min(width/4, height/4) - 40;
  strokeWeight(30);
  
  oscP5 = new OscP5(this,12000);
}

void draw() {
  if((lastTimeUpper.getCurrentTime() - lastTimeUpper.getInitTime() < 3) && (lastTimeLower.getCurrentTime() - lastTimeLower.getInitTime() < 3)){
    pushMatrix();
    float x = width/2;
    float y = height/2; 
    float colUp = angleUpper * 255/360;
    float colLow = (angleLower + 180) * 255/360;
    float colBack = angleBetween * 255/360;
    background(130, 130, colBack);
    stroke(colUp, 124, 0);
    segment(x, y, radians(angleUpper+90));
    stroke(colLow, 124, 0);
    segment(segLength, 0, radians(angleBetween+180));
    popMatrix();
  }else if((lastTimeUpper.getCurrentTime() - lastTimeUpper.getInitTime() > 3) && (lastTimeLower.getCurrentTime() - lastTimeLower.getInitTime() > 3)) {
      background(0);
      textSize(30);
      text("Both phones Phone Disconnected", width/20, height/20);
      textSize(15);
      showError();
  } else if(lastTimeUpper.getCurrentTime() - lastTimeUpper.getInitTime() > 3) {
      background(0);
      textSize(30);
      text("Upper Arm Phone Disconnected", width/20, height/20);
      textSize(15);
      showError();
  } else if(lastTimeLower.getCurrentTime() - lastTimeLower.getInitTime() > 3) {
      background(0);
      textSize(30);
      text("Lower Arm Phone Disconnected", width/20, height/20);
      showError();
  }
}

void showError() {
  textSize(15);
  text("Please check if: ", width/20, height/20 + 40);
  text("1. The app is open in phone. ", width/20, height/20 + 60);
  text("2. Phone is connected to same wifi as PC(not mobile data)", width/20, height/20 + 80);
  text("3. The IP address of PC is configured correctely in phone.pde file line: 19", width/20, height/20 + 100);
}

void segment(float x, float y, float angle) {
  //fill(255);
  translate(x, y);
  rotate(angle);
  line(0, 0, segLength, 0);
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.arguments()[0].equals("upper")){
    angleUpper = (Float) theOscMessage.arguments()[1];
    lastTimeUpper.setInitTime();
  } else if(theOscMessage.arguments()[0].equals("lower")){
    angleLower = (Float) theOscMessage.arguments()[1];
    lastTimeLower.setInitTime();
  }
  if(angleLower < angleUpper){
    angleBetween = 360 - (angleUpper - angleLower);
  } else {
    angleBetween = angleLower - angleUpper;
  }
}
