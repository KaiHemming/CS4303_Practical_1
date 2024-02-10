class Enemy {
  final int PROJECTILE_HEIGHT_PROPORTION = 250;
  final int PROJECTILE_MASS = 20;
  final int MOVE_INCREMENT_PROPORTION = 1000;
  final int SHOT_CHANCE = 300; // 1 in ...
  
  PVector position = new PVector();
  int width = displayWidth/30;
  int height = displayHeight/60;
  boolean isMovingLeft;
  int waveNumber; // Added after first playtest, code refactored
  
  Enemy(int x, int y, boolean isMovingLeft, int waveNumber) {
    int newY = y + constrain((waveNumber*10)-10, 0, 300); //Added after first playtest
    position = new PVector(x, newY);
    this.isMovingLeft = isMovingLeft;
    this.waveNumber = waveNumber;
  }
  
  // Returns position relative to size
  PVector getPosition() {
    return new PVector(position.x+width/2, position.y+height/2);
  }
  
  void draw() {}
  
  boolean hasFinished() {
    if (position.x <= 0 - width | position.x >= displayWidth + width) {
      return true;
    }
    return false;
  }
  
  // Returns a meteor if one is spawned.
  Meteor move(float waveGravity) {
    if (isMovingLeft) {
      position.x -= displayWidth/MOVE_INCREMENT_PROPORTION;
    } else {
      position.x += displayWidth/MOVE_INCREMENT_PROPORTION;
    }
    int adjustedShotChance = constrain(waveNumber*50, 50, SHOT_CHANCE); // Added after first playtest
    if ((int)random(1,SHOT_CHANCE+1) == 1) {
      return spawnMeteor(waveGravity);
    }
    return null;
  }
  
  Meteor spawnMeteor(float waveGravity) {
    int y = (int)position.y + height;
    int x = (int)position.x + width/2;
    
    Meteor meteor = new Meteor(x, y, displayHeight/PROJECTILE_HEIGHT_PROPORTION, 0, 0, PROJECTILE_MASS);
    meteor.setGravitationalForce(waveGravity);
    return meteor;
  }
}
