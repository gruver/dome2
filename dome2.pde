import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.*;

Minim minim;
AudioPlayer song;
AudioInput audioStream;
BeatDetect beat;
FFT audioFFT;

int FFT_BIN_COUNT = 4;

OPC opc;

JSONObject systemState;

PImage colorWheel;
PImage bwTwinkle;

String songSource = "Country_Roads.mp3";

int controllerKey = 0;
float domeIntensity = 0;
float blinkColor = 30;

int loopCounter = 0;
int runMode = 4; //pull this from JSON file

void setup() {
  size(800, 400, P2D);
  colorMode(HSB,100);
  rectMode(CENTER);
  imageMode(CENTER);
  
  // Setup the Open Pixel Controller
  OPC opc = new OPC(this, "127.0.0.1", 7890);
  opc.ledGrid8x8(0,530,200,30,PI,false);
  opc.ledGrid8x8(64,270,200,30,PI/2,false);
  
  colorWheel = loadImage("hueGradient.png");
  bwTwinkle = loadImage("black_white_crystals.jpg");
  
  minim = new Minim(this);
  song = minim.loadFile(songSource, 2048);
  audioStream = minim.getLineIn(Minim.MONO, 1024);
  audioFFT = new FFT(audioStream.bufferSize(), audioStream.sampleRate());
  audioFFT.linAverages(FFT_BIN_COUNT);
  //audioStream.enableMonitoring();
  //song.play();
  
  beat = new BeatDetect();
}

void draw() {
  background(0,0,0,0); //black background - reset
  loopCounter = loopCounter + 1;
  systemState = loadJSONObject("state.json");
  //String stateMessage = systemState.getString("state1");
  float blobColor = systemState.getFloat("color");
  
  runMode = int(blobColor / 25)+1;
  
  switch (runMode) {
    case 1 :
      //color wheel
      spinImage(loopCounter, .5, colorWheel);
      break;
    case 2 :
      //4 panel FFT
      audioFFT.forward(audioStream.mix);
      for (int i = 1; i <= FFT_BIN_COUNT; i++) {
        fill(blobColor,100,100,audioFFT.getBand(i));
        rect(100+200*(i-1),200,200,300);
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
      rect(width/2,height/2,600,300);
      break;
    case 4 :
      //twinkle
      spinImage(loopCounter,1.3,bwTwinkle);
      break;
  }
  
  fill(0,0,0,100);
  rect(100,380,400,30);
  fill(0,0,100,100);
  text("Mode: " + runMode, 20, 20);
  text("Color: " + blobColor, 300, 20);
  text("Counter: " + loopCounter, 20,380);
}

void keyPressed() {
  controllerKey = key;
  blinkColor = (blinkColor + 1.5) % 100;
}