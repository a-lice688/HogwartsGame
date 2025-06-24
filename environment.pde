void drawMap() {

  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);

      float wx = (x - map.width / 2.0) * gridSize;
      float wz = (y - map.height / 2.0) * gridSize;

      if (c == dullBlue) {
        if ((x + y) % 2 != 0) continue;
        for (int h = 1; h <= 5; h++) {
          texturedCube(wx, height - gridSize * 2 * h, wz, rockWalls, gridSize * 2);
        }
      }

      if (outside) {
        wx = (x - map.width / 2.0) * gridSize + mapOffset.x;
        wz = (y - map.height / 2.0) * gridSize + mapOffset.z + 100;

        if (c == green || c == grey) {
          texturedCube(wx, height, wz + 100, grass, gridSize);
        } else if (c == brown) {
          texturedCube(wx, height - 30, wz + 100, marble, gridSize);
        }
      }
    }
  }
}


void drawObjects() {

  if (!outside) {

    //bookshelf
    drawModels(-450, height, 200, 72, 72, 72, bookshelfModel, PI, 0, 0); //spellbook, middle
    //drawModels(-750, height, 700, 72, 72, 72, bookshelfModel, PI, HALF_PI - 2.5, 0);
    drawModels(-750, height, -750, 72, 72, 72, bookshelfModel, PI, HALF_PI - 1, 0); //spellbook, right back
    drawModels(680, height, 680, 72, 72, 72, bookshelfModel, PI, HALF_PI + 2.5, 0); //spellbook, left front
    //drawModels(700, height, -750, 72, 72, 72, bookshelfModel, PI, HALF_PI + 1, 0);

    ////statues
    //drawModels(150, height, 350, 1, 1, 1, guardianStatue, PI, HALF_PI, 0);
    //drawModels(150, height, -300, 1, 1, 1, guardianStatue, PI, HALF_PI, 0);

    //  //candles
    //  drawModels(700, height - 50, 0, 0.15, 0.15, 0.15, candles, PI, HALF_PI + 1, 0);
    //  objects.add(new CollisionChecker(700, height - 50, 0, gridSize));
  } else {
    //front
    drawModels(1250, height, -820, 5, 3, 8, fence, PI, PI, 0);
    drawModels(-1250, height, -820, 5, 3, 8, fence, PI, PI, 0);

    //right
    drawModels(-2300, height, -2000, 5, 3, 8, fence, PI, -HALF_PI, 0);
    drawModels(-2300, height, -4250, 5, 3, 8, fence, PI, -HALF_PI, 0);

    //left
    drawModels(2300, height, -2000, 5.5, 3, 1, fence, PI, HALF_PI, 0);
    drawModels(2300, height, -4250, 5.5, 3, 1, fence, PI, HALF_PI, 0);

    //back
    drawModels(1250, height, -5520, 5.5, 3, 1, fence, PI, 0, 0);
    drawModels(-1250, height, -5520, 5.5, 3, 1, fence, PI, 0, 0);


    //tree
    drawModels(800, height, -2100, 5, 5, 5, deadtree, PI, 0, 0); //front left
    objects.add(new CollisionChecker(800, height - 50, -2100, gridSize * 2));

    drawModels(-1150, height, -2700, 5, 5, 5, deadtree, PI, 0, 0); //front right
    objects.add(new CollisionChecker(-1150, height - 50, -2700, gridSize * 2));

    drawModels(1150, height, -3900, 5, 5, 5, deadtree, PI, PI, 0); //back left
    objects.add(new CollisionChecker(1150, height - 50, -3900, gridSize * 2));

    drawModels(-800, height, -4400, 5, 5, 5, deadtree, PI, -HALF_PI, 0); //back right
    objects.add(new CollisionChecker(-800, height - 50, -4400, gridSize * 2));

    //clouds
    drawModels(600, height - 3000, -1500, 5, 5, 5, clouds, 0, PI, 0); 
    //drawModels(-800, height - 3000, -4500, 5, 5, 5, clouds, 0, -HALF_PI, 0); 
  }

  //door
  world.pushMatrix();
  door.disableStyle();
  world.fill(18);
  drawModels(0, height + 10, -920, 0.4, 0.8, 0.4, door, PI, 0, 0);
  world.popMatrix();
}

void generateCollisionCheckers() {
  for (int i = 1000; i >= -5450; i -= 250) {
    objects.add(new CollisionChecker(2300, height - 50, i, gridSize * 5));
  }

  for (int i = -2500; i <= 2500; i += 250) {
    objects.add(new CollisionChecker(i, height - 50, -5600, gridSize * 5));
  }

  // trees
  objects.add(new CollisionChecker(800, height - 50, -2100, gridSize * 2));
  objects.add(new CollisionChecker(-1150, height - 50, -2700, gridSize * 2));
  objects.add(new CollisionChecker(1150, height - 50, -3900, gridSize * 2));
  objects.add(new CollisionChecker(-800, height - 50, -4400, gridSize * 2));
}

void drawModels(float tx, float ty, float tz, float sx, float sy, float sz, PShape shape, float rotateX, float rotateY, float rotateZ) {
  world.pushMatrix();
  world.translate(tx, ty, tz);
  world.rotateX(rotateX);
  world.rotateY(rotateY);
  world.rotateZ(rotateZ);
  world.scale(sx, sy, sz);
  world.textureMode(NORMAL);
  world.shape(shape);
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

//void drawAxis() {
//  world.strokeWeight(5);
//  int axisLength = 2000;
//  world.stroke(255, 0, 0);
//  world.line(-axisLength, 0, 0, axisLength, 0, 0);
//  world.stroke(0, 255, 0);
//  world.line(0, -axisLength, 0, 0, axisLength, 0);
//  world.stroke(0, 0, 255);
//  world.line(0, 0, -axisLength, 0, 0, axisLength);
//  world.strokeWeight(1);
//}

void candleLight(float x, float y, float z) {
  world.pointLight(180, 120, 60, x, y, z);
}
