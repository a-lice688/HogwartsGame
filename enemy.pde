class Enemy extends GameObject {
  boolean frozen = false;
  int freezeTimer = 0;

  Enemy(float x, float y, float z) {
    super(x, y, z, 80);
    lives = 3;
  }

  void act() {
    if (frozen) {
      freezeTimer--;
      if (freezeTimer <= 0) frozen = false;
      return;
    }
  }

  void freeze(int duration) {
    frozen = true;
    freezeTimer = duration;
  }

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    if (frozen) {
      world.fill(100, 200, 255);
    } else {
      world.fill(150, 0, 0);
    }
    world.stroke(50);
    world.box(size);
    world.popMatrix();
  }
}
