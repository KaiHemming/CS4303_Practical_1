final class SmartBomb extends Projectile {
  int COUNTS_PER_FLASH = 10;
  int JOLT_Y_VELOCITY = -1;
  int DETECTION_RADIUS = displayHeight/14;
  int flashCount = 0;
  color trajectoryColour = #6A6A6A;
  color FLASH_COLOUR = #810000;
  
  SmartBomb(int x, int y, int radius, int xVelocity, int yVelocity, int mass) {
    super(x, y, radius, xVelocity, yVelocity, mass);
    this.setTrajectoryColour(trajectoryColour);
  }
  
  int getDetectionRadius() {
    return DETECTION_RADIUS;
  }
  
  void jolt(int x) {
    velocity.x = x;
    velocity.y = JOLT_Y_VELOCITY;
  }
  
  // Returns true if in play area
  boolean move(float AIR_DENSITY) {
    applyForce(calculateDrag(AIR_DENSITY));
    PVector gravity = new PVector(0, gravitationalForce*mass);
    applyForce(gravity);
   
    velocity.add(acceleration);
    position.add(velocity);
    
    acceleration.mult(0);
    
    boolean isAboveGround = position.y <= displayHeight; // false if on ground
    boolean isWithinWidth = position.x >= 0 & position.x <= displayWidth; //false if out of area
    
    // Instead of returning false when not within width, 
    // smart bombs bounce off sides
    if (!isWithinWidth) {
      velocity.x = -velocity.x;
    }
    return isAboveGround;
  }  

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
