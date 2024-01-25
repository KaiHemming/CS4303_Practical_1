// Make game graphics with Piskel

// Game element sizes
final int PROJECTILE_HEIGHT_PROPORTION = 300;
final int BALLISTA_WIDTH_PROPORTION = 10;
final int BALLISTA_HEIGHT_PROPORTION = 20;
final int CITY_HEIGHT_PROPORTION = 30;
final int METEOR_SCORE_VALUE = 25;
final int ENEMY_SCORE_VALUE = 100;
final int CITY_RESTORATION_COST = 10000;
int projectileRadius;

// Stage Physics 
final float AIR_DENSITY = 1.22; 

// Game Elements
Wave wave;
Ballista[] ballistae = new Ballista[3];
City[] cities = new City[6];
ArrayList<PlayerMissile> playerMissiles = new ArrayList<PlayerMissile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
CrossHair crossHair = new CrossHair();
int score = 0;
int scoreMultiplier = 1;
HUD hud = new HUD();
boolean hasLost;
boolean hasStarted = false;
LoseScreen loseScreen = new LoseScreen();
TitleScreen titleScreen = new TitleScreen();
int spentScore;

// Wave values
int waveNumber = 1;
int numMeteors = 5;
int spawnerTicks = 400;
int maxSpawnsPerTick = 2;
int yVelocityVariance = 0;

// Inputs
int selectedBallista = 1;

void reset() {
  waveNumber = 1;
  numMeteors = 5;
  spawnerTicks = 400;
  maxSpawnsPerTick = 2;
  yVelocityVariance = 0;
  score = 0;
  scoreMultiplier = 1;
  spentScore = 0;
  hasLost = false;
  hasStarted = true;
  
  projectileRadius = displayHeight/PROJECTILE_HEIGHT_PROPORTION;
  
  // Spawn ballistas
  int ballistaWidth = displayWidth/BALLISTA_WIDTH_PROPORTION;
  int ballistaHeight = displayHeight/BALLISTA_HEIGHT_PROPORTION;
  int secondBallistaXCoord = displayWidth/2 - ballistaWidth/2;
  int thirdBallistaXCoord = displayWidth - ballistaWidth;
  int y = displayHeight - ballistaHeight;
  ballistae[0] = new Ballista(0, y, ballistaWidth, ballistaHeight);
  ballistae[1] = new Ballista(secondBallistaXCoord, y, ballistaWidth, ballistaHeight);
  ballistae[2] = new Ballista(thirdBallistaXCoord, y, ballistaWidth, ballistaHeight);
  
  // Spawn cities
  int cityWidth = ballistaWidth;
  int cityHeight = displayHeight/CITY_HEIGHT_PROPORTION;
  int spacing = (secondBallistaXCoord - ballistaWidth - 3*cityWidth)/4;
  int x = ballistaWidth + spacing;
  y = displayHeight - cityHeight;
  for (int i = 0; i < cities.length; i++) {
    if (i != 0) {
      x += cityWidth + spacing;
      if (i == 3) {
        x += ballistaWidth + spacing;
      }
    }
    cities[i] = new City(x, y, cityWidth, cityHeight);
  }
  
  // Start first wave
  startNewWave();
}

void setup() {
  fullScreen();
  noCursor();
  titleScreen.draw();
}
void startNewWave() {
  boolean checkLost = true;
    for (City city:cities) {
      if (city.isSurviving()) {
        checkLost = false;
        break;
      }
    }
  hasLost = checkLost;
  if (wave != null) {
    score += wave.endWave() * scoreMultiplier;
  }
  if (waveNumber % 2 == 1
      & waveNumber < 10 
      & waveNumber > 1) {
        
    scoreMultiplier++;
  }
  // Start Wave
  wave = new Wave(numMeteors, spawnerTicks, maxSpawnsPerTick, yVelocityVariance, cities, ballistae);
  printWaveData();
  
  // Change values for next wave
  if (waveNumber <= 10) {
    numMeteors += (10-waveNumber)/2;
    yVelocityVariance++;
    if (waveNumber%3 == 1) {
      spawnerTicks -= 20;
      maxSpawnsPerTick++;
    }
  } else {
    numMeteors+=3;
  }
  waveNumber++;
  int numToRestore = constrain((int)(score - spentScore)/CITY_RESTORATION_COST, 0, 6);
  if (numToRestore > 0) {
    println("Restoring " + numToRestore + " cities");
    for (int i = 0; i < cities.length; i++) {
      if (!cities[i].isSurviving) {
        cities[i].setSurviving(true);
        spentScore += CITY_RESTORATION_COST;
        numToRestore--;
        if (numToRestore < 1) {
          break;
        }
      }
    }
  }
}

void addScore(int addition) {
  score += addition * scoreMultiplier; 
}

void printWaveData() {
  println("Wave ", waveNumber);
  println("numMeteors: ", numMeteors);
  println("spawnerTicks: ", spawnerTicks);
  println("maxSpawnsPerTick: ", maxSpawnsPerTick);
  println("yVelocityVariance: ", yVelocityVariance);
}
void render() {
  background(0);
  boolean remainingBallistae = false;
  for (int i = 0; i < ballistae.length; i++) {
    if (i == selectedBallista) {
      ballistae[i].draw(crossHair.getPosition());
    } else {
      ballistae[i].draw();
    }
    if (!ballistae[i].isDisabled()) {
      remainingBallistae = true;
    }
  }
  boolean remainingCities = false;
  for (int i = 0; i < cities.length; i++) {
    cities[i].draw();
    if (!remainingBallistae) {
      if (cities[i].isSurviving()) {
        remainingCities = true;
      }
    }
  }
  if (!remainingCities & !remainingBallistae) {
    hasLost = true;
  }
  for (int i = 0; i < explosions.size(); i++) {
    Explosion explosion = explosions.get(i);
    explosion.draw();
    if (!explosion.update()) {
      explosions.remove(explosion);
    } else {
      ArrayList<Meteor> meteors = wave.getMeteors();
      for (int j = 0; j < meteors.size(); j++) {
        Meteor meteor = meteors.get(j);
        PVector meteorPosition = meteor.getPosition().copy();
        if (explosion.isMeteorInRadius(meteor)) {
          wave.removeMeteor(meteor);
          addScore(METEOR_SCORE_VALUE);
          j--;
          explosions.add(new Explosion((int)meteorPosition.x, (int)meteorPosition.y));
        }
      }
      ArrayList<Enemy> enemies = wave.getEnemies();
      for (int j = 0; j < enemies.size(); j++) {
        Enemy enemy = enemies.get(j);
        if (explosion.isEnemyInRadius(enemy)) {
          wave.removeEnemy(enemy);
          addScore(ENEMY_SCORE_VALUE);
          j--;
        }
      }
    }
  }
  
  if (!wave.spawnerTrigger() & !wave.draw(AIR_DENSITY)) {
    startNewWave();
  }
  
  crossHair.setPos(mouseX, mouseY);
  crossHair.draw() ;
  
  for (int i = 0; i < playerMissiles.size(); i++) {
    PlayerMissile missile = playerMissiles.get(i);
    if (missile.move(AIR_DENSITY)) {
      missile.draw();
    } else {
      playerMissiles.remove(i);
    }
  }
  hud.draw(score, waveNumber, ballistae);
}

// Render graphics
void draw() {
  if (hasLost) {
    loseScreen.draw();
    hud.draw(score, waveNumber, ballistae);
  } else if (!hasStarted) {
    titleScreen.draw();
  }
  else {
    render();
  }
 }
 void detectMeteorsInExplosionRadius() {
 }
 void explodePlayerMissile() {
   if (playerMissiles.size() > 0) {
     PlayerMissile missile = playerMissiles.get(0);
     PVector coords = missile.getPosition().copy();
     playerMissiles.remove(missile);
     explosions.add(new Explosion((int)coords.x, (int)coords.y));
   }
 }
 void mousePressed() {
   if (hasLost | !hasStarted) {
     return;
   }
   if (mouseButton == LEFT) {
     PlayerMissile playerMissile = ballistae[selectedBallista].fire(crossHair.getPosition());
     if (playerMissile != null) {
       playerMissiles.add(playerMissile);
     }
   } else if (mouseButton == RIGHT) {
     explodePlayerMissile();
   }
 }
 void keyPressed() {
  switch (key) {
    case '1':
      if (ballistae[0].isDisabled()) break;
      selectedBallista = 0;
      break;
    case '2':
      if (ballistae[1].isDisabled()) break;
      selectedBallista = 1;
      break;
    case '3':
      if (ballistae[2].isDisabled()) break;
      selectedBallista = 2;
      break;
    case ' ':
      explodePlayerMissile();
      if (hasLost) {
        reset();
      }
      else if (!hasStarted) {
        reset();
      } else {
        explodePlayerMissile();
      }
      break;
 }
}
