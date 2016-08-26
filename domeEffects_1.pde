void spinImage(int loopCounter, float speed, PImage projectedImage) {
  imageMode(CENTER);
  float theta = radians((float(loopCounter) * speed) % 360);
  tint(color(0,0,100));
  pushMatrix();
  translate(width/2, height/2);
  rotate(theta);
  image(projectedImage, 0, 0);
  popMatrix();
}

void fourCorners(int loopCounter, AudioBuffer audioSource) {
  color c1 = color(3,100,100);
  color c2 = color(20,100,100);
  color c3 = color(40,100,100);
  color c4 = color(65,100,100);
  
  int binsInQuad = FFT_BIN_COUNT / 4;
  
  float b1 = 0;
  float b2 = 0;
  float b3 = 0;
  float b4 = 0;
  
  audioFFT.forward(audioSource);
  
  for (int i = 0; i < binsInQuad; i++) {
    b1 += audioFFT.getBand(i);
    b2 += audioFFT.getBand(i+binsInQuad);
    b3 += audioFFT.getBand(i+2*binsInQuad);
    b4 += audioFFT.getBand(i+3*binsInQuad);
  }
  //normalize
  float scale = 2.0;
  b1 = b1/scale;
  b2 = b2/scale;
  b3 = b3/scale;
  b4 = b4/scale;
  
  fill(c1,b1);
  rect(width/4,height/2-width/4,width/2,width/2);
  fill(c2,b2);
  rect(3*width/4,height/2-width/4,width/2,width/2);
  fill(c3,b3);
  rect(width/4,height/2+width/4,width/2,width/2);
  fill(c4,b4);
  rect(3*width/4,height/2+width/4,width/2,width/2);
  
  
}

void beatPulse(int loopCounter, AudioBuffer audioSource, int c1, int c2) {
  background(0,0,0);
  ellipseMode(CENTER);
  fill(c1,100,80);
  rect(width/2,height/2,width,width);
  audioFFT.forward(audioSource);
  float bassSum = 0;
  int lower = 5;
  int upper = 8;
  for (int i = lower; i <= upper; i++) {
    bassSum += audioFFT.getBand(i);
  }
  if (bassSum > 300.0) {
    stateTracker = 1.0;
  }
  
  stateTracker = stateTracker *= .91;
  fill(c2,100,100);
  ellipse(width/2,height/2,stateTracker*width,stateTracker*width);
}

void pulseImage(int loopCounter, AudioBuffer audioSource, PImage pulseImage, float intensityState) {
  imageMode(CENTER);
  intensityState = int(beatDetect(audioSource)) * 100;
  
  tint(color(0,0,100,max(30,intensityState)));
  pushMatrix();
  translate(width/2,height/2);
  image(pulseImage,0,0);
  popMatrix();
  
  fill(0,0,100,100);
  //text("Max bass: " + maxBass, 20, 100);
}

void fadeDome (int loopCounter, int color1, int color2, float speed) {
  //assume fade over 200 cycles
  int fadeTime = int(200/speed);
  if (loopCounter >= fadeStart + 2*fadeTime) {
    fadeStart = loopCounter; //reset
  }
  
  float progress = float(loopCounter - fadeStart) / fadeTime;
  color c = 0;
  if (progress <= 1) {
    c = lerpColor(color1, color2, progress);
  }
  else {
    c = lerpColor(color2, color1, progress - 1);
  }
  background(0,0,0);
  fill(0,0,100);
  text("Progress: " + progress, 20, 50);
  fill(c,100,100);
  rect(width/2,height/2, .9*width, .9*width);
  
}

void smoothRainbow (int loopCounter, float speed) {
  int c = int(loopCounter * speed) % 100;
  background(0,0,0);
  fill(c,100,100);
  rect(width/2,height/2,width * .95, width * .95);
}

void twoColorTwinkle(int loopCounter, float speed, int color1, int color2, int barPairs) {
  background(0,0,0);
  color c1 = color(color1,100,100);
  color c2 = color(color2,100,100);
  if (color2 == -1) {
    c2 = color(0,0,100);
  }
    
  int bars = barPairs * 2;
  float theta = radians((float(loopCounter) * speed) % 360);
  
  pushMatrix();
  translate(width/2, height/2);
  rotate(theta);
  translate(-width/2, -height/2);
  for(int i = 0; i < bars; i++) {
    if (i%2==0) {
      fill(c1);
    } else {
      fill(c2);
    }
    rect(width*(2*i+1)/(bars*2),height/2,width/bars,width);
  }

  popMatrix();
  
}