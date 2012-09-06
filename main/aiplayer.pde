class AIPlayer {
  float center_x, center_y;
  float angle = 0, center_r = 40;
  float init_r=100, dt=0.01;
  float da = dt*10;
  float min_r, min_x, min_y;
  float[][] min_centers;
  int iters=0, max_iters=2000, settle_iters=0;
  Disks disks;
  int s;
  AIPlayer(float x, float y, Disks my_disks) {center_x=x; center_y = y; disks = my_disks;}

  Boolean update() {
    return physics_update();
  }

  Boolean physics_update() {
    Disk cursor;
    // Initialization: spread the disks out in a circular pattern
    if (iters == 0) {
      s = disks.size();
      float a;
      for (int i=0; i < s; i++) {
        cursor = disks.get(i);
        a = TWO_PI/s * i;
        cursor.set_center(center_x + init_r*cos(a), center_y + init_r*sin(a));
      }
      cursor = minbound(disks);
      min_r = cursor.r;
      min_r_seen = min_r;
      min_x = center_x;
      min_y = center_y;
      min_centers = new float[s][2];
      for (int i=0; i < s; i++) {
        cursor = disks.get(i);
        min_centers[i][0] = cursor.x;
        min_centers[i][1] = cursor.y;
      }
    }
    else if (iters <= max_iters) {
      // Move the center of "gravity" around in a circle to shake things up
      angle = (angle + da) % TWO_PI;
      float x = center_x + center_r*cos(angle), y = center_y + center_r*sin(angle);

      do_physics(x, y);

      cursor = minbound(disks);
      if (cursor.r < min_r) {
        min_r = cursor.r;
        min_r_seen = min_r;
        min_x = x;
        min_y = y;
        for (int i=0; i < s; i++) {
          cursor = disks.get(i);
          min_centers[i][0] = cursor.x;
          min_centers[i][1] = cursor.y;
        }
      }

      if (iters == max_iters) {
        for (int i=0; i < s; i++) {
          cursor = disks.get(i);
          cursor.set_center(min_centers[i][0], min_centers[i][1]);
        }
      }
    }
    else if (iters <= max_iters + settle_iters) {
      do_physics(min_x, min_y);
    }

    iters++;
    return iters > (max_iters + settle_iters);
  }

  void do_physics(float x, float y) {
    float dx, dy, n;
    float[] r = new float[s];
    Disk cursor, cursor2;

    // Apply "gravity"
    for (int i=0; i < s; i++) {
      cursor = disks.get(i);
      dx = x - cursor.x;
      dy = y - cursor.y;
      // Alter the equation for "gravity" here
      cursor.set_center(cursor.x + dx*sq(cursor.r)/20*dt,
                        cursor.y + dy*sq(cursor.r)/20*dt);
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
  }
}
