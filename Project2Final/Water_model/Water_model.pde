int n = 40;   
float dx = 2.0f; 
float[] h, hu; 
float dt;
float scale = 0.10f;
float lastFrameStart;


float ballX;         
float ballY;         
float ballSpeedX;    
float ballSpeedY;    
float ballRadius;   
float gravity = 0.1f; 
float buoyancyFactor = 0.2f; 


void setup() {
  size(500, 500);
  
  h = new float[n];
  hu = new float[n];
  
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = 0;
  ballSpeedY = 0;
  ballRadius = 15;
  

  for (int i = 0; i < n; i++) {
    h[i] = 2.0f * i / n + 1;
  }

  lastFrameStart = millis();
}

void draw() {
  background(255);
  dt = (millis() - lastFrameStart) / 1000.0f;
  lastFrameStart = millis();

  for (int i = 0; i < 500; i++) {
    simulateSWE(h, hu, dx, dt / 50.0f);
  }




  fill(0, 0, 255);
  for (int i = 0; i < n - 1; i++) {
    float x1 = map(i, 0, n - 1, 0, width);
    float x2 = map(i + 1, 0, n - 1, 0, width);
    float y1 = height - h[i] * scale * height;
    float y2 = height - h[i + 1] * scale * height;
    beginShape();
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x2, height);
    vertex(x1, height);
    endShape(CLOSE);
  }
  
 for (int i = 0; i < n - 1; i++) {
    float x1 = map(i, 0, n - 1, 0, width);
    float x2 = map(i + 1, 0, n - 1, 0, width);
    float y1 = height - h[i] * scale * height;
    
   
    color topColor = color(100, 150, 255);  
    color bottomColor = color(0, 0, 128);   
    
    for (int j = (int)y1; j <= height; j++) {
      float ratio = map(j, y1, height, 0, 1);
      color c = lerpColor(topColor, bottomColor, ratio);
      stroke(c);
      line(x1, j, x2, j);
    }
  }
  
  ballSpeedY += gravity;
  

  int closestIndex = int(map(ballX, 0, width, 0, n - 1));
  float waterLevelAtBall = height - h[closestIndex] * scale * height;
  float submergedDepth = max(0, (ballY + ballRadius) - waterLevelAtBall);
  
  if (submergedDepth > 0) {
      float buoyancy = buoyancyFactor * submergedDepth;
      ballSpeedY -= buoyancy;
  
  
      h[closestIndex] -= submergedDepth * 0.02; 
      hu[closestIndex] += ballSpeedX * 0.1; 
  }
  
  ballY += ballSpeedY;
  ballX += ballSpeedX;
  
  
  fill(255, 0, 0);
  ellipse(ballX, ballY, ballRadius * 2, ballRadius * 2);

  
  
}

void simulateSWE(float[] h, float[] hu, float dx, float dt) {
  float g = 1.0f;  // gravity
  float damp = 0.9f;
  int n = h.length;

  float[] dhdt = new float[n]; 
  float[] dhudt = new float[n]; 
  float[] h_mid = new float[n]; 
  float[] hu_mid = new float[n]; 
  float[] dhdt_mid = new float[n]; 
  float[] dhudt_mid = new float[n];  


  for (int i = 0; i < n - 1; i++) {
    h_mid[i] = (h[i] + h[i+1]) / 2.0f;
    hu_mid[i] = (hu[i] + hu[i+1]) / 2.0f;
  }

 
  for (int i = 0; i < n - 1; i++) {
    float dhudx_mid = (hu[i+1] - hu[i]) / dx;
    dhdt_mid[i] = -dhudx_mid;

    float dhu2dx_mid = (hu[i+1] * hu[i+1] / h[i+1] - hu[i] * hu[i] / h[i]) / dx;
    float dgh2dx_mid = (g * h[i+1] * h[i+1] - h[i] * h[i]) / dx;
    dhudt_mid[i] = -(dhu2dx_mid + 0.5f * dgh2dx_mid);
  }

  
  for (int i = 0; i < n; i++) {
    h_mid[i] += dhdt_mid[i] * dt / 2.0f;
    hu_mid[i] += dhudt_mid[i] * dt / 2.0f;
  }


  for (int i = 1; i < n - 1; i++) {
    float dhudx = (hu_mid[i] - hu_mid[i-1]) / dx;
    dhdt[i] = -dhudx;

    float dhu2dx = (hu_mid[i] * hu_mid[i] / h_mid[i] - hu_mid[i-1] * hu_mid[i-1] / h_mid[i-1]) / dx;
    float dgh2dx = g * (h_mid[i] * h_mid[i] - h_mid[i-1] * h_mid[i-1]) / dx;
    dhudt[i] = -(dhu2dx + 0.5f * dgh2dx);
  }

 
  for (int i = 0; i < n; i++) {
    h[i] += damp * dhdt[i] * dt;
    hu[i] += damp * dhudt[i] * dt;
  }


  h[0] = h[1];
  h[n-1] = h[n-2];
  hu[0] = -hu[1];
  hu[n-1] = -hu[n-2];
}
