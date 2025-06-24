class GameObject {
  int lives;
  float size;
  PVector loc;

  public GameObject() {
    loc = new PVector(0, 0, 0);
    size = 10;
    lives = 1;
  }

  public GameObject(float x, float y, float z, float s, int l) {
    lives = l;
    loc = new PVector(x, y, z);
    size = s;
  }

  void act() {
  }

  void show() {
  }
}
