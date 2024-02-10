final class Wave {
  // Chances are 1 in ___
  final int ENEMY_SPAWN_CHANCE_MAX = 2000;
  final int SPLIT_CHANCE_MAX = 1500;
  
  final float WAVE_GRAVITY = 0.01;
  final int XVELOCITY_VARIANCE = 5;
  final int PROJECTILE_MASS = 20;
  final int SPAWN_DELAY = 100;
  final int WIDTH_PADDING = displayWidth/10;
  final int CITY_SCORE_VALUE = 100;
  final int UNUSED_BOMB_SCORE_VALUE = 5;
  final int ENEMY_SPAWN_HEIGHT = (int)(displayHeight/2.5);
  
  City[] cities;
  Ballista[] ballistae;
  int yVelocityVariance;
  int numMeteors;
  int numSpawned;
  ArrayList<Meteor> meteors = new ArrayList<Meteor>();
  ArrayList<Explosion> explosions = new ArrayList<Explosion>();
  ArrayList<Enemy> enemies = new ArrayList<Enemy>();
  ArrayList<SmartBomb> smartBombs = new ArrayList<SmartBomb>();
  int spawnerTicks;
  int currentSpawnerTicks;
  int maxSpawnsPerTick;
  int enemySpawnChance;
  int meteorSplitChance;
  
  Wave(int numMeteors, int spawnerTicks, int maxSpawnsPerTick, int yVelocityVariance, City[] cities, Ballista[] ballistae) {
    this.cities = cities;
    this.ballistae = ballistae;
    this.numMeteors = numMeteors;
    this.spawnerTicks = spawnerTicks;
    this.maxSpawnsPerTick = maxSpawnsPerTick;
    this.currentSpawnerTicks = spawnerTicks - SPAWN_DELAY;
    this.yVelocityVariance = yVelocityVariance;
    this.enemySpawnChance = ENEMY_SPAWN_CHANCE_MAX - constrain(((waveNumber-1) * 100), 0, 1000);
    this.meteorSplitChance = SPLIT_CHANCE_MAX - constrain(((waveNumber-1) * 100), 0, 1000);
    System.out.println("enemySpawnChance: 1 in " + enemySpawnChance);
    System.out.println("meteorSplitChance: 1 in " + meteorSplitChance);
  }
  
  ArrayList<Meteor> getMeteors() {
    return meteors;
  }
  
  ArrayList<Enemy> getEnemies() {
    return enemies;
  }
  
  ArrayList<SmartBomb> getSmartBombs() {
    return smartBombs;
  }
  
  void removeMeteor(Meteor meteor) {
    meteors.remove(meteor);
  }
  
  void removeEnemy(Enemy enemy) {
    enemies.remove(enemy);
  }
  
  void removeSmartBomb(SmartBomb smartBomb) {
    smartBombs.remove(smartBomb);
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
    if (waveNumber > 2 & meteors.size() > 0) {
      int chance = (int)random(1, meteorSplitChance + 1);
      if (chance == 1) { 
        Meteor meteor = meteors.get((int)random(0, meteors.size()));
        int numSplits = (int) random(2, constrain(waveNumber/2,1,3) + 1); //Changed numSplits to scale with waveNumber after first playtest
        ArrayList<Meteor> splits = meteor.split(WAVE_GRAVITY, numSplits);
        meteors.remove(meteor);
        meteors.addAll(splits);
      }
    }
    for (int i = 0; i < explosions.size(); i++) {
      Explosion explosion = explosions.get(i);
      if (!explosion.update()) {
        explosions.remove(explosion);
      } else {
        explosion.draw();
      }
    }
    if (waveNumber > 2 & (numMeteors-numSpawned) > 1) { 
       if ((int)random(1, enemySpawnChance + 1) == 1) {
         spawnEnemy();
       }
    }
    for (int i = 0; i < enemies.size(); i++) {
      Enemy enemy = enemies.get(i);
      if (enemy.hasFinished()) {
        removeEnemy(enemy);
        i--;
        continue;
      } else {
        Meteor meteor = enemy.move(WAVE_GRAVITY);
        enemy.draw();
        if (meteor != null) {
          meteors.add(meteor);
        }
      }
    }
    if (meteors.size() <= 0 & enemies.size() <= 0 & smartBombs.size() <= 0) {
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
    for (int i = 0; i < smartBombs.size(); i++) {
      SmartBomb bomb = smartBombs.get(i);
      if (!bomb.move(AIR_DENSITY)) {
        PVector bombPosition = bomb.getPosition();
        smartBombs.remove(bomb);
        if (bombPosition.y >= displayHeight - displayWidth/20) {
          checkCollision((int)bombPosition.x);
        }
      } else {
        bomb.draw();
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
  
  int calculateScore() {
    int score = 0;
    for (City city:cities) {
      if (city.isSurviving()) {
        score += CITY_SCORE_VALUE;
      }
    }
    for (Ballista ballista:ballistae) {
      if (!ballista.isDisabled()) {
        score += ballista.getNumProjectiles() * UNUSED_BOMB_SCORE_VALUE;
      }
    }
    return score;
  }
  
  int endWave() {
    int score = calculateScore(); //After second play test, fixed bug where ballista ammo score is also max.
    for (Ballista ballista:ballistae) {
      ballista.reset();
    }
    return score;
  }
  
  void spawnEnemy() {
    boolean isMovingLeft;
    int x;
    if ((int)random(1,3) == 1) {
      isMovingLeft = true;
      x = displayWidth;
    } else {
      isMovingLeft = false;
      x = 0;
    }
    int enemySelector;
    if (waveNumber > 5) { // Smart Bombs spawn from wave 5 onwards
      enemySelector = 4;
    } else {
      enemySelector = 3;
    }
    int r = (int)random(1, enemySelector);
    switch (r) {
      case 1:
        Satellite satellite = new Satellite(x, ENEMY_SPAWN_HEIGHT, isMovingLeft, waveNumber);
        enemies.add(satellite);
        break;
      case 2:
        Bomber bomber = new Bomber(x, ENEMY_SPAWN_HEIGHT, isMovingLeft, waveNumber);
        enemies.add(bomber);
        break;
      case 3:
        x = (int)random(WIDTH_PADDING, displayWidth-WIDTH_PADDING);
        int xVelocity = 0;
        if (x > WIDTH_PADDING*2 & x < displayWidth-WIDTH_PADDING*2) {
          xVelocity = (int)random(XVELOCITY_VARIANCE*-1, XVELOCITY_VARIANCE);
        }
        int yVelocity = (int)random(0, yVelocityVariance);

        SmartBomb bomb = new SmartBomb(x, -10, projectileRadius, xVelocity, yVelocity, PROJECTILE_MASS);
        bomb.setGravitationalForce(WAVE_GRAVITY);
        smartBombs.add(bomb);
    }
  }
}
