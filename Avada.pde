class AvadaKedavra extends Spell {

  AvadaKedavra() {
    super(player.eye.x, player.eye.y, player.eye.z, 60,
      new PVector(cos(player.leftRightHeadAngle), tan(player.upDownHeadAngle), sin(player.leftRightHeadAngle)));
  }

  //void explode() {
  //  for (int i = 0; i < 10; i++) {
  //    objects.add(new Particle(loc));
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
    world.fill(0, 255, 0);
    world.noStroke();
    world.sphere(size / 2);
    world.popMatrix();
  }
}
