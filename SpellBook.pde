class SpellBook extends GameObject {

  boolean opened = false;
  boolean learned = false;

  int selected = 0;

  Spell spell1, spell2;

  SpellBook(float x, float y, float z, Spell spell1, Spell spell2, int lives) {
    super(x, y, z, 80, lives);
    this.spell1 = spell1;
    this.spell2 = spell2;
  }

  void act() {
  }

  void show() {
    if (outside) return;
    drawModels(loc.x, loc.y, loc.z, 1.3, 1.3, 1.3, book, PI, HALF_PI, 0);
  }

  public float distToPlayer() {
    return dist(this.loc.x, this.loc.y, this.loc.z, player.eye.x, player.eye.y, player.eye.z);
  }

  public String getName1() {
    return spell1.getName();
  }

  public String getEffect1() {
    return spell1.getEffect();
  }

  public String getName2() {
    return spell2.getName();
  }

  public String getEffect2() {
    return spell2.getEffect();
  }

  public boolean getOpened() {
    return opened;
  }

  public boolean getLearned() {
    return learned;
  }

  public int getSelected() {
    return selected;
  }

  public int getLives() {
    return lives;
  }

  public void setOpened(boolean o) {
    this.opened = o;
  }

  public void setLearned(boolean l) {
    this.learned = l;
  }

  public void setSelected(int s) {
    this.selected = s;
  }

  public void setLives(int l) {
    this.lives = l;
  }
}


void generateBooks() {
  activeBooks.clear();

  float[] xPos = { -450, 685, -760 };
  float[] yPos = { height - 48, height - 50, height - 115 };
  float[] zPos = { 212, 670, -755 };

  SpellBook b1 = new SpellBook(xPos[0], yPos[0], zPos[0], new Spell_Sectumsempra(), new Spell_Confringo(), 1);
  SpellBook b2 = new SpellBook(xPos[1], yPos[1], zPos[1], new Spell_AvadaKedavra(), new Spell_Imperio(), 1);
  SpellBook b3 = new SpellBook(xPos[2], yPos[2], zPos[2], new Spell_Glacius(), new Spell_Reducto(), 1);

  activeBooks.add(b1);
  activeBooks.add(b2);
  activeBooks.add(b3);

  objects.add(b1);
  objects.add(b2);
  objects.add(b3);
}
