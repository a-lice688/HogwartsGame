class Gif {
  float x, y, w, h;
  int numOfFrames, speed, currentFrame;
  String before, after;
  PImage[] gif;

  Gif(String _before, String _after, int _numOfFrames, int _speed, float _x, float _y, float _w, float _h) {
    before = _before;
    after = _after;
    numOfFrames = _numOfFrames;
    speed = _speed;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    currentFrame = 0;

    gif = new PImage[numOfFrames];
    for (int i = 0; i < numOfFrames; i++) {
      gif[i] = loadImage(before + (i + 1) + after);
    }
  }

  void show(PGraphics target) {
    if (frameCount % speed == 0) {
      currentFrame = (currentFrame + 1) % numOfFrames;
    }

    target.pushMatrix();
    target.translate(0, 0, 0);
    target.beginShape();
    target.texture(gif[currentFrame]);
    target.vertex(-w/2, -h/2, 0, 0, 0);
    target.vertex( w/2, -h/2, 0, 1, 0);
    target.vertex( w/2, h/2, 0, 1, 1);
    target.vertex(-w/2, h/2, 0, 0, 1);
    target.endShape(CLOSE);
    target.popMatrix();
  }
}

void GifOnWall(Gif g, float x, float y, float z, float angleY) {
  if (frameCount % g.speed == 0) {
    g.currentFrame = (g.currentFrame + 1) % g.numOfFrames;
  }
  world.pushMatrix();
  world.translate(x, y, z);
  world.rotateY(angleY);
  world.beginShape();
  world.texture(g.gif[g.currentFrame]);
  world.vertex(-g.w / 2, -g.h / 2, 0, 0, 0);
  world.vertex( g.w / 2, -g.h / 2, 0, 1, 0);
  world.vertex( g.w / 2, g.h / 2, 0, 1, 1);
  world.vertex(-g.w / 2, g.h / 2, 0, 0, 1);
  world.endShape(CLOSE);
  world.popMatrix();
}
