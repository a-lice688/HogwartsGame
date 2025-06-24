//June, 2025

import java.util.ArrayList;

static ArrayList<GameObject> objects = new ArrayList<GameObject>();

static ArrayList<SpellBook> activeBooks = new ArrayList<SpellBook>();
static ArrayList<Spell> learnedSpells = new ArrayList<Spell>();
static ArrayList<ActiveSpell> activeSpells = new ArrayList<ActiveSpell>();
static ArrayList<Enemy> enemies = new ArrayList<Enemy>();

static Spell[] spells;

//maps
PImage map;
PImage insideMap;
PImage outsideMap;
boolean outside = false;
int gridSize = 48;
PVector mapOffset = new PVector(0, 0, 0);

//colours
color black = #000000;
color white = #FFFFFF; //inside floor
color dullBlue = #7092BE;
color green = #008000; //outside ground
color grey = #a9a9a9; //outside ground
color brown = #8b4513; //marble

//textures
PImage rockWalls;
PImage floor;
PImage ceiling;
PImage grass;
PImage marble;

//gifs
Gif Slytherin, Gryffindor, Hufflepuff, Ravenclaw;

//models
PShape bookshelfModel;
PShape guardianStatue;
PShape door;
PShape book;
PShape candles;
PShape deadtree;
PShape fence;
PShape clouds;

//keys
boolean wkey, akey, skey, dkey, qkey, ekey, lkey, okey, pkey, ckey, rightkey, leftkey, spacekey;
boolean key1 = false;
boolean key2 = false;
boolean key3 = false;


//worlds
PGraphics world;
PGraphics HUD;
HUD hud = new HUD();

//player
Player player;
PVector insideSpawn, outsideSpawn;
boolean challengeAccepted = false;


void setup() {

  //maps
  fullScreen(P3D);
  world = createGraphics(displayWidth, displayHeight, P3D);
  HUD = createGraphics(displayWidth, displayHeight, P2D);
  insideMap = loadImage("map.png");
  outsideMap = loadImage("outsideMap.png");
  mapOffset = new PVector(0, 0, -920 - (outsideMap.height / 2.0 * gridSize));

  world.textureMode(NORMAL);
  world.noStroke();
  noCursor();

  map = insideMap;

  spells = new Spell[] {
    new Spell_AvadaKedavra(),
    new Spell_Imperio(),
    new Spell_Sectumsempra(),
    new Spell_Confringo(),
    new Spell_Glacius(),
    new Spell_Reducto()
  };


  //spawn player
  int spawnX = 0;
  int spawnY = 0;
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      if (map.get(x, y) == white) {
        spawnX = x;
        spawnY = y;
        break;
      }
    }
  }

  float wx = (spawnX - map.width / 2.0) * gridSize;
  float wz = (spawnY - map.height / 2.0) * gridSize;

  //player
  player = new Player();
  player.eye.set(wx, height - gridSize * 1.5, wz);
  player.focus.set(wx, height - gridSize * 1.5, wz + 100);
  insideSpawn = player.eye.copy();

  //textures
  rockWalls = loadImage("StoneWall.png");
  floor = loadImage("floor.png");
  ceiling = loadImage("ceiling.png");
  grass = loadImage("grass.jpg");
  marble = loadImage("marble.jpg");

  //models
  bookshelfModel = loadShape("bookshelf_with_books.obj");
  guardianStatue = loadShape("guardianstatue.obj");
  door = loadShape("anim_door.obj");
  book = loadShape("opened_book.obj");
  candles = loadShape("Candles.obj");
  deadtree = loadShape("deadtree.obj");
  fence = loadShape("fence.obj");
  clouds = loadShape("clouds.obj");


  if (!outside) generateBooks();

  generateEnemies();

  //gifs
  //Slytherin = new Gif("zSlytherin-", ".tiff", 12, 10, 0, 0, 180, 270);
  //Gryffindor = new Gif("zGryffindor-", ".tiff", 12, 10, 0, 0, 180, 270);
  //Hufflepuff = new Gif("zHufflepuff-", ".tiff", 13, 10, 0, 0, 180, 270);
  //Ravenclaw = new Gif("zRavenclaw-", ".tiff", 13, 10, 0, 0, 180, 270);

  wkey = akey = skey = dkey = qkey = ekey = false;
}

void draw() {

  for (GameObject obj : objects) {
    if (obj instanceof Enemy) {
      Enemy e = (Enemy) obj;
      e.wasHit = false;
      e.wasFrozen = false;
    }
  }
  player.update();
  player.act();
  player.applyCamera(50);

  //snowflakes
  if (outside) {
    if (frameCount % 2 == 0) {
      int snowArea = gridSize * outsideMap.width;
      PVector snowStart = new PVector(
        random(-snowArea / 2, snowArea / 2) + mapOffset.x,
        -500, // high in the sky
        random(-snowArea / 2, snowArea / 2) + mapOffset.z
        );
      objects.add(new Snowflake(snowStart));
    }
  }


  //crosshair
  float maxAngle = PI / 2.5;
  float weight = map(abs(player.upDownHeadAngle), 0, maxAngle, 6, 2);
  stroke(255);
  strokeWeight(weight);
  line(width / 2 - 15, height / 2, width / 2 + 15, height / 2);
  line(width / 2, height / 2 - 15, width / 2, height / 2 + 15);

  //world
  world.beginDraw();
  world.textureMode(NORMAL);
  world.background(3, 8, 20);

  if (!outside) {
    world.pointLight(60, 60, 60, player.eye.x, player.eye.y, player.eye.z);
    candleLight(710, height - 50, 0);
    candleLight(650, height - 50, 0);
    candleLight(710, height - 310, 0);
  } else {
    world.pointLight(160, 160, 160, player.eye.x, player.eye.y, player.eye.z);
  }

  //world book removal
  for (int i = activeBooks.size() - 1; i >= 0; i--) {
    if (activeBooks.get(i).lives == 0) {
      activeBooks.remove(i);
    }
  }

  //world object removal
  for (int i = 0; i < objects.size(); i++) {
    GameObject obj = objects.get(i);
    obj.show();
    obj.act();

    if (obj.lives == 0) {
      objects.remove(i--);
    }
  }

  //world.draw

  if (!outside) drawCeiling();
  //drawAxis();
  drawFloor();
  drawMap();
  drawObjects();

  ////world.gifs
  //GifOnWall(Slytherin, 0, height - 200, 910, -PI);
  //GifOnWall(Gryffindor, -850, height - 200, 0, HALF_PI);
  //GifOnWall(Hufflepuff, 890, height - 200, 0, -HALF_PI);
  //GifOnWall(Ravenclaw, -300, height - 200, -862, PI);

  world.endDraw();
  image(world, 0, 0);

  //HUD
  HUD.beginDraw();
  HUD.clear();
  hud.draw(HUD);

  //if (learnedMessageTimer > 0) {
  //  learnedMessageTimer--;
  //} else {
  //  hud.clear();
  //}

  boolean flashRed = false;
  boolean flashBlue = false;

  for (GameObject obj : objects) {
    if (obj instanceof Enemy) {
      Enemy e = (Enemy) obj;
      if (e.wasHit) flashRed = true;
      if (e.wasFrozen) flashBlue = true;
    }
  }

  if (flashRed) {
    HUD.fill(255, 0, 0, 100);
    HUD.noStroke();
    HUD.rect(0, 0, width, height);
  }
  if (flashBlue) {
    HUD.fill(100, 200, 255, 100);
    HUD.noStroke();
    HUD.rect(0, 0, width, height);
  }

  HUD.endDraw();
  image(HUD, 0, 0);

  key1 = false;
  key2 = false;
  key3 = false;
}

class HUD {
  String line1 = "";
  String line2 = "";
  String line3 = "";

  void set(String l1, String l2, String l3) {
    line1 = l1;
    line2 = l2;
    line3 = l3;
  }

  void clear() {
    line1 = "";
    line2 = "";
    line3 = "";
  }

  void draw(PGraphics graphics) {
    graphics.fill(255);
    graphics.textAlign(CENTER);
    graphics.textSize(20);
    graphics.text(line1, width / 2, height - 120);
    graphics.text(line2, width / 2, height - 90);
    graphics.text(line3, width / 2, height - 50);

    if (challengeAccepted) {
      graphics.textAlign(LEFT);
      graphics.textSize(18);
      graphics.fill(200);
      graphics.text("Spells:", 20, 40);
      for (int i = 0; i < learnedSpells.size() && i < 3; i++) {
        Spell s = learnedSpells.get(i);
        graphics.text((i+1) + ": " + s.getName(), 20, 70 + i * 30);
      }

      //player hp bar
      graphics.fill(255);
      graphics.text("Player HP", 20, height - 180);
      graphics.fill(255, 0, 0);
      graphics.rect(20, height - 160, map(player.hp, 0, 100, 0, 200), 20);
      graphics.noFill();
      graphics.stroke(255);
      graphics.rect(20, height - 160, 200, 20);

      //enemy hp bar
      for (Enemy e : enemies) {
        
          graphics.fill(255);
          graphics.text("Enemy HP", width - 220, height - 180);
          graphics.fill(0, 100, 255);
          graphics.rect(width - 220, height - 160, map(e.hp, 0, 100, 0, 200), 20);
          graphics.noFill();
          graphics.stroke(255);
          graphics.rect(width - 220, height - 160, 200, 20);
        
      }
    }
  }
}
