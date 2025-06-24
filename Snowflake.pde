class Snowflake extends GameObject {
  PVector vel;
  float gravity = 0.2;
  int groundTime = 60; 

  Snowflake(PVector start) {
    super();
    loc = start.copy();
    vel = new PVector(0, random(1, 2), 0);
    lives = 100; 
  }

  void act() {
    loc.add(vel);
    vel.y += gravity;

    if (loc.y >= height) {
      loc.y = height;
      groundTime--;
      if (groundTime <= 0) {
        lives = 0;
      }
    }
  }

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    world.noStroke();
    world.fill(255);
    world.sphere(3);
    world.popMatrix();
  }
}
