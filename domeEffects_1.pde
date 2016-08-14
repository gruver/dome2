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