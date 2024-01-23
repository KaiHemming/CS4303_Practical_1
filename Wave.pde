final class Wave {
  final float WAVE_GRAVITY = 0.01;
  final int XVELOCITY_VARIANCE = 5;
  final int PROJECTILE_MASS = 20;
  final int SPAWN_DELAY = 100;
  final int WIDTH_PADDING = displayWidth/10;
  City[] cities;
  Ballista[] ballistae;
  int yVelocityVariance;
  int numMeteors;
  int numSpawned;
  ArrayList<Meteor> meteors = new ArrayList<Meteor>();
  ArrayList<Explosion> explosions = new ArrayList<Explosion>();
  int spawnerTicks;
  int currentSpawnerTicks;
  int maxSpawnsPerTick;
  
  Wave(int numMeteors, int spawnerTicks, int maxSpawnsPerTick, int yVelocityVariance, City[] cities, Ballista[] ballistae) {
    this.cities = cities;
    this.ballistae = ballistae;
    this.numMeteors = numMeteors;
    this.spawnerTicks = spawnerTicks;
    this.maxSpawnsPerTick = maxSpawnsPerTick;
    this.currentSpawnerTicks = spawnerTicks - SPAWN_DELAY;
    this.yVelocityVariance = yVelocityVariance;
  }
  
  ArrayList<Meteor> getMeteors() {
    return meteors;
  }
  
  void removeMeteor(Meteor meteor) {
    meteors.remove(meteor);
  }
  
  // Returns false if there are no more meteors to spawn.
  boolean spawnerTrigger() {
    if (numSpawned >= numMeteors) {
      return false;
    }
    if (currentSpawnerTicks >= spawnerTicks) {
      int numToSpawn = (int)random(1, constrain(maxSpawnsPerTick, maxSpawnsPerTick, numMeteors - numSpawned) + 1);
      for (int i = 0; i < numToSpawn; i++) {
        spawnMeteor();
        numSpawned++;
      }
      currentSpawnerTicks = 0;
    }
    currentSpawnerTicks++;
    return true;
  }
  
  void spawnMeteor() {
    int x = (int)random(WIDTH_PADDING, displayWidth-WIDTH_PADDING);
    int xVelocity = 0;
    if (x > WIDTH_PADDING*2 & x < displayWidth-WIDTH_PADDING*2) {
      xVelocity = (int)random(XVELOCITY_VARIANCE*-1, XVELOCITY_VARIANCE);
    }
    int yVelocity = (int)random(0, yVelocityVariance);
    
    Meteor meteor = new Meteor(x, -10, projectileRadius, xVelocity, yVelocity, PROJECTILE_MASS);
    meteor.setGravitationalForce(WAVE_GRAVITY);
    meteors.add(meteor);
  }
  // true if things to draw
  boolean draw(float AIR_DENSITY) {
    for (int i = 0; i < explosions.size(); i++) {
      Explosion explosion = explosions.get(i);
      if (!explosion.update()) {
        explosions.remove(explosion);
      }
      explosion.draw();
    }
    if (meteors.size() <= 0) {
      return false;
    }
    for (int i = 0; i < meteors.size(); i++) {
      Meteor meteor = meteors.get(i);
      if (!meteor.move(AIR_DENSITY)) {
        PVector meteorPosition = meteor.getPosition();
        meteors.remove(meteor);
        if (meteorPosition.y >= displayHeight-displayWidth/20) {
          checkCollision((int)meteorPosition.x);
        }
      } else {
        meteor.draw();
      }
    }
    return true;
  }
  
  void checkCollision(int x) {
    // Cities
    for (City city:cities) {
      int leftX = (int)city.getPosition().x;
      int rightX = leftX+city.getWidth();
      if (x >= leftX & x <= rightX) {
        city.setSurviving(false);
        Explosion explosion = new Explosion(x, displayHeight);
        explosions.add(explosion);
      }
    }
    // Ballistae
    for (Ballista ballista:ballistae) {
      int leftX = (int)ballista.getPosition().x;
      int rightX = leftX+ballista.getWidth();
      if (x >= leftX & x <= rightX) {
        ballista.setDisabled(true);
        Explosion explosion = new Explosion(x, displayHeight);
        explosions.add(explosion);
      }
    }
  }
  
  // TODO:
  void calculateScore() {
  }
  
  void endWave() {
    for (City city:cities) {
      city.setSurviving(true);
    }
    for (Ballista ballista:ballistae) {
      ballista.reset();
    }
  }
}
