class Spell extends GameObject {
  PVector dir;
  float speed;

  boolean sectumsempra = false;
  int sectumsempraTimer = 30;
  PVector leftHalf, rightHalf;

  boolean glacius = false;
  int glaciusTimer = 0;

  Spell() {
    super(0, 0, 0, 0);
  }

  Spell(float x, float y, float z, float speed, PVector direction) {
    super(x, y, z, 10);
    this.speed = speed;
    dir = direction.copy();
    dir.setMag(speed);
  }


  void act() {
    if (lives <= 0 && sectumsempra == false) {
      sectumsempra = true;
      leftHalf = new PVector(-3, 0, 0);
      rightHalf = new PVector(3, 0, 0);
    }

    if (sectumsempra) {
      sectumsempraTimer--;
      leftHalf.x -= 0.5;
      rightHalf.x += 0.5;
      return;
    }

    if (glacius) {
      glaciusTimer--;
      if (glaciusTimer <= 0) {
        glacius = false;
      }
      return;
    }
  }

  void show() {
    if (lives <= 0 && sectumsempra == false) return;

    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);

    if (sectumsempra) {
      world.fill(255, 0, 255);
      world.stroke(100);

      // Left half
      world.pushMatrix();
      world.translate(leftHalf.x, leftHalf.y, leftHalf.z);
      world.box(size / 2, size, size);
      world.popMatrix();

      // Right half
      world.pushMatrix();
      world.translate(rightHalf.x, rightHalf.y, rightHalf.z);
      world.box(size / 2, size, size);
      world.popMatrix();
    } else {
      if (glacius) {
        world.fill(100, 200, 255);
      } else {
        world.fill(150, 0, 0);
      }
      world.stroke(50);
      world.box(size);
    }

    world.popMatrix();
  }
}


//int getIndex() {
//  while (true) {
//    int index = int(random(spells.size()));
//    if (!used[index]) {
//      used[index] = true;
//      return index;
//    }
//  }
//}
