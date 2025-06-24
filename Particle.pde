class Particle extends GameObject {
  PVector vel;
  int lives = 30;

  Particle(PVector origin) {
    super(origin.x, origin.y, origin.z, 5, 0);
    vel = PVector.random3D().mult(random(2, 6));
  }

  void act() {
    loc.add(vel);
    vel.mult(0.95);
    lives--;
    if (lives <= 0) lives = 0;
  }

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    world.noStroke();
    world.fill(255, 150, 0, map(lives, 0, 30, 0, 255));
    world.sphere(size);
    world.popMatrix();
  }
}
