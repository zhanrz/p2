public class Cloth {
    
    int maxNodes = 100;
    Vec3 pos[][] = new Vec3[maxNodes][maxNodes];
    Vec3 vel[][] = new Vec3[maxNodes][maxNodes];
    Vec3 acc[][] = new Vec3[maxNodes][maxNodes];
    int numNodes = 40;

    public float restLength;
    private Triangle[][][] triangles;
    PImage clothTexture;
    Vec3 gravity = new Vec3(0, 5, 0);

    private final float damping = 0.01f;
    private final float springConstant = 12f;
    private final float nodeMass = 0.3f;
    
    float airDensity = 0.1f;      // Density k
    float dragCoefficient = 0.001f; // Drag c
    Vec3 windVelocity = new Vec3(-35.0f, 0.0f, 0.0f);  // Wind speed and direc
    
    //float pullStrength = 100.0f;
    //float frequency = 0.5f;    


    
   
    
    
    ArrayList<SphereObstacle> obstacles; 
    
    public void displayObstacles() {
        for (SphereObstacle obstacle : obstacles) {
            obstacle.display();
        }
    }

    public void addObstacle(SphereObstacle obstacle) {
        this.obstacles.add(obstacle);
    }
    
    
    public void loadTexture(String path) {
        this.clothTexture = loadImage(path);
    }

    public Cloth(float segmentLength) {
        this.restLength = segmentLength;
        float xOffset = 150;  
        
        this.obstacles = new ArrayList<>(); 

        for (int i = 0; i < numNodes; i++) {
            for (int j = 0; j < numNodes; j++) {
                float yOffset = i * segmentLength * 0.5f;  
                pos[i][j] = new Vec3(i * segmentLength + xOffset, j * segmentLength - yOffset, 0);
                vel[i][j] = new Vec3(0,0,0);  
                acc[i][j] = new Vec3(0,0,0);  
            }
        }
    
        // Create triangles 
        triangles = new Triangle[numNodes-1][numNodes-1][2];
    
        for (int i = 0; i < numNodes - 1; i++) {
            for (int j = 0; j < numNodes - 1; j++) {
                triangles[i][j][0] = new Triangle(i, j, i+1, j, i, j+1);
                triangles[i][j][1] = new Triangle(i+1, j, i+1, j+1, i, j+1);

            }
        }
    }



    public void display() {
        textureMode(NORMAL);
        noStroke();
        for (int j = 0; j < numNodes - 1; j++) {          
            beginShape(TRIANGLE_STRIP);
            texture(clothTexture); 
            for (int i = 0; i < numNodes; i++) {          
                Vec3 node1 = pos[i][j];
                float u1 = map(i, 0, numNodes - 1, 0, 1); 
                float v1 = map(j, 0, numNodes - 1, 0, 1); 
                vertex(node1.x, node1.y, node1.z, u1, v1);
                Vec3 node2 = pos[i][j + 1];
                float u2 = u1; 
                float v2 = map(j + 1, 0, numNodes - 1, 0, 1); 
                vertex(node2.x, node2.y, node2.z, u2, v2);
            }
            endShape();
        }
    }

  
      public void update(float dt) {
      
      // Apply gravity 
      for (int i = 0; i < numNodes; i++) {
          for (int j = 0; j < numNodes; j++) {
              
              acc[i][j].add(gravity);
             
              if (j == 0) {
                  vel[i][j] = new Vec3(0,0,0);
                  acc[i][j] = new Vec3(0,0,0);
              }
          }
      }
      
      //for (int i = 0; i < numNodes; i++) {
      //      float pullForce = pullStrength * sin(frequency * millis() * 0.001f); 
      //      acc[i][numNodes - 1].y += pullForce; 
      //  }


  
          // Apply spring forces
          for (int iterations = 0; iterations < 5; iterations++) {
              for (int i = 0; i < numNodes; i++) {
                  for (int j = 0; j < numNodes; j++) {
                      if (i < numNodes - 1) {
                          resolveSpring(i, j, i + 1, j);
                      }
                      if (j < numNodes - 1) {
                          resolveSpring(i, j, i, j + 1);
                      }
                  }
              }
          }
  
          // Integrate
          for (int i = 0; i < numNodes; i++) {
              for (int j = 0; j < numNodes; j++) {
                  vel[i][j] = vel[i][j].plus(acc[i][j].times(dt));
                  pos[i][j] = pos[i][j].plus(vel[i][j].times(dt));
                  acc[i][j] = new Vec3(0, 0, 0); 
              }
          }
          

            for (int i = 0; i < numNodes - 1; i++) {
                for (int j = 0; j < numNodes - 1; j++) {
                    for (Triangle triangle : triangles[i][j]) {
                        
                        Vec3 avgVel = triangle.averageVelocity(vel);
            
                       
                        Vec3 relativeVel = avgVel.minus(windVelocity);
            
                     
                        Vec3 normal = triangle.normal(pos);
            
                        
                        float projectedArea = 0.5f * relativeVel.cross(normal).length();
            
                        
                        Vec3 dragDirection = relativeVel.normalized();
                        Vec3 dragForce = dragDirection.times(0.5f * airDensity * dragCoefficient * relativeVel.lengthSqr() * projectedArea);
            
                        
                        Vec3 forcePerVertex = dragForce.dividedBy(3.0f);
                        acc[triangle.i1][triangle.j1].add(forcePerVertex);
                        acc[triangle.i2][triangle.j2].add(forcePerVertex);
                        acc[triangle.i3][triangle.j3].add(forcePerVertex);
                    }
                }
            }



  
          // Apply damping
          for (int i = 0; i < numNodes; i++) {
              for (int j = 0; j < numNodes; j++) {
                  vel[i][j] = vel[i][j].times(1 - damping);
              }
          }

          
          
          for (int i = 0; i < numNodes; i++) {
              for (int j = 0; j < numNodes; j++) {
                  for (SphereObstacle obstacle : obstacles) {
                      if (obstacle.isCollidingWith(pos[i][j])) {
                          SphereObstacle.CollisionResolution resolution = obstacle.resolveCollision(pos[i][j], vel[i][j]);
                          pos[i][j] = resolution.point;  
                          vel[i][j] = resolution.velocity;  
                      }
                  }
              }
          }
  }
    
    

  
private void resolveSpring(int i1, int j1, int i2, int j2) {
    Vec3 delta = pos[i2][j2].minus(pos[i1][j1]);
    float dist = delta.length();
    float elongation = dist - restLength;
    float forceMagnitude = springConstant * elongation;
    Vec3 force = delta.normalized().times(forceMagnitude);
    
        if (j1 != 0) {
            Vec3 forceAcc1 = force.dividedBy(nodeMass);
            acc[i1][j1] = acc[i1][j1].plus(forceAcc1);
        }
        
        if (j2 != 0) {
            Vec3 forceAcc2 = force.times(-1).dividedBy(nodeMass);
            acc[i2][j2] = acc[i2][j2].plus(forceAcc2);
        }
    }


}
