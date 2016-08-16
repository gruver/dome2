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

void pulseImage(int loopCounter, AudioBuffer audioSource, PImage pulseImage, float intensityState) {
  imageMode(CENTER);
  /*
  audioFFT.forward(audioSource);
  
  float maxBass = 0;
  float expFilt = .75;
  
  for (int i = 0; i < 4; i++) {
    maxBass = max(maxBass, audioFFT.getBand(i));
  }
  
  intensityState = maxBass * expFilt + intensityState * (1-expFilt);
  */
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