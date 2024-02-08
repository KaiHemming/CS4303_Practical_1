final class SmartBomb extends Projectile {
  int COUNTS_PER_FLASH = 10;
  int flashCount = 0;
  color trajectoryColour = #6A6A6A;
  color FLASH_COLOUR = #810000;
  
  SmartBomb(int x, int y, int radius, int xVelocity, int yVelocity, int mass) {
    super(x, y, radius, xVelocity, yVelocity, mass);
    this.setTrajectoryColour(trajectoryColour);
  }
  
  //TODO: void move() {

  void draw() {
    strokeWeight(missileRadius * TRAIL_STROKE_MULTIPLIER);
    stroke(trajectoryColour);
    for (int i = 1; i < trajectory.size(); i++) {
      PVector startPos = trajectory.get(i);
      PVector endPos = trajectory.get(i-1);
      line(startPos.x, startPos.y, endPos.x, endPos.y);
    }
    PVector endPos = trajectory.get(trajectory.size()-1);
    line(endPos.x, endPos.y, position.x, position.y);
    
    noStroke();
    ellipseMode(RADIUS);
    if (flashCount > 0 & flashCount < COUNTS_PER_FLASH/2) {
      fill(#FF0000);
    } else {
      fill(FLASH_COLOUR);
    }
    ellipse(position.x, position.y, missileRadius, missileRadius);
    
    if (trajectoryUpdateCount >= TRAJECTORY_UPDATE_FREQ) {
      trajectory.add(position.copy());
      trajectoryUpdateCount = 0;
    } else {
      trajectoryUpdateCount++;
    }
    flashCount++;
    if (flashCount >= COUNTS_PER_FLASH) {
      flashCount = 0;
    }
  }
}
