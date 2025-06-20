class Player {
  PVector eye;
  PVector focus;
  PVector up;
  float leftRightHeadAngle, upDownHeadAngle;
  float moveSpeed;

  float distToBook;
  ArrayList<SpellBook> removedBooks = new ArrayList<SpellBook>();


  Player() {
    up = new PVector(0, 1, 0);

    eye = new PVector(width / 2, height, 0);
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
  }

  void move() {

    float turnSpeed = 0.02; //replaces the robot class (still can turn even if mouse hits limit

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

    leftRightHeadAngle += (mouseX - pmouseX)*0.01;
    upDownHeadAngle += (mouseY - pmouseY)*0.01;

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

      int mapx = int(fwdx / gridSize + map.width / 2.0);
      int mapy = int(fwdz / gridSize + map.height / 2.0);

      if (mapx < 0 || mapx >= map.width || mapy < 0 || mapy >= map.height) {
        return false;
      }

      if (map.get(mapx, mapy) != white) {
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

    removedBooks.clear();

    for (SpellBook currBook : activeBooks) {

      float distance = currBook.distToPlayer();

      println(distance);

      if (distance <= 300) {
        if (!currBook.getOpened() && !currBook.getLearned()) {
          hud.set("", "", "Press 'O' to open the book");
        }

        if (okey) {
          currBook.setOpened(true);
        }

        if (currBook.getOpened() && !currBook.getLearned()) {

          if (key == '1') {
            currBook.setSelected(0);
          }

          if (key == '2') {
            currBook.setSelected(1);
          }

          String name;
          String effect;
          String prompt;
          int selected = currBook.getSelected();

          if (selected == 0) {
            name = currBook.getName1();
            effect = currBook.getEffect1();
          } else {
            name = currBook.getName2();
            effect = currBook.getEffect2();
          }

          if (selected == 0) {
            prompt = "Press L to learn, 2 to view the other spell";
          } else {
            prompt = "Press L to learn, 1 to view the other spell";
          }

          hud.set(name, effect, prompt);


          if (lkey) {
            for (int j = 0; j < spellNames.length; j++) {
              if (spellNames[j].equals(name)) {
                learnedSpells.add(spells.get(j));
                break;
              }
            }

            currBook.setLearned(true);
            currBook.setOpened(false);
            removedBooks.add(currBook);
          }
        }
      }
    }

    println("Learned Spells:");
    for (Spell s : learnedSpells) {
      println(s.getClass().getSimpleName());
    }

    for (SpellBook b : removedBooks) {
      activeBooks.remove(b);
      objects.remove(b);
    }
  }

  void applyCamera() {
    world.camera(eye.x, eye.y - 25, eye.z, focus.x, focus.y - 25, focus.z, up.x, up.y, up.z);
  }
}
