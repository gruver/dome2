import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.*;

Minim minim;
AudioPlayer song;
AudioInput audioStream;
BeatDetect beat;
FFT audioFFT;

int FFT_BIN_COUNT = 12;
int LIGHT_CONFIG = 2; //1==dome, 2==goggles, 3==elephant

OPC opc;

JSONObject systemState;

PImage colorWheel;
PImage bwTwinkle;

String songSource = "Country_Roads.mp3";

int controllerKey = 0;
float domeIntensity = 0;
float blinkColor = 30;
int fadeStart = 0; //marker for fadeDome()

int loopCounter = 0;
int runMode = 4; //pull this from JSON file
float stateTracker = 0; //hold a state for an effect

int DOME_ROW_COUNT = 5;
float ROW_SCALE_1 = .10;
float ROW_SCALE_2 = .25;
float ROW_SCALE_3 = .40;
float ROW_SCALE_4 = .55;
float ROW_SCALE_5 = .70;
float[] ROW_SCALE_ARRAY = {ROW_SCALE_1, ROW_SCALE_2, ROW_SCALE_3, ROW_SCALE_4, ROW_SCALE_5};

void setup() {
  size(400, 500, P2D);
  colorMode(HSB,100);
  rectMode(CENTER);
  imageMode(CENTER);
  
  // Setup the Open Pixel Controller
  OPC opc = new OPC(this, "127.0.0.1", 7890);
  
  LIGHT_CONFIG = loadJSONObject("system_config.json").getInt("lightConfig");
  switch (LIGHT_CONFIG) {
    case 1 :
      //dome
      opc.ledRing(0, 20, width/2, height/2, (width/2)*ROW_SCALE_5, .157);
      opc.ledRing(64, 20, width/2, height/2, (width/2)*ROW_SCALE_4, 0);
      opc.ledRing(128, 15, width/2, height/2, (width/2)*ROW_SCALE_3, 0);
      opc.ledRing(192, 10, width/2, height/2, (width/2)*ROW_SCALE_2, 0);
      opc.ledRing(202, 5, width/2, height/2, (width/2)*ROW_SCALE_1, 0); //Also on connector 4
      break;
    case 2 :
      //goggles
      opc.ledGrid8x8(0,width/2+75,height/2,15,PI,false);
      opc.ledGrid8x8(64,width/2-75,height/2,15,PI/2,false);
      break;
  }
  
  colorWheel = loadImage("hueGradient.png");
  bwTwinkle = loadImage("black_white_crystals.jpg");
  
  minim = new Minim(this);
  song = minim.loadFile(songSource, 2048);
  audioStream = minim.getLineIn(Minim.STEREO, 1024);
  audioFFT = new FFT(audioStream.bufferSize(), audioStream.sampleRate());
  audioFFT.linAverages(FFT_BIN_COUNT);
  //audioStream.enableMonitoring();
  //song.play();
  
  beat = new BeatDetect();
}

void draw() {
  background(0,0,0,0); //black background - reset
  loopCounter = loopCounter + 1;
  systemState = loadJSONObject("localstate.json");
  //String stateMessage = systemState.getString("state1");
  float blobColor = systemState.getFloat("color");
  int runMode = systemState.getInt("runMode");
  //runMode = int(blobColor / 25)+1;
  
  switch (runMode) {
    default :
    case 0 :
      //color wheel
      spinImage(loopCounter, .35, colorWheel);
      break;
    case 1 :
      fadeDome(loopCounter, 1, 20, 2.1);
      break;
    case 2 :
      //4 panel FFT
      audioFFT.forward(audioStream.mix);
      for (int i = 1; i <= FFT_BIN_COUNT; i++) {
        fill(blobColor,100,100,2.0*audioFFT.getBand(i));
        rect(width/(2*FFT_BIN_COUNT)*(2*i-1),height/2,width/FFT_BIN_COUNT,300);
      }
      break;
    case 3 :
      //beat detect
      beat.detect(audioStream.mix);
      if (beat.isOnset()) {
        domeIntensity = 100; 
      }
      domeIntensity *= .91;
      fill(blobColor,100,100,domeIntensity);
      rect(width/2,height/2,300,300);
      break;
    case 4 :
      //twinkle
      spinImage(loopCounter,1.3,bwTwinkle);
      break;
    case 5 :
      pulseImage(loopCounter,audioStream.mix,colorWheel,stateTracker);
      break;
    case 6 :
      //gradient between two colors
      fadeDome(loopCounter, 30, 65, 1.2);
      break;
    case 7 :
      smoothRainbow(loopCounter, .05);
      break;
    case 8 :
      twoColorTwinkle(loopCounter,.4,80,85);
      break;
  }
  
  fill(0,0,0,100);
  rect(100,height-20,400,20);
  fill(0,0,100,100);
  text("Mode: " + runMode, 20, 20);
  text("Color: " + blobColor, 300, 20);
  text("Counter: " + loopCounter, 20,height-15);
}

void keyPressed() {
  
  if (key == 'n') {
     systemState = loadJSONObject("localstate.json");
     int runMode = systemState.getInt("runMode");
     runMode = (runMode + 1) % 9;
     systemState.setInt("runMode", runMode);
     saveJSONObject(systemState, "data/localstate.json");
  }
}