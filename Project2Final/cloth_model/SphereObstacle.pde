class SphereObstacle {
    private Vec3 center;
    private float radius;
    private static final float SLACK = 0.01f;  

    void handleKeyPress(int key) {
        float moveAmount = 5.0f;  
    
        switch(key) {
            case 'u':
                center.y -= moveAmount;
                break;
            case 'i':
                center.y += moveAmount;
                break;
            case 'o':
                center.x -= moveAmount;
                break;
            case 'j':
                center.x += moveAmount;
                break;
            case 'k':
                center.z -= moveAmount;
                break;
            case 'l':
                center.z += moveAmount;
                break;
        }
    }



    SphereObstacle(Vec3 center, float radius) {
        this.center = center;
        this.radius = radius;
    }

    boolean isCollidingWith(Vec3 point) {
        return center.distanceTo(point) < radius + SLACK;
    }
    
    
    CollisionResolution resolveCollision(Vec3 point, Vec3 velocity) {
        float d = center.distanceTo(point);
        
        if (d < radius + SLACK) {
            Vec3 n = point.minus(center).normalized();
            float dotProduct = velocity.dot(n);
    
         
            if (dotProduct < 0) {
                Vec3 reflectedVelocity = velocity.minus(n.times(2 * dotProduct));
                velocity = reflectedVelocity;
            }
    
    
            point = center.plus(n.times(radius + SLACK));
        }
        
        return new CollisionResolution(point, velocity);  
    }


    void display() {
        pushMatrix();  
        translate(center.x, center.y, center.z);  
        fill(255, 50, 50, 150);  
        noStroke();
        sphere(radius);
        popMatrix();
        stroke(0);
    }

   
    class CollisionResolution {
        Vec3 point;
        Vec3 velocity;

        CollisionResolution(Vec3 point, Vec3 velocity) {
            this.point = point;
            this.velocity = velocity;
        }
    }
}
