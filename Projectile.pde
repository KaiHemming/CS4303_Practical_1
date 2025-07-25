class Projectile { 
  final int TRAIL_STROKE_MULTIPLIER = 1; //Multiplies based on missileRadius
  final float DRAG_COEFFICIENT = 0.05;
  final int TRAJECTORY_UPDATE_FREQ = 3;
  float gravitationalForce = 0.05;
  color trajectoryColour = #FFFFFF;
  color projectileColour = #FF0000;
  int trajectoryUpdateCount = 0;
  ArrayList<PVector> trajectory = new ArrayList<PVector>(); // For drawing trajectory line
  PVector position;
  PVector velocity;
  PVector acceleration;
  int missileRadius;
  int mass;
  float area;
  
  Projectile(int x, int y, int missileRadius, int xVelocity, int yVelocity, int mass) {
    position = new PVector(x, y);
    trajectory.add(position.copy());
    velocity = new PVector(xVelocity, yVelocity);
    acceleration = new PVector(0,0);
    this.missileRadius = missileRadius;
    this.mass = mass;
    this.area = 3 * missileRadius * missileRadius; //Aproximately
  }
  
  PVector getPosition() {
    return position;
  }
  
  void setTrajectoryColour(color colour) {
    this.trajectoryColour = colour;
  }
  void setGravitationalForce(float gravitationalForce) {
    this.gravitationalForce = gravitationalForce;
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
    
    ellipseMode(RADIUS);
    fill(projectileColour);
    ellipse(position.x, position.y, missileRadius, missileRadius);
    noStroke();
    
    if (trajectoryUpdateCount >= TRAJECTORY_UPDATE_FREQ) {
      trajectory.add(position.copy());
      trajectoryUpdateCount = 0;
    } else {
      trajectoryUpdateCount++;
    }
  }
  
  // calculateDrag() code from
  // https://processing.org/examples/forceswithvectors.html
  // Made my own changes: Divide by AIR_DENSITY
  //                       Reference area of projectiles is all the same, not included in equation.
  PVector calculateDrag(float AIR_DENSITY) {
    float speed = velocity.mag();
    float dragMagnitude = DRAG_COEFFICIENT * speed * speed * AIR_DENSITY;
    
    PVector drag = velocity.copy();
    drag.mult(-1);
    drag.setMag(dragMagnitude);
    return drag;
  }
  
  // applyForce() code from
  // https://processing.org/examples/forceswithvectors.html
  // A = F/M
  void applyForce(PVector force) {
    PVector a = PVector.div(force, mass);
    acceleration.add(a);
  }
  
  // Returns true if not out of play area
  boolean move(float AIR_DENSITY) {
    applyForce(calculateDrag(AIR_DENSITY));
    PVector gravity = new PVector(0, gravitationalForce*mass);
    applyForce(gravity);
   
    velocity.add(acceleration);
    position.add(velocity);
    
    acceleration.mult(0);
    
    boolean isAboveGround = position.y <= displayHeight; // false if on ground
    boolean isWithinWidth = position.x >= 0 & position.x <= displayWidth; //false if out of area
    return !(!isAboveGround || !isWithinWidth);
  }  
}
