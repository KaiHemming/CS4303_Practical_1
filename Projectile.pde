class Projectile { 
  final int TRAIL_STROKE_MULTIPLIER = 1; //Multiplies based on missileRadius
  final float DRAG_COEFFICIENT = 0.05;
  final int TRAJECTORY_UPDATE_FREQ = 5;
  color trajectoryColour = #FFFFFF;
  //color projectileColour =  TODO
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
  
  void setTrajectoryColour(color colour) {
    this.trajectoryColour = colour;
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
    fill(#FF0000);
    ellipse(position.x, position.y, missileRadius, missileRadius);
    noStroke();
    
    if (trajectoryUpdateCount >= TRAJECTORY_UPDATE_FREQ) {
      trajectory.add(position.copy());
      trajectoryUpdateCount = 0;
    } else {
      trajectoryUpdateCount++;
    }
  }
  
  // https://processing.org/examples/forceswithvectors.html
  PVector calculateDrag(float AIR_DENSITY) {
    float speed = velocity.mag();
    float dragMagnitude = (DRAG_COEFFICIENT * speed * speed)/AIR_DENSITY;
    //float dragMagnitude = (AIR_DENSITY * speed * speed * DRAG_COEFFICIENT * area) / 2;
    
    PVector drag = velocity.copy();
    drag.mult(-1);
    drag.setMag(dragMagnitude);
    return drag;
  }
  
  // https://processing.org/examples/forceswithvectors.html
  // A = F/M
  void applyForce(PVector force) {
    PVector a = PVector.div(force, mass);
    acceleration.add(a);
  }
  
  // Returns true if not out of play area
  boolean move(float AIR_DENSITY) {
    
    applyForce(calculateDrag(AIR_DENSITY));
    PVector gravity = new PVector(0, 0.1*mass);
    applyForce(gravity);
   
    velocity.add(acceleration);
    position.add(velocity);
    
    acceleration.mult(0);
    return position.y >= 0;
  }  
}
