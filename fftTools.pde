boolean beatDetect (AudioBuffer audioSource) {
  audioFFT.forward(audioSource);
  boolean isBeat = false;
  
  float fftTotal = 0;
  float peak = 0;
  int maxBin = -1;
  for (int i = 0; i < FFT_BIN_COUNT; i++) {
    fftTotal += audioFFT.getBand(i);
    if (audioFFT.getBand(i) > peak) {
      peak = audioFFT.getBand(i);
      maxBin = i;
    }
  }
  
  if ( maxBin < int(FFT_BIN_COUNT / 3)-1 ) {
    isBeat = true;
  }
  
  
  
  return isBeat;
}