class GameObject {

  int lives;
  float size;
  PVector loc;

  public GameObject() {
    loc = new PVector(0, 0, 0);
    size = 10;
    lives = 1;
  }

  public GameObject(float x, float y, float z, float s) {
    lives = 1;
    loc = new PVector(x, y, z);
    size = s;
  }

  void act() {
  }

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    world.fill(white);
    world.stroke(100);
    world.box(size);
    world.popMatrix();
  }
}
