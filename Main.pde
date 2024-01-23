// Make game graphics with Piskel

// Game element sizes
final int PROJECTILE_HEIGHT_PROPORTION = 300;
final int BALLISTA_WIDTH_PROPORTION = 10;
final int BALLISTA_HEIGHT_PROPORTION = 20;
final int CITY_HEIGHT_PROPORTION = 30;
int projectileRadius;

// Stage Physics 
final float AIR_DENSITY = 1.22; 

// Game Elements
Wave wave;
Ballista[] ballistae = new Ballista[3];
City[] cities = new City[6];
ArrayList<PlayerMissile> playerMissiles = new ArrayList<PlayerMissile>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();
CrossHair crossHair;

// Wave values
int waveNumber = 1;
int numMeteors = 5;
int spawnerTicks = 400;
int maxSpawnsPerTick = 2;
int yVelocityVariance = 0;

// Inputs
boolean movingUp = false;
boolean movingDown = false;
boolean movingLeft = false;
boolean movingRight = false;
int selectedBallista = 1;

void setup() {
  fullScreen();
  noCursor();
  crossHair = new CrossHair();
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
void startNewWave() {
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
}

void printWaveData() {
  println("Wave ", waveNumber);
  println("numMeteors: ", numMeteors);
  println("spawnerTicks: ", spawnerTicks);
  println("maxSpawnsPerTick: ", maxSpawnsPerTick);
  println("yVelocityVariance: ", yVelocityVariance);
}
void render() {
  background(0) ;
  
  for (int i = 0; i < ballistae.length; i++) {
    if (i == selectedBallista) {
      ballistae[i].draw(crossHair.getPosition());
    } else {
      ballistae[i].draw();
    }
  }
  for (int i = 0; i < cities.length; i++) {
    cities[i].draw();
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
          j--;
          explosions.add(new Explosion((int)meteorPosition.x, (int)meteorPosition.y));
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
}

// Render graphics
void draw() {
  render();
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
      break;
 }
}
