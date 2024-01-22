final class EnemyMissile extends Projectile { 
  color trajectoryColour = #810000;
  
  EnemyMissile(int x, int y, int missileRadius, int xVelocity, int yVelocity, int mass) {
    super(x, y, missileRadius, xVelocity, yVelocity, mass);
    this.setTrajectoryColour(trajectoryColour);
  }
}
