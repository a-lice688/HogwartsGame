void keyPressed() {
  if (key == 'E' || key == 'e') wkey = true;
  if (key == 'S' || key == 's') akey = true;
  if (key == 'F' || key == 'f') dkey = true;
  if (key == 'D' || key == 'd') skey = true;

  if (key == 'W' || key == 'w') qkey = true;
  if (key == 'R' || key == 'r') ekey = true;

  if (key == 'O' || key == 'o') okey = true;
  if (key == 'L' || key == 'l') lkey = true;
  if (key == 'P' || key == 'p') pkey = true;
  if (key == 'C' || key == 'c') ckey = true;

  if (keyCode == RIGHT) rightkey = true;
  if (keyCode == LEFT) leftkey = true;
  if (key == ' ') spacekey = true;

  if (key == '1') key1 = true;
  if (key == '2') key2 = true;
  if (key == '3') key3 = true;
}



void keyReleased() {
  if (key == 'E' || key == 'e') wkey = false;
  if (key == 'S' || key == 's') akey = false;
  if (key == 'F' || key == 'f') dkey = false;
  if (key == 'D' || key == 'd') skey = false;

  if (key == 'W' || key == 'w') qkey = false;
  if (key == 'R' || key == 'r') ekey = false;

  if (key == 'P' || key == 'p') pkey = false;
  if (key == 'L' || key == 'l') lkey = false;
  
  if (key == ' ') spacekey = false;

  //if (key == 'C' || key == 'c') ckey = false;
  //if (keyCode == RIGHT) rightkey = false;
  //if (keyCode == LEFT) leftkey = false;
}

void mousePressed() {
}
