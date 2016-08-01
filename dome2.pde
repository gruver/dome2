import ddf.minim.analysis.*;
import ddf.minim.*;
import java.util.*;

Minim minim;
AudioPlayer song;
AudioInput audioStream;
BeatDetect beat;

OPC opc;

JSONObject systemState;

PImage colorWheel;

String songSource = "Country_Roads.mp3";

int controllerKey = 0;
float goggleIntensity = 0;
float blinkColor = 30;

void setup() {
  size(800, 400, P2D);
  colorMode(HSB,100);
  rectMode(CENTER);
  
  
  // Setup the Open Pixel Controller
  OPC opc = new OPC(this, "127.0.0.1", 7890);
  opc.ledGrid8x8(0,550,200,30,PI,false);
  opc.ledGrid8x8(64,250,200,30,PI/2,false);
  
  colorWheel = loadImage("hueGradient.png");
  
  minim = new Minim(this);
  song = minim.loadFile(songSource, 2048);
  audioStream = minim.getLineIn(Minim.MONO, 1024);
  //audioStream.enableMonitoring();
  //song.play();
  
  beat = new BeatDetect();
}

void draw() {
  background(0,0,0,0);
  systemState = loadJSONObject("state.json");
  String stateMessage = systemState.getString("state1");
  float blobColor = systemState.getFloat("color");
  fill(0,0,100);
  text(stateMessage,20,380);
  fill(blobColor,100,100);
  rect(400,200,600,300);
  
  blinkColor = (blinkColor+.9) % 100;
  
  fill(20,100,100);
  rect(mouseX, mouseY, 80, 80);
  
  beat.detect(audioStream.mix);
  if (beat.isOnset()) {
    goggleIntensity = 100;
    
  }
  fill(blinkColor,100,100,goggleIntensity);
  rect(400,200,600,300);
  goggleIntensity *= .91;
  fill(0,0,100,100);
  //text(blinkColor, 20, 380);
  text("Key Number: " + controllerKey, 20, 20);
}

void keyPressed() {
  controllerKey = key;
  blinkColor = (blinkColor + 1.5) % 100;
}