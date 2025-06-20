class Imperio extends Spell {
  public Imperio() {
    super(
      player.eye.x,
      player.eye.y,
      player.eye.z,
      50,
      new PVector(
      cos(player.leftRightHeadAngle),
      tan(player.upDownHeadAngle),
      sin(player.leftRightHeadAngle)
      )
      );
  }
}
