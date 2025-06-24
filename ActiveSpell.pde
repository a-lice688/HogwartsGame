class ActiveSpell extends GameObject {
  PVector vel;
  boolean fromPlayer;
  int lives = 180;
  int glowColour;
  int lightTimer = 180;

  ActiveSpell(PVector start, PVector dir, boolean fromPlayer, int glowColour1, int glowColour2, int glowColour3) {
    super(start.x, start.y, start.z, 10, 1);
    this.vel = dir.copy().mult(20);
    this.fromPlayer = fromPlayer;
    this.glowColour = color(glowColour1, glowColour2, glowColour3);
  }

  void update() {
    loc.add(vel);
    lives--;
    lightTimer--;
  }

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    world.noStroke();
    world.emissive(glowColour);
    world.fill(glowColour);
    world.sphere(5);
    world.popMatrix();

    if (lightTimer > 0 && dist(player.eye.x, player.eye.y, player.eye.z, loc.x, loc.y, loc.z) < 500) {
      world.pointLight(
        red(glowColour), green(glowColour), blue(glowColour),
        loc.x, loc.y, loc.z
      );
    }
  }

  void act() {
    loc.add(vel);
    lives--;
  }
}
