class CollisionChecker extends GameObject {
  CollisionChecker(float x, float y, float z, float size) {
    super();
    loc = new PVector(x, y, z);
    this.size = size;
  }
}
