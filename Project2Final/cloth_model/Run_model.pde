Cloth cloth;
SphereObstacle obstacle;  

void setup() {
 
  size(800, 600, P3D);  
  cloth = new Cloth(8); 
  obstacle = new SphereObstacle(new Vec3(400, 300, 0), 150);  
  cloth.addObstacle(obstacle); 
  cloth.loadTexture("/Users/admin/Desktop/CSCI5611/Project2Final/cloth_model/data/Ball.jpg");
}

void draw() {
  updateCamera();

  ambientLight(50, 50, 50);  
  directionalLight(255, 255, 255, 0, -1, -1);
  pointLight(255, 0, 0, 200, 100, 100); 
  specular(250);

  background(220);
  cloth.update(0.05);
  cloth.displayObstacles();  
  cloth.display();
 
}




void keyPressed() {
  
    

  obstacle.handleKeyPress(key);
  
  float deltaTheta = PI / 36.0; 
  float deltaPhi = PI / 36.0;
  float deltaR = 10.0;
  
  char inputKey = Character.toUpperCase(key);
  
  if (inputKey == 'W') {
    camR -= deltaR;
  } else if (inputKey == 'S') {
    camR += deltaR;
  } else if (inputKey == 'A') {
    camTheta -= deltaTheta;
  } else if (inputKey == 'D') {
    camTheta += deltaTheta;
  } else if (inputKey == 'Q') {
    camPhi = constrain(camPhi + deltaPhi, 0.01, PI - 0.01); 
  } else if (inputKey == 'E') {
    camPhi = constrain(camPhi - deltaPhi, 0.01, PI - 0.01); 
  }
  
  
}
