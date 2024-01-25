final class Meteor extends Projectile { 
  final int SPLIT_Y_VELOCITY = -1;
  final int SPLIT_X_VELOCITY_VARIANCE = 5;
  final int MAX_SPLITS = 4;
  color trajectoryColour = #810000;
  
  Meteor(int x, int y, int radius, int xVelocity, int yVelocity, int mass) {
    super(x, y, radius, xVelocity, yVelocity, mass);
    this.setTrajectoryColour(trajectoryColour);
  }

  ArrayList<Meteor> split(float waveGravity) {
    int numSplits = (int)random(2,MAX_SPLITS+1);
    ArrayList<Meteor> meteors = new ArrayList<Meteor>();
    for (int i = 0; i < numSplits; i++) {
      int newXVelocity = (int)random(SPLIT_X_VELOCITY_VARIANCE*-1, SPLIT_X_VELOCITY_VARIANCE + 1);
      // -1 yVelocity to make split meteors bounce
      Meteor meteor = new Meteor((int)position.x, (int)position.y, missileRadius, newXVelocity, SPLIT_Y_VELOCITY, mass/2);
      meteor.setGravitationalForce(waveGravity);
      meteors.add(meteor);
    }
    return meteors;
  }
}
