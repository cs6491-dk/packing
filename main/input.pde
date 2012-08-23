class MouseController {
  ArrayList disks = null;
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
          D = (Disk) disks.get(i);
          float tmpd = D.dis_ctr_to_mouse();
          if (tmpd < d && tmpd < 100) {
            d = tmpd;
            current_disk_idx = i;
          }
        }
      }

      if (current_disk_idx != -1) {
        Disk current_disk = (Disk) disks.get(current_disk_idx);
        float x = mouseX, y = mouseY;
        if (turn == 0) x = min(mouseX, width/2-current_disk.r);
        else x = max(mouseX, width/2+current_disk.r);
        current_disk.set_center(x,y);
      }
    }
  }
}
