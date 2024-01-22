// Some constants used to derive sizes for game elements from display size
final int PLAYER_WIDTH_PROPORTION = 10,
          PLAYER_HEIGHT_PROPORTION = 10,
          PLAYER_INIT_X_PROPORTION = 2,
          PLAYER_INCREMENT_PROPORTION = 50 ;
final int MISSILE_WIDTH_PROPORTION = 4,
          MISSILE_HEIGHT_PROPORTION = 4,
          MISSILE_INCREMENT_PROPORTION = 30 ;
final int GRAVITY = 10;
final float AIR_DENSITY = 1.22; 
//final double DRAG_COEFFICIENT = -0.5;


// The player and the missile - elements of the game should go in a class.
PlayerShip player ;
PlayerMissile missile ;
EnemyMissile enemyMissile;
boolean firing = false ;
// Notice how these Booleans are used instead of polling the keyboard every frame.
boolean movingLeft = false ;
boolean movingRight = false ;

// Initialise display and game elements
// NB Accessing displayWidth/Height pre setup() doesn't seem to work out
void setup() {
  fullScreen() ; 
  // initialise the player. 
  int playerWidth = displayWidth/PLAYER_WIDTH_PROPORTION ;
  int playerHeight = displayHeight/PLAYER_HEIGHT_PROPORTION ;
  int playerInitX = displayWidth/PLAYER_INIT_X_PROPORTION - playerWidth/2 ;
  int playerInitY = displayHeight - playerHeight ;
  int playerIncrement = displayWidth/PLAYER_INCREMENT_PROPORTION ;    
  player = new PlayerShip(playerInitX, playerInitY,
                          playerWidth, playerHeight, playerIncrement) ;
  // not initially firing, but initialise missile object
  missile = new PlayerMissile(0,0,
                              playerWidth/MISSILE_WIDTH_PROPORTION,
                              playerHeight/MISSILE_HEIGHT_PROPORTION,
                              MISSILE_INCREMENT_PROPORTION) ;
  enemyMissile = new EnemyMissile(displayWidth/2, displayHeight, playerHeight/30, 100, -100, 10);
}

// update and render
void draw() {
  background(0) ;
  if (enemyMissile.move(GRAVITY, AIR_DENSITY)) {
    enemyMissile.draw();
  }
  // the player
  if (movingLeft) {
    player.moveLeft() ;
  }
  else if (movingRight) {
    player.moveRight() ; 
  }
  player.draw() ;
  // the missile
  if (firing) {
    // render missile
    if (missile.move()) {
      missile.draw() ;
    }
    else firing = false ;
  }
}

// Read keyboard for input. Notice how booleans are used to maintain state and so
// give a smooth update. These methods are not called often enough otherwise.
void keyPressed() {
  // space to fire   
  if (key == ' ') {
    fire() ; 
  }  
  if (key == CODED) {
     switch (keyCode) {
       case LEFT :
         movingLeft = true ;
         break ;
       case RIGHT :
         movingRight = true ;
         break ;
     }
  }
}
void keyReleased() {
  if (key == CODED) {
     switch (keyCode) {
       case LEFT :
         movingLeft = false ;
         break ;
       case RIGHT :
         movingRight = false ;
         break ;
     }
  }  
}

// initiate firing, if missile not already there.
// Can you support firing multiple missiles?
void fire() {
  if (!firing) {
    missile.reset(player.getX() + player.playerWidth/MISSILE_WIDTH_PROPORTION,
                  player.getY() - player.playerHeight/MISSILE_WIDTH_PROPORTION) ;
    firing = true ;
  }
}
