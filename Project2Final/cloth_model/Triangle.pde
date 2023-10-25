class Triangle {
    int i1, j1, i2, j2, i3, j3;

    public Triangle(int i1, int j1, int i2, int j2, int i3, int j3) {
        this.i1 = i1;
        this.j1 = j1;
        this.i2 = i2;
        this.j2 = j2;
        this.i3 = i3;
        this.j3 = j3;
    }

    public Vec3 averageVelocity(Vec3[][] velocities) {
        return velocities[i1][j1].plus(velocities[i2][j2]).plus(velocities[i3][j3]).dividedBy(3.0f);
    }

    public Vec3 normal(Vec3[][] positions) {
        Vec3 v1 = positions[i2][j2].minus(positions[i1][j1]);
        Vec3 v2 = positions[i3][j3].minus(positions[i1][j1]);
        return v1.cross(v2).normalized();
    }
}
