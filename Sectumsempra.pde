class Sectumsempra extends Spell {
  Sectumsempra() {
    super(
      player.eye.x,
      player.eye.y,
      player.eye.z,
      50,
      new PVector(
        cos(player.leftRightHeadAngle),
        tan(player.upDownHeadAngle),
        sin(player.leftRightHeadAngle)
      )
    );
  }

  //void explode() {
  //  for (int i = 0; i < 8; i++) {
  //    Particle p = new Particle(loc.copy());
  //    p.vel = PVector.random3D().mult(10);
  //    objects.add(p);
  //  }

  //  for (int i = 0; i < objects.size(); i++) {
  //    GameObject obj = objects.get(i);
  //    if (obj instanceof Enemy) {
  //      if (PVector.dist(loc, obj.loc) < size * 2) {
  //        obj.lives = 0;
  //      }
  //    }
  //  }
  //}

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    world.fill(255, 255, 255);
    world.noStroke();
    world.sphere(size / 2);
    world.popMatrix();
  }
}

/*
class Sectumsempra extends Spell {
  Sectumsempra(float x, float y, float z, PVector direction) {
    super(x, y, z, 50, direction);
  }

  void explode() {
    for (int i = 0; i < 8; i++) {
      Particle p = new Particle(loc.copy());
      p.vel = PVector.random3D().mult(10);
      objects.add(p);
    }

    for (int i = 0; i < objects.size(); i++) {
      GameObject obj = objects.get(i);
      if (obj instanceof Enemy) {
        if (PVector.dist(loc, obj.loc) < size * 2) {
          obj.lives = 0;
        }
      }
    }
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
*/
