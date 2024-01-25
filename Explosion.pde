// Could take trajectory
final class Explosion {
  final int EXPLOSION_RADIUS = displayHeight/18;
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
  
  // Checks if touching enemy, by checking if it is touching any of the corners. 
  boolean isEnemyInRadius(Enemy enemy) {
    int closestX = (int)constrain(position.x, enemy.position.x, enemy.position.x + enemy.width);
    int closestY = (int)constrain(position.y, enemy.position.y, enemy.position.y + enemy.height);
    if (dist(position.x, position.y, closestX, closestY) <= currentRadius) {
      return true;
    }
    return false;
  }
}
