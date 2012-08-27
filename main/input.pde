class MouseController {
  Disks disks = null;
  int current_disk_idx = -1;

  void set_turn() {
    if (turn == 0) disks = disks1;
    else disks = disks2;

    current_disk_idx = -1;
  }

  void update() {
    if (!mousePressed) {
      current_disk_idx = -1;
    }
    else {
      Disk D;
      float d=1e10;
      if (current_disk_idx == -1) {
        for (int i=0; i < disks.size(); i++) {
          D = disks.get(i);
          float tmpd = D.dis_ctr_to_mouse();
          if (tmpd < d && tmpd < 100) {
            d = tmpd;
            current_disk_idx = i;
          }
        }
      }

      if (current_disk_idx != -1) {
        Disk current_disk = disks.get(current_disk_idx);
        float x = mouseX, y = mouseY;

        // Limit to the current player's side
        if (turn == 0) x = min(mouseX, width/2-current_disk.r);
        else x = max(mouseX, width/2+current_disk.r);

		// Circle to Circle collision detection
        // Currently doesn't handle multiple collisions
        Disk other_disk;
        for (int i=0; i < disks.size(); i++) {
          if (i != current_disk_idx) {
            other_disk =  disks.get(i);
            float dx = x - other_disk.x,
                  dy = y - other_disk.y,
                  r = current_disk.r + other_disk.r;
            if (dx*dx + dy*dy < r*r) {
              float n = sqrt(dx*dx + dy*dy);
              x = other_disk.x + dx/n*r;
              y = other_disk.y + dy/n*r;
            }
          }
        }

        current_disk.set_center(x,y);
      }
    }
  }
}
