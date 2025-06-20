class Particle extends GameObject {

  PVector vel;
  PVector gravity;
  float speed;

  public Particle(PVector newloc) {
    super();
    lives = 255;
    loc = newloc.copy();
    speed = 50;

    vel = PVector.random3D().mult(speed);

    gravity = new PVector(0, 5, 0);
  }

  void act() {
    vel.add(gravity);
    loc.add(vel);
    lives--;
  }

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    world.fill(255);
    world.noStroke();
    world.sphere(size / 2);
    world.popMatrix();
  }
}
