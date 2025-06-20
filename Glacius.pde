class Glacius extends Spell {
  Glacius() {
    super(player.eye.x, player.eye.y, player.eye.z, 60,
      new PVector(cos(player.leftRightHeadAngle), tan(player.upDownHeadAngle), sin(player.leftRightHeadAngle)));
  }

  //void explode() {
  //  for (int i = 0; i < 5; i++) {
  //    objects.add(new Particle(loc));
  //  }

  //  for (int i = 0; i < objects.size(); i++) {
  //    GameObject obj = objects.get(i);
  //    if (obj instanceof Enemy) {
  //      if (PVector.dist(loc, obj.loc) < size * 3) {
  //        ((Enemy)obj).freeze(180);
  //      }
  //    }
  //  }
  //}

  void show() {
    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    world.fill(100, 200, 255);
    world.noStroke();
    world.sphere(size / 2);
    world.popMatrix();
  }
}
