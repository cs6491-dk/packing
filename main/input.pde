class MouseController {
  Disk current_disk = null;
  ArrayList disks = null;

  void set_turn() {
    if (turn == 0) disks = disks1;
    else disks = disks2;
    current_disk = null;
  }

  void update() {
    if (!mousePressed) {
      current_disk = null;
    }
    else {
      Disk D;
      float d=1e10;
      if (current_disk == null) {
        for (int i=0; i < disks.size(); i++) {
          D = (Disk) disks.get(i);
          float tmpd = D.dis_ctr_to_mouse();
          if (tmpd < d && tmpd < 100) {
            d = tmpd;
            current_disk = D;
          }
        }
      }

      if (current_disk != null) current_disk.set_center_to_mouse();
    }
  }
}
