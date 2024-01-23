// Could take trajectory
// Replace projectile with explosion on impact
final class Explosion {
  final int EXPLOSION_RADIUS = displayHeight/20;
  final color COLOUR = #FAFF00;
  final int EXPLOSION_TICKS = 100;
  int currentRadius = EXPLOSION_TICKS/10;
  PVector position;
  int currentTicks = 1;
  
  Explosion(int x, int y) {
    position = new PVector(x, y);
  }
  
  boolean update() {
    float radius = ((float)constrain(currentTicks,EXPLOSION_TICKS/10,EXPLOSION_TICKS)/EXPLOSION_TICKS)*(float)EXPLOSION_RADIUS;
    currentRadius = (int) radius;
    currentTicks++;
    return currentTicks <= EXPLOSION_TICKS;
  }
  
  void draw() {
    if (currentTicks <= EXPLOSION_TICKS) {
      ellipseMode(RADIUS);
      fill(COLOUR);
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
