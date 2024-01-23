// Could take trajectory
// Replace projectile with explosion on impact
final class Explosion {
  final int EXPLOSION_RADIUS = displayHeight/20;
  color colour = #FAFF00;
  final int EXPLOSION_TICKS = 70;
  int currentRadius = EXPLOSION_RADIUS/5;
  PVector position;
  int currentTicks = 1;
  
  Explosion(int x, int y) {
    position = new PVector(x, y);
  }
  
  void setColour(color colour) {
    this.colour = colour;
  }
  
  boolean update() {
    currentRadius++;
    currentRadius = constrain(currentRadius, currentRadius, EXPLOSION_RADIUS);
    currentTicks++;
    return currentTicks <= EXPLOSION_TICKS;
  }
  
  void draw() {
    if (currentTicks <= EXPLOSION_TICKS) {
      ellipseMode(RADIUS);
      fill(colour);
      ellipse(position.x, position.y, currentRadius, currentRadius);
    }
  }
  
  boolean isMeteorInRadius(Meteor meteor) {
    PVector meteorPosition = meteor.getPosition();
    if (dist(position.x, position.y, meteorPosition.x, meteorPosition.y) <= currentRadius) {
      return true;
    }
    return false;
  }
}
