static class Spell {
  String name;
  String effect;


  Spell(String name, String effect) {
    this.name = name;
    this.effect = effect;
  }

  String getName() {
    return name;
  }

  String getEffect() {
    return effect;
  }

  ActiveSpell createInstance() {
    return null;
  }
}
class Glacius extends ActiveSpell {
  Glacius(PVector origin, PVector direction, boolean fromPlayer) {
    super(origin, direction, fromPlayer, 173, 216, 230); //whiteish blue
  }
}

class Imperio extends ActiveSpell {
  Imperio(PVector origin, PVector direction, boolean fromPlayer) {
    super(origin, direction, fromPlayer, 255, 255, 255); //white
  }
}

class Reducto extends ActiveSpell {
  Reducto(PVector origin, PVector direction, boolean fromPlayer) {
    super(origin, direction, fromPlayer, 220, 20, 60); //crimson
  }
}

class Sectumsempra extends ActiveSpell {
  Sectumsempra(PVector origin, PVector direction, boolean fromPlayer) {
    super(origin, direction, fromPlayer, 0, 0, 139); //dark blue
  }
}

class AvadaKedavra extends ActiveSpell {
  AvadaKedavra(PVector origin, PVector direction, boolean fromPlayer) {
    super(origin, direction, fromPlayer, 0, 100, 0); //dark green
  }
}

class Confringo extends ActiveSpell {

  Confringo(PVector origin, PVector direction, boolean fromPlayer) {
    super(origin, direction, fromPlayer, 255, 165, 0); //orange
  }

  void explode() {
    lives = 0;
    for (int i = 0; i < 10; i++) {
      objects.add(new Particle(loc.copy()));
    }
  }
}


class Spell_AvadaKedavra extends Spell {
  Spell_AvadaKedavra() {
    super("Avada Kedavra", "Instantly destroys target");
  }

  ActiveSpell createInstance() {
    return new AvadaKedavra(player.eye.copy(), player.getLookDirection(), true);
  }
}

class Spell_Imperio extends Spell {
  Spell_Imperio() {
    super("Imperio", "Control an enemy temporarily");
  }

  ActiveSpell createInstance() {
    return new Imperio(player.eye.copy(), player.getLookDirection(), true);
  }
}

class Spell_Sectumsempra extends Spell {
  Spell_Sectumsempra() {
    super("Sectumsempra", "Slice enemy in half");
  }

  ActiveSpell createInstance() {
    return new Sectumsempra(player.eye.copy(), player.getLookDirection(), true);
  }
}

class Spell_Confringo extends Spell {
  Spell_Confringo() {
    super("Confringo", "Big explosion");
  }

  ActiveSpell createInstance() {
    return new Confringo(player.eye.copy(), player.getLookDirection(), true);
  }
}

class Spell_Glacius extends Spell {
  Spell_Glacius() {
    super("Glacius", "Freeze enemy in place");
  }

  ActiveSpell createInstance() {
    return new Glacius(player.eye.copy(), player.getLookDirection(), true);
  }
}

class Spell_Reducto extends Spell {
  Spell_Reducto() {
    super("Reducto", "Break walls or objects");
  }

  ActiveSpell createInstance() {
    return new Reducto(player.eye.copy(), player.getLookDirection(), true);
  }
}
