// Make game graphics with Piskel

// Game element sizes
final int PROJECTILE_HEIGHT_PROPORTION = 300;
final int BALLISTA_WIDTH_PROPORTION = 10;
final int BALLISTA_HEIGHT_PROPORTION = 20;
int projectileRadius;

// Stage Physics 
final float AIR_DENSITY = 1.22; 

// Elements
Ballista[] ballistas = new Ballista[3];
ArrayList<PlayerMissile> playerMissiles = new ArrayList<PlayerMissile>();
//EnemyMissile enemyMissile;
CrossHair crossHair;

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
  int ballistaWidth = displayWidth/BALLISTA_WIDTH_PROPORTION;
  int ballistaHeight = displayHeight/BALLISTA_HEIGHT_PROPORTION;
  ballistas[0] = new Ballista(0, displayHeight - ballistaHeight, ballistaWidth, ballistaHeight);
  ballistas[1] = new Ballista(displayWidth/2 - ballistaWidth/2, displayHeight - ballistaHeight, ballistaWidth, ballistaHeight);
  ballistas[2] = new Ballista(displayWidth - ballistaWidth, displayHeight - ballistaHeight, ballistaWidth, ballistaHeight);
  projectileRadius = displayHeight/PROJECTILE_HEIGHT_PROPORTION;
  
  //enemyMissile = new EnemyMissile(displayWidth/2, displayHeight, displayHeight/PROJECTILE_HEIGHT_PROPORTION, 100, -100, 10);
}

// Render graphics
void draw() {
  background(0) ;
  //if (enemyMissile.move(AIR_DENSITY)) {
  //  enemyMissile.draw();
  //}
  
  // Crosshair Movement
  if (movingUp) {
    crossHair.moveUp();
  }
  if (movingDown) {
    crossHair.moveDown();
  }
  if (movingLeft) {
    crossHair.moveLeft() ;
  }
  if (movingRight) {
    crossHair.moveRight() ; 
  }
  
  for (int i = 0; i < ballistas.length; i++) {
    if (i == selectedBallista) {
      ballistas[i].draw(crossHair.getPosition());
    } else {
      ballistas[i].draw();
    }
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
 void mousePressed() {
   playerMissiles.add(ballistas[selectedBallista].fire(crossHair.getPosition()));
 }
 void explodePlayerMissile() {
   if (playerMissiles.size() > 0) {
     playerMissiles.remove(0);
   }
 }
 void keyPressed() {
  //if (key == CODED) {
  //   switch (keyCode) {
  //     case UP:
  //       movingUp = true;
  //       break;
  //     case DOWN:
  //       movingDown = true;
  //       break;
  //     case LEFT:
  //       movingLeft = true;
  //       break;
  //     case RIGHT:
  //       movingRight = true;
  //       break;
  switch (key) {
    case '1':
      selectedBallista = 0;
      break;
    case '2':
      selectedBallista = 1;
      break;
    case '3':
      selectedBallista = 2;
      break;
    case ' ':
      explodePlayerMissile();
      break;
 }
}
