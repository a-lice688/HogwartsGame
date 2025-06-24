class Player extends GameObject {
  PVector eye;
  PVector focus;
  PVector up;
  float leftRightHeadAngle, upDownHeadAngle;
  float moveSpeed;
  boolean isJumping = false;
  float verticalVelocity = 0;
  float gravityStrength = 1;
  float jumpStrength = -15;

  float baseHeight;
  float headWobbleTimer = 0;

  ArrayList<ActiveSpell> activeSpells = new ArrayList<ActiveSpell>();

  float distToBook;
  
  int hp = 100;

  String learnedName;

  Player() {
    up = new PVector(0, 1, 0);

    baseHeight = height - gridSize * 1.5;

    eye = new PVector(width / 2, baseHeight, 0);
    focus = new PVector(width / 2, height, 10);

    leftRightHeadAngle = radians(270);
    upDownHeadAngle = 0;
    moveSpeed = 10;
  }

  void update() {
    move();
    updateLook();
  }

  void act() {
    handleSpellBook();
    handleGuards();
    checkMapTransition();
  }
  void move() {

    float turnSpeed = 0.02; //replaces the robot class (still can turn even if mouse hits limit
    headWobbleTimer += 0.2;

    if (qkey) {
      leftRightHeadAngle -= turnSpeed;
    }
    if (ekey) {
      leftRightHeadAngle += turnSpeed;
    }

    if (wkey && canMove(0)) {
      eye.x += cos(leftRightHeadAngle) * moveSpeed;
      eye.z += sin(leftRightHeadAngle) * moveSpeed;
    }
    if (skey && canMove(PI)) {
      eye.x -= cos(leftRightHeadAngle) * moveSpeed;
      eye.z -= sin(leftRightHeadAngle) * moveSpeed;
    }
    if (akey && canMove(-HALF_PI)) {
      eye.x += cos(leftRightHeadAngle - HALF_PI) * moveSpeed;
      eye.z += sin(leftRightHeadAngle - HALF_PI) * moveSpeed;
    }
    if (dkey && canMove(HALF_PI)) {
      eye.x += cos(leftRightHeadAngle + HALF_PI) * moveSpeed;
      eye.z += sin(leftRightHeadAngle + HALF_PI) * moveSpeed;
    }

    //jump
    if (spacekey && !isJumping) {
      verticalVelocity = jumpStrength;
      isJumping = true;
    }

    eye.y += verticalVelocity;
    verticalVelocity += gravityStrength;

    if (eye.y >= baseHeight) {
      eye.y = baseHeight;
      verticalVelocity = 0;
      isJumping = false;
    }

    leftRightHeadAngle += (mouseX - pmouseX)* 0.01;
    upDownHeadAngle += (mouseY - pmouseY)* 0.01;

    if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5; //max
    if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5; //max
  }


  void updateLook() {
    focus.x = eye.x + cos(leftRightHeadAngle) * 300;
    focus.z = eye.z + sin(leftRightHeadAngle) * 300;
    focus.y = eye.y + tan(upDownHeadAngle) * 300;
  }

  boolean canMove(float angle) {
    float radius = 50;
    float checkDistance = 150;

    for (int i = -1; i <= 1; i++) {
      float sideAngle = leftRightHeadAngle + angle + HALF_PI;
      float sidex = cos(sideAngle) * radius * i;
      float sidez = sin(sideAngle) * radius * i;

      float fwdx = eye.x + cos(leftRightHeadAngle + angle) * checkDistance + sidex;
      float fwdz = eye.z + sin(leftRightHeadAngle + angle) * checkDistance + sidez;

      float localX = fwdx;
      float localZ = fwdz;

      if (outside) {
        localX -= mapOffset.x + 150;
        localZ -= mapOffset.z + 150;
      }

      int mapx = int(localX / gridSize + map.width / 2.0);
      int mapy = int(localZ / gridSize + map.height / 2.0);

      if (mapx < 0 || mapx >= map.width || mapy < 0 || mapy >= map.height) {
        return false;
      }

      color colour = map.get(mapx, mapy);
      if (colour == black && colour != dullBlue) {
        return false;
      }

      //requires jump to get on
      if (colour == brown && !isJumping && !onMarble()) {
        return false;
      }

      for (GameObject obj : objects) {
        float distSq = sq(fwdx - obj.loc.x) + sq(eye.y - obj.loc.y) + sq(fwdz - obj.loc.z);
        float combined = obj.size / 2.0 + 30; // buffer for safety
        if (distSq < sq(combined)) {
          return false;
        }
      }
    }

    return true;
  }

  void handleSpellBook() {

    if (outside) return;
    boolean inRange = false;

    for (int i = activeBooks.size() - 1; i >= 0; i--) {
      SpellBook currBook = activeBooks.get(i);

      float distance = currBook.distToPlayer();

      if (distance <= 250 && !currBook.getLearned()) {
        inRange = true;

        if (!currBook.getOpened()) {
          hud.set("", "", "Press 'O' to open the books");

          if (okey) {
            currBook.setOpened(true);
          }
        }

        if (currBook.getOpened()) {
          String name1 = currBook.getName1();
          String effect1 = currBook.getEffect1();
          String name2 = currBook.getName2();
          String effect2 = currBook.getEffect2();

          hud.set("1: " + name1 + " - " + effect1,
            "2: " + name2 + " - " + effect2,
            "Press 1 or 2 to learn the spell of your choice");

          if (key1 || key2) {
            int selected;
            if (key1) {
              selected = 0;
            } else {
              selected = 1;
            }
            currBook.setSelected(selected);

            String name;
            if (selected == 0) {
              name = name1;
            } else {
              name = name2;
            }

            for (Spell s : spells) {
              if (s.getName().equals(name)) {
                learnedSpells.add(s);
                learnedName = name;
                currBook.setOpened(false);
                break;
              }
            }
            currBook.setLives(0);

            return;
          }
        }

        break;
      }
    }

    if (!inRange) {
      hud.clear();
    }
  }

  void handleGuards() {
    if (!outside) return;

    boolean inRange = false;

    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy currEnemy = enemies.get(i);
      float distance = currEnemy.distToPlayer();

      if (distance <= 300 && !challengeAccepted) {
        inRange = true;
      }
    }

    if (!challengeAccepted && inRange) {
      hud.set("Are you ready for the challenge?", "Press 1 to accept", "Or leave like a coward!");
      if (key1) {
        challengeAccepted = true;
        hud.clear();
      }
    } else if (!inRange || challengeAccepted) {
      hud.clear();
    }

    if (challengeAccepted) {
      if (key1) {
        castSpell(0);
        key1 = false;
      }
      if (key2) {
        castSpell(1);
        key2 = false;
      }
      if (key3) {
        castSpell(2);
        key3 = false;
      }
    }
  }

  void checkMapTransition() {
    PVector doorLoc = new PVector(0, height, -920);
    float distToDoor = dist(player.eye.x, player.eye.y, player.eye.z, doorLoc.x, doorLoc.y, doorLoc.z);
    boolean showPrompt = false;


    if (!outside) { //inside -> outside
      if (distToDoor < 100) { //go outside
        hud.clear();
        map = outsideMap;
        outside = true;

        insideSpawn = player.eye.copy();

        float offset = 201;
        player.eye.x += cos(leftRightHeadAngle) * offset;
        player.eye.z += sin(leftRightHeadAngle) * offset;

        player.updateLook();
      } else if (distToDoor < 200) { //display "go outside"
        if (!showPrompt) {
          hud.set("", "", "Proceed to move outside…");
          showPrompt = true;
        }
      } else if (distToDoor > 200) { //do not display
        if (hud.line3.equals("Proceed to move outside…")) {
          hud.clear();
        }
        showPrompt = false;
      }
    } else { //outside -> inside
      if (player.eye.z > doorLoc.z && distToDoor < 100) { //go inside
        hud.clear();
        map = insideMap;
        outside = false;

        outsideSpawn = player.eye.copy();
        player.eye.set(outsideSpawn.x, outsideSpawn.y, outsideSpawn.z + 100);
      } else if (distToDoor < 200) { //display "go inside"
        if (!showPrompt) {
          hud.set("", "", "Proceed to move inside…");
          showPrompt = true;
        }
      } else if (distToDoor > 200 ) { //do not display
        if (hud.line3.equals("Proceed to move inside…")) {
          hud.clear();
        }
        showPrompt = false;
      }
    }
  }

  boolean onMarble() {
    float localX = eye.x;
    float localZ = eye.z;

    if (outside) {
      localX -= mapOffset.x + 150;
      localZ -= mapOffset.z + 150;
    }

    int mapx = int(localX / gridSize + map.width / 2.0);
    int mapy = int(localZ / gridSize + map.height / 2.0);

    if (mapx < 0 || mapx >= map.width || mapy < 0 || mapy >= map.height) return false;

    return map.get(mapx, mapy) == brown;
  }

  void applyCamera(int yOffset) {
    float wobbleSpeed = 0.2;
    float wobbleY = sin(headWobbleTimer * wobbleSpeed) * 1.5;
    float wobbleX = cos(headWobbleTimer * wobbleSpeed) * 3;
    world.camera(eye.x + wobbleX, eye.y - yOffset + wobbleY, eye.z, focus.x + wobbleX, focus.y - yOffset + wobbleY, focus.z, up.x, up.y, up.z);
  }

  PVector getLookDirection() {
    return new PVector(
      cos(leftRightHeadAngle),
      tan(upDownHeadAngle),
      sin(leftRightHeadAngle)
      ).normalize();
  }

  void castSpell(int index) {
    if (index < learnedSpells.size()) {
      Spell spell = learnedSpells.get(index);
      ActiveSpell instance = spell.createInstance();
      if (instance != null) {
        activeSpells.add(instance);
        objects.add(instance);
      }
    }
  }
}
