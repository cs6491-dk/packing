class AIPlayer {
  float center_x, center_y;
  float angle = 0, da = 0.1, center_r = 20;
  float init_r=100, dt=0.01;
  Disks disks;
  Boolean init=true, done=false;
  AIPlayer(float x, float y, Disks my_disks) {center_x=x; center_y = y; disks = my_disks;}

  Boolean update() {
    return physics_update();
  }

  Boolean physics_update() {
    Disk cursor, cursor2;
    // Initialization: spread the disks out in a circular pattern
    if (init) {
      int s = disks.size();
      float a;
      for (int i=0; i < s; i++) {
        cursor = disks.get(i);
        a = TWO_PI/s * i;
        cursor.set_center(center_x + init_r*cos(a), center_y + init_r*sin(a));
      }
      init = false;
    }
    else {
      // Move the center of "gravity" around in a circle to shake things up
      angle = (angle + da) % TWO_PI;
      float x = center_x + center_r*cos(angle), y = center_y + center_r*sin(angle);
      int s = disks.size();
      float dx, dy, n;
      float[][] f = new float[s][2];
      float[] r = new float[s];

      // Apply "gravity"
      for (int i=0; i < s; i++) {
        cursor = disks.get(i);
        dx = x - cursor.x;
        dy = y - cursor.y;
        n = sqrt(dx*dx + dy*dy);
        // Alter the equation for "gravity" here
        f[i][0] = 0.05*dx*sq(cursor.r);
        f[i][1] = 0.05*dy*sq(cursor.r);
        cursor.set_center(cursor.x + f[i][0]*dt, cursor.y + f[i][1]*dt);
        dx = x - cursor.x;
        dy = y - cursor.y;
        r[i] = sqrt(dx*dx + dy*dy);
      }

      // Sort by increasing radius from center of "gravity"
      float[] ordered_r = sort(r);
      int[] idx = new int[s];
      for (int i=0; i < s; i++) {
        for (int j=0; j < s; j++) {
          if (ordered_r[i] == r[j]) {
            idx[i] = j;
            r[j] = -1;
            continue;
          }
        }
      }

      // Do better math here
      // Explicitly compute collisions
      for (int i=0; i < s; i++) {
        cursor = disks.get(idx[i]);
        for (int j=0; j < i; j++) {
          cursor2 = disks.get(idx[j]);
          dx = cursor.x - cursor2.x;
          dy = cursor.y - cursor2.y;
          while ((dx*dx+dy*dy) <= sq(cursor.r + cursor2.r)) {
            //dx = cursor.x - x;
            //dy = cursor.y - y;
            // Is this the best direction?
            n = sqrt(sq(dx) + sq(dy));
            cursor.set_center(cursor.x + dx/n*0.1, cursor.y + dy/n*0.1);
            dx = cursor.x - cursor2.x;
            dy = cursor.y - cursor2.y;
          }
        }
      }

      // This is old code.
      // In the current state, this will probably never finish
      done = true;
      for (int i=0; i < s; i++) {
        if ((abs(f[i][0]) > 1e-1) || (abs(f[i][1]) > 1e-1)) {
          done = false;
        }
      }
    }
    return done;
  }
}
