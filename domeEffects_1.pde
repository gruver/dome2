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