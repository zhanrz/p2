public class Vec3 {
    
  public float x, y, z;

  
    public Vec3(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    public Vec3 dividedBy(float scalar) {
        return new Vec3(this.x / scalar, this.y / scalar, this.z / scalar);
    }


   
    public String toString() {
        return "(" + x + ", " + y + ", " + z + ")";
    }

   
    public float length() {
        return (float) Math.sqrt(x*x + y*y + z*z);
    }

   
    public float lengthSqr() {
        return x*x + y*y + z*z;
    }


    public Vec3 plus(Vec3 rhs) {
        return new Vec3(x + rhs.x, y + rhs.y, z + rhs.z);
    }

   
    public void add(Vec3 rhs) {
        x += rhs.x;
        y += rhs.y;
        z += rhs.z;
    }

 
    public Vec3 minus(Vec3 rhs) {
        return new Vec3(x - rhs.x, y - rhs.y, z - rhs.z);
    }

    
    public void subtract(Vec3 rhs) {
        x -= rhs.x;
        y -= rhs.y;
        z -= rhs.z;
    }


    public Vec3 times(float rhs) {
        return new Vec3(x*rhs, y*rhs, z*rhs);
    }


    public void mul(float rhs) {
        x *= rhs;
        y *= rhs;
        z *= rhs;
    }


    public void div(float rhs) {
        x /= rhs;
        y /= rhs;
        z /= rhs;
    }


    public void normalize() {
        float mag = length();
        if (mag == 0) return; 
        x /= mag;
        y /= mag;
        z /= mag;
    }

   
    public Vec3 normalized() {
        float mag = length();
        if (mag == 0) return new Vec3(0, 0, 0); 
        return new Vec3(x/mag, y/mag, z/mag);
    }

    
    public void clampToLength(float maxL) {
        float mag = length();
        if (mag == 0) return; 
        if (mag > maxL) {
            x *= maxL/mag;
            y *= maxL/mag;
            z *= maxL/mag;
        }
    }

 
    public void setToLength(float newL) {
        float mag = length();
        if (mag == 0) return; 
        x *= newL/mag;
        y *= newL/mag;
        z *= newL/mag;
    }
    
    public float dot(Vec3 other) {
        return this.x * other.x + this.y * other.y + this.z * other.z;
    }


  
    public float distanceTo(Vec3 rhs) {
        float dx = x - rhs.x;
        float dy = y - rhs.y;
        float dz = z - rhs.z;
        return (float) Math.sqrt(dx*dx + dy*dy + dz*dz);
    }
    
        public Vec3 cross(Vec3 other) {
        return new Vec3(
            y * other.z - z * other.y,
            z * other.x - x * other.z,
            x * other.y - y * other.x
        );
    }

}

   
    Vec3 interpolate(Vec3 a, Vec3 b, float t) {
        return a.plus((b.minus(a)).times(t));
    }


    float dot(Vec3 a, Vec3 b) {
        return (a.x * b.x + a.y * b.y + a.z * b.z);
    }
    
    

 
    Vec3 cross(Vec3 a, Vec3 b) {
        float cx = a.y*b.z - a.z*b.y;
        float cy = a.z*b.x - a.x*b.z;
        float cz = a.x*b.y - a.y*b.x;
        return new Vec3(cx, cy, cz);
    }

    
    Vec3 projAB(Vec3 a, Vec3 b) {
        float dotProduct = dot(a, b);
        return b.times(dotProduct);
    }
