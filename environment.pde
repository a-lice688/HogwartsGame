void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);

      float wx = (x - map.width / 2.0) * gridSize;
      float wz = (y - map.height / 2.0) * gridSize;

      //PImage texture = null;

      if (c == dullBlue) {
        if ((x + y) % 2 != 0) continue;
        for (int h = 1; h <= 5; h++) {
          texturedCube(wx, height - gridSize * 2 * h, wz, rockWalls, gridSize * 2);
        }
      }

      //if (texture != null) {
      //  for (int h = 1; h <= 5; h++) {
      //    texturedCube(wx, height - gridSize * h, wz, texture, gridSize);
      //}
    }
  }
}


void drawObjects() {

  //bookshelf
  drawModels(-450, height, 200, 72, 72, 72, bookshelfModel, PI, 0, 0); //spellbook, middle
  //drawModels(-750, height, 700, 72, 72, 72, bookshelfModel, PI, HALF_PI - 2.5, 0);
  drawModels(-750, height, -750, 72, 72, 72, bookshelfModel, PI, HALF_PI - 1, 0); //spellbook, right back
  drawModels(680, height, 680, 72, 72, 72, bookshelfModel, PI, HALF_PI + 2.5, 0); //spellbook, left front
  //drawModels(700, height, -750, 72, 72, 72, bookshelfModel, PI, HALF_PI + 1, 0);

  //statues
  //drawModels(150, height, 350, 1, 1, 1, guardianStatue, PI, HALF_PI, 0);
  //drawModels(150, height, -300, 1, 1, 1, guardianStatue, PI, HALF_PI, 0);
  
  //tree
  //drawModels(0, height, 0, 1, 1, 1, sakura, PI, HALF_PI, 0);

  //door
  world.pushMatrix();
  door.disableStyle();
  world.fill(18);
  drawModels(0, height + 10, -950, 0.4, 0.8, 0.4, door, PI, 0, 0);
  world.popMatrix();

  //candles
  //drawModels(700, height - 50, 0, 0.15, 0.15, 0.15, candles, PI, HALF_PI + 1, 0);
  //objects.add(new CollisionChecker(700, height - 50, 0, gridSize));


  //books
  generateBooks();
  objects.addAll(activeBooks);
}

void drawModels(float tx, float ty, float tz, float sx, float sy, float sz, PShape shape, float rotateX, float rotateY, float rotateZ) {
  world.pushMatrix();
  world.translate(tx, ty, tz);
  world.rotateX(rotateX);
  world.rotateY(rotateY);
  world.rotateZ(rotateZ);
  world.scale(sx, sy, sz);
  world.textureMode(NORMAL);
  world.beginShape();
  world.shape(shape);
  world.endShape();
  world.popMatrix();
}

void drawFloor() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      if (map.get(x, y) == white || map.get(x, y) == black) {
        float wx = (x - map.width / 2.0) * gridSize;
        float wz = (y - map.height / 2.0) * gridSize;
        texturedCube(wx, height, wz, floor, gridSize);
      }
    }
  }
}

void drawCeiling() {
  float ceilingY = height - gridSize * 10;

  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      float wx = (x - map.width / 2.0) * gridSize;
      float wz = (y - map.height / 2.0) * gridSize;
      texturedCube(wx, ceilingY, wz, ceiling, gridSize);
    }
  }
}

void drawAxis() {
  world.strokeWeight(5);
  int axisLength = 2000;
  world.stroke(255, 0, 0);
  world.line(-axisLength, 0, 0, axisLength, 0, 0);
  world.stroke(0, 255, 0);
  world.line(0, -axisLength, 0, 0, axisLength, 0);
  world.stroke(0, 0, 255);
  world.line(0, 0, -axisLength, 0, 0, axisLength);
  world.strokeWeight(1);
}

void candleLight(float x, float y, float z) {
  world.pointLight(180, 120, 60, x, y, z);
}
