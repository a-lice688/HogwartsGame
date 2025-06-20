class SpellBook extends GameObject {
  String spellName1, spellEffect1;
  String spellName2, spellEffect2;

  boolean opened = false;
  boolean learned = false;
  // boolean cancelled = false;

  int selected = 0;

  SpellBook(float x, float y, float z, int index) {
    super(x, y, z, 80);
    spellName1 = spellNames[index];
    spellEffect1 = spellEffects[index];
    spellName2 = spellNames[index + 1];
    spellEffect2 = spellEffects[index + 1];
  }

  void act() {
  }
  //      if (ckey) {
  //        opened = false;
  //        showPrompt = false;
  //        HUDLine1 = "";
  //        HUDLine2 = "";
  //        HUDLine3 = "";
  //      }

  void show() {
    drawModels(loc.x, loc.y, loc.z, 1.3, 1.3, 1.3, book, PI, HALF_PI, 0);

    // if (cancelled && distance > 250) {
    //   cancelled = false;
    //   return;
    // }

    // if (distance < 250 && !cancelled) {
  }

  public float distToPlayer() {
    return dist(this.loc.x, this.loc.y, this.loc.z, player.eye.x, player.eye.y, player.eye.z);
  }

  public String getName1() {
    return spellName1;
  }
  public String getEffect1() {
    return spellEffect1;
  }

  public String getName2() {
    return spellName2;
  }

  public String getEffect2() {
    return spellEffect2;
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

  public void setOpened(boolean o) {
    this.opened = o;
  }

  public void setLearned(boolean l) {
    this.learned = l;
  }

  public void setSelected(int s) {
    this.selected = s;
  
}
}


void generateBooks() {
  activeBooks.clear();

  float[] xPos = { -450, 685, -760 };
  float[] yPos = { height - 48, height - 50, height - 115 };
  float[] zPos = { 212, 670, -755 };

  SpellBook b1 = new SpellBook(xPos[0], yPos[0], zPos[0], 0); // Sectumsempra + Confringo
  SpellBook b2 = new SpellBook(xPos[1], yPos[1], zPos[1], 2); // Avada Kedavra + Imperio
  SpellBook b3 = new SpellBook(xPos[2], yPos[2], zPos[2], 4); // Glacius + Reducto

  activeBooks.add(b1);
  activeBooks.add(b2);
  activeBooks.add(b3);

  objects.add(b1);
  objects.add(b2);
  objects.add(b3);
}
