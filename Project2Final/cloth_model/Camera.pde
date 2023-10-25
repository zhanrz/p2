float camR = 600.0; 
float camTheta = 3.0 * PI / 2.0; 
float camPhi = PI / 4.0;

void updateCamera() {
  float camX = camR * sin(camPhi) * cos(camTheta);
  float camY = camR * sin(camPhi) * sin(camTheta);
  float camZ = camR * cos(camPhi);

  camera(camX, camY, camZ, width/2.0, height/2.0, 0, 0, 1, 0);
}

void keyPressed_model() {
  float deltaTheta = PI / 36.0; 
  float deltaPhi = PI / 36.0;
  float deltaR = 10.0;
  
  if (key == 'W') {
    camR -= deltaR;
  } else if (key == 'S') {
    camR += deltaR;
  } else if (key == 'A') {
    camTheta -= deltaTheta;
  } else if (key == 'D') {
    camTheta += deltaTheta;
  } else if (key == 'Q') {
    camPhi = constrain(camPhi + deltaPhi, 0.01, PI - 0.01); 
  } else if (key == 'E') {
    camPhi = constrain(camPhi - deltaPhi, 0.01, PI - 0.01); 
  }
}

void mouseDragged() {
  camTheta -= (mouseX - pmouseX) * 0.01;
  camPhi -= (mouseY - pmouseY) * 0.01;
  camPhi = constrain(camPhi, 0.01, PI - 0.01); 
}
