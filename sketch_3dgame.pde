//June, 2025

import java.util.ArrayList;

Gif Slytherin, Gryffindor, Hufflepuff, Ravenclaw;

static ArrayList<GameObject> objects = new ArrayList<GameObject>();
static ArrayList<SpellBook> activeBooks = new ArrayList<SpellBook>();
static ArrayList<Spell> learnedSpells = new ArrayList<Spell>();
static ArrayList<Spell> spells = new ArrayList<Spell>();

//static boolean[] used;

String[] spellNames = {
  "Avada Kedavra", "Imperio", "Sectumsempra",
  "Confringo", "Glacius", "Reducto"
};

String[] spellEffects = {
  "Instantly destroys target",
  "Control an enemy temporarily",
  "Slice enemy in half",
  "Big explosion",
  "Freeze enemy in place",
  "Break walls or objects"
};


HUD hud = new HUD();

color black = #000000;
color white = #FFFFFF;
color dullBlue = #7092BE;

int gridSize = 48;
PImage map;
PImage grassBlock;
PImage rockWalls;
PImage floor;
PImage ceiling;

boolean wkey, akey, skey, dkey, qkey, ekey, lkey, okey, pkey, ckey, rightkey, leftkey;

boolean key1 = false;
boolean key2 = false;

PGraphics world;
PGraphics HUD;

Player player;

PShape bookshelfModel;
PShape guardianStatue;
PShape door;
PShape book;
PShape candles;
PShape sakura;

void setup() {
  fullScreen(P3D);

  player = new Player();

  objects.add(new Particle(new PVector(0, height - 100, 0)));

  bookshelfModel = loadShape("bookshelf_with_books.obj");
  guardianStatue = loadShape("guardianstatue.obj");
  door = loadShape("anim_door.obj");
  book = loadShape("opened_book.obj");
  candles = loadShape("Candles.obj");
  sakura = loadShape("Prop_Tree.obj");

  spells.add(new AvadaKedavra()); // 0
  spells.add(new Imperio()); // 1
  spells.add(new Sectumsempra()); // 2
  spells.add(new Confringo()); // 3
  spells.add(new Glacius()); // 4
  spells.add(new Reducto()); // 5

  world = createGraphics(displayWidth, displayHeight, P3D);
  HUD = createGraphics(displayWidth, displayHeight, P2D);

  //Slytherin = new Gif("zSlytherin-", ".tiff", 12, 10, 0, 0, 180, 270);
  //Gryffindor = new Gif("zGryffindor-", ".tiff", 12, 10, 0, 0, 180, 270);
  //Hufflepuff = new Gif("zHufflepuff-", ".tiff", 13, 10, 0, 0, 180, 270);
  //Ravenclaw = new Gif("zRavenclaw-", ".tiff", 13, 10, 0, 0, 180, 270);

  rockWalls = loadImage("StoneWall.png");
  floor = loadImage("floor.png");
  ceiling = loadImage("ceiling.png");

  map = loadImage("map.png");

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

  player = new Player();

  player.eye.set(wx, height - gridSize * 1.5, wz);
  player.focus.set(wx, height - gridSize * 1.5, wz + 100);

  world.textureMode(NORMAL);
  world.noStroke();

  wkey = akey = skey = dkey = qkey = ekey = false;

  generateBooks();

  noCursor();
}

void draw() {

  player.update();
  player.act();

  world.beginDraw();

  world.textureMode(NORMAL);
  world.background(0);

  world.pointLight(60, 60, 60, player.eye.x, player.eye.y, player.eye.z);
  candleLight(710, height - 50, 0);
  candleLight(650, height - 50, 0);
  candleLight(710, height - 310, 0);

  player.applyCamera();
  

  drawAxis();
  drawFloor();
  drawCeiling();
  drawMap();

  drawObjects();

  for (int i = 0; i < objects.size(); i++) {
    GameObject obj = objects.get(i);
    obj.show();
    obj.act();
    if (obj.lives == 0) {
      objects.remove(i--);
    }
  }

  //GifOnWall(Slytherin, 0, height - 200, 910, -PI);
  //GifOnWall(Gryffindor, -850, height - 200, 0, HALF_PI);
  //GifOnWall(Hufflepuff, 890, height - 200, 0, -HALF_PI);
  //GifOnWall(Ravenclaw, -300, height - 200, -862, PI);

  world.endDraw();

  image(world, 0, 0);

  HUD.beginDraw();
  HUD.clear();
  hud.draw(HUD);
  HUD.endDraw();

  image(HUD, 0, 0);

  float maxAngle = PI / 2.5;
  float weight = map(abs(player.upDownHeadAngle), 0, maxAngle, 6, 2);
  stroke(255);
  strokeWeight(weight);
  line(width / 2 - 15, height / 2, width / 2 + 15, height / 2);
  line(width / 2, height / 2 - 15, width / 2, height / 2 + 15);

  key1 = false;
  key2 = false;
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

  void draw(PGraphics pg) {
    pg.fill(255);
    pg.textAlign(CENTER);
    pg.textSize(20);
    pg.text(line1, width / 2, height - 120);
    pg.text(line2, width / 2, height - 90);
    pg.text(line3, width / 2, height - 50);
  }
}
