class Enemy extends GameObject {
  int attackCooldown = 0;

  boolean frozen = false;
  int frozenTimer = 0;

  int hitTimer = 0;

  boolean controlled = false;
  int controlTimer = 0;

  int explodeTimer = 0;

  boolean wasHit = false;
  boolean wasFrozen = false;

  PVector moveDir;
  int moveTimer = 0;

  float rotationY = 0;

  int hp = 100;
  float displayHP = 100;

  Enemy(float x, float y, float z) {
    super(x, y, z, 80, 3);

    moveDir = PVector.random2D();
    moveDir.setMag(2);
    moveTimer = int(random(60, 120));
  }


  void act() {

    checkForCollisions();

    wasHit = hitTimer > 0;

    displayHP = lerp(displayHP, hp, 0.1);

    if (hitTimer > 0) hitTimer--;

    if (frozen) {
      frozenTimer--;
      if (frozenTimer <= 0) frozen = false;
    }
    if (frozen) return;

    if (!challengeAccepted) return;

    if (controlled) {
      controlTimer--;
      followCrosshair();
      if (controlTimer <= 0) controlled = false;
      return;
    }

    move();
    rotationY += 0.01;

    if (attackCooldown <= 0) {
      castAtPlayer();
      attackCooldown = 120 + (int)random(60);
    } else attackCooldown--;
  }

  void castAtPlayer() {
    PVector origin = loc.copy();
    origin.y += gridSize * 3;
    PVector dir = PVector.sub(player.eye, origin).normalize();

    int choice = int(random(6));
    ActiveSpell spell;

    switch (choice) {
    case 0:
      spell = new AvadaKedavra(loc.copy(), dir, false);
      break;
    case 1:
      spell = new Imperio(loc.copy(), dir, false);
      break;
    case 2:
      spell = new Sectumsempra(loc.copy(), dir, false);
      break;
    case 3:
      spell = new Confringo(loc.copy(), dir, false);
      break;
    case 4:
      spell = new Glacius(loc.copy(), dir, false);
      break;
    case 5:
      spell = new Reducto(loc.copy(), dir, false);
      break;
    default:
      spell = new Reducto(loc.copy(), dir, false);
    }

    activeSpells.add(spell);
    objects.add(spell);
  }


  void show() {
    drawModels(loc.x, loc.y, loc.z, 1, 1, 1, guardianStatue, 0, rotationY, PI);

    world.pushMatrix();
    world.translate(loc.x, loc.y, loc.z);
    if (hitTimer > 0) {
      world.fill(255, 0, 0); //red flash
    } else if (frozen) {
      world.fill(100, 200, 255); //blue flash
    }
    world.popMatrix();
  }

  void checkForCollisions() {

    hp = int(map(lives, 3, 0, 100, 0));

    for (int i = objects.size() - 1; i >= 0; i--) {
      GameObject obj = objects.get(i);

      if (obj instanceof ActiveSpell) {
        ActiveSpell s = (ActiveSpell) obj;
        if (s.fromPlayer && dist(loc.x, loc.y, loc.z, obj.loc.x, obj.loc.y, obj.loc.z) < 50) {
          if (lives > 1) {
            if (obj instanceof Glacius) {
              frozen = true;
              frozenTimer = 10;
              lives--;
            } else if (obj instanceof AvadaKedavra) {
              hitTimer = 10;
              lives = 0;
            } else if (obj instanceof Imperio) {
              hitTimer = 10;
              controlled = true;
              controlTimer = 180;
              lives--;
            } else if (obj instanceof Confringo) {
              hitTimer = 10;
              ((Confringo)obj).explode();
            }
          } else {
            hitTimer = 10;
            lives--;
          }
        }
      } else if (obj instanceof Player) {
        if (dist(loc.x, loc.y, loc.z, obj.loc.x, obj.loc.y, obj.loc.z) < 150) {
          hitTimer = 10;
          player.lives--;
        }
      }
    }
  }


  void move() {
    moveTimer--;
    if (moveTimer <= 0) {
      moveDir = PVector.random2D();
      moveDir.setMag(1);
      moveTimer = int(random(60, 120));
    }

    float moveDist = 10;
    float dx = moveDir.x * moveDist;
    float dz = moveDir.y * moveDist;

    float newX = loc.x + dx;
    float newZ = loc.z + dz;

    float localX = newX - mapOffset.x - 150;
    float localZ = newZ - mapOffset.z - 150;

    int mapx = int(localX / gridSize + outsideMap.width / 2.0);
    int mapy = int(localZ / gridSize + outsideMap.height / 2.0);

    if (mapx < 0 || mapx >= outsideMap.width || mapy < 0 || mapy >= outsideMap.height) return;

    color tile = outsideMap.get(mapx, mapy);
    if (tile == brown) {
      loc.x = newX;
      loc.z = newZ;
    }
  }

  void followCrosshair() {
    PVector dir = PVector.sub(player.focus, player.eye).normalize();
    PVector target = PVector.add(player.eye, PVector.mult(dir, 300));

    loc.x = lerp(loc.x, target.x, 0.1);
    loc.y = lerp(loc.y, target.y, 0.1);
    loc.z = lerp(loc.z, target.z, 0.1);
  }

  public float distToPlayer() {
    return dist(this.loc.x, this.loc.y, this.loc.z, player.eye.x, player.eye.y, player.eye.z);
  }
}


void generateEnemies() {

  enemies.clear();

  float[] xPos = {-300, 300};
  float[] yPos = {height - gridSize, height - gridSize};
  float[] zPos = {-3000, -3000}; // the same

  Enemy e1 = new Enemy(xPos[0], yPos[0], zPos[0]); //left
  Enemy e2 = new Enemy(xPos[1], yPos[1], zPos[1]); //right

  enemies.add(e1);
  enemies.add(e2);

  objects.add(e1);
  objects.add(e2);
}
