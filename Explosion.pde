// Could take trajectory
final class Explosion {
  final int EXPLOSION_RADIUS = displayHeight/15;
  color colour = #FAFF00;
  final int EXPLOSION_TICKS = 125;
  int currentRadius = EXPLOSION_RADIUS/5;
  PVector position;
  int currentTicks = 1;
  int transparency;
  
  Explosion(int x, int y) {
    position = new PVector(x, y);
    transparency = 255;
  }
  
  void setColour(color colour) {
    this.colour = colour;
  }
  
  boolean update() {
    currentRadius+= 2;
    currentRadius = constrain(currentRadius, currentRadius, EXPLOSION_RADIUS);
    currentTicks++;
    return currentTicks <= EXPLOSION_TICKS;
  }
  
  void draw() {
    if (currentTicks <= EXPLOSION_TICKS) {
      ellipseMode(RADIUS);
      fill(colour, transparency);
      ellipse(position.x, position.y, currentRadius, currentRadius);
      transparency-=2;
    }
  }
  
  boolean isMeteorInRadius(Meteor meteor) {
    PVector meteorPosition = meteor.getPosition();
    if (dist(position.x, position.y, meteorPosition.x, meteorPosition.y) <= currentRadius) {
      return true;
    }
    return false;
  }
  
  boolean isSmartBombInJumpRadius(SmartBomb smartBomb) {
    PVector bombPosition = smartBomb.getPosition();
    if (dist(position.x, position.y, bombPosition.x, bombPosition.y) <= smartBomb.getDetectionRadius()) {
      return true;
    }
    return false;
  }
  
  boolean isSmartBombInRadius(SmartBomb smartBomb) {
    PVector bombPosition = smartBomb.getPosition();
    if (dist(position.x, position.y, bombPosition.x, bombPosition.y) <= currentRadius) {
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
