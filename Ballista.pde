final class Ballista {
  final color BALLISTA_COLOUR = #FFFFFF;
  final color SELECTED_BALLISTA_COLOUR = #6A6A6A;
  final color LAUNCH_POS_COLOUR = #810000;
  final color TRAJECTORY_COLOUR = #272525;
  final int TRAJECTORY_LINE_WEIGHT = 2;
  final int TRAJECTORY_DISPLAY_HEIGHT = displayHeight/2;
  final int PROJECTILE_MASS = 20;
  final int REMAINING_AMMO_SCORE = 5;
  final int NUM_PROJECTILES = 10;
  boolean isDisabled = false;
  int numProjectiles = 10;
  PVector position;
  PVector launchPosition;
  int width, height;
  
  Ballista(int x, int y, int width, int height) {
    position = new PVector(x, y);
    launchPosition = position.copy();
    launchPosition.x += width/2;
    this.width = width;
    this.height = height;
  }
  PVector getPosition() {
    return position;
  }
  int getWidth() {
    return width;
  }
  boolean isDisabled() {
    return isDisabled;
  }
  void setDisabled(boolean isDisabled) {
    this.isDisabled = isDisabled;
  }
  void reset() {
    isDisabled = false;
    numProjectiles = NUM_PROJECTILES;
  }
  // Returns null if there are no more projectiles
  PlayerMissile fire(PVector crossHairPos) {
    if (isDisabled) {
      return null;
    }
    if (numProjectiles <= 0) {
      return null;
    }
    float adjacent = (crossHairPos.x - launchPosition.x);
    float opposite = abs(constrain(crossHairPos.y, displayHeight - TRAJECTORY_DISPLAY_HEIGHT, displayHeight - height) - launchPosition.y);
    //int angle = Math.round(atan(opposite/adjacent) * 180/PI);
    //println(angle);
    PVector velocity = new PVector(adjacent/20, opposite*-1/20);
    PlayerMissile missile = new PlayerMissile((int)launchPosition.x, (int)launchPosition.y, projectileRadius, (int)velocity.x, (int)velocity.y, PROJECTILE_MASS);
    numProjectiles--;
    return missile;
  }
  void draw(PVector crossHairPos) {
    if (isDisabled) {
      return;
    }
    strokeWeight(TRAJECTORY_LINE_WEIGHT);
    stroke(TRAJECTORY_COLOUR);
    line(launchPosition.x, launchPosition.y, crossHairPos.x, constrain(crossHairPos.y, displayHeight - TRAJECTORY_DISPLAY_HEIGHT, displayHeight - height));
   
    noStroke();
    ellipseMode(RADIUS);
    fill(LAUNCH_POS_COLOUR);
    ellipse(launchPosition.x, launchPosition.y, height/4, height/4);
    
    fill(SELECTED_BALLISTA_COLOUR);
    rect(position.x, position.y, width, height);
  }
  
  void draw() {
    if (isDisabled) {
      return;
    }
    ellipseMode(RADIUS);
    fill(BALLISTA_COLOUR);
    ellipse(launchPosition.x, launchPosition.y, height/4, height/4);
    rect(position.x, position.y, width, height);
  }
}
