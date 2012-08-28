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
        for (int i=0; i < disks.size(); i++) 
        {
          current_disk.print_collisions(); 
          if (i != current_disk_idx) {
            other_disk =  disks.get(i);
            float dx = x - other_disk.x,
                  dy = y - other_disk.y,
                  r = current_disk.r + other_disk.r;
                  float n;
            if (dx*dx + dy*dy < r*r) 
            {
              n = sqrt(dx*dx + dy*dy);
              println("Collision with disk " + (i+1));
              current_disk.collide(i);
              dx = x - other_disk.x;
              dy = y - other_disk.y;          
              x = other_disk.x + dx/n*r;
              y = other_disk.y + dy/n*r;   
              
                  // Handle 2 collisions.. need to generalize to n collisions
              Vector<Integer> collisions = current_disk.get_collisions();
              if (collisions.size() == 2)
              {
                println("Collision size of 2 detected");
                float ra, rb, a, h, p2x, p2y;
                Disk disk1 = disks.get(collisions.get(0));
                Disk disk2 = disks.get(collisions.get(1));
                
                // The solution is simply the intersection of two circles, each inflated by the radius of the third
                // A good example of the solution for this is http://paulbourke.net/geometry/2circle/
                
                ra = disk1.r + current_disk.r;
                rb = disk2.r + current_disk.r;
                dx = disk1.x-disk2.x;
                dy = disk1.y-disk2.y;
                d = sqrt(dx*dx+dy*dy);
                a = (ra*ra-rb*rb+d*d)/(2*d);
                h = sqrt(ra*ra-a*a);
                p2x = disk1.x + a*(disk2.x-disk1.x)/d;
                p2y = disk1.y + a*(disk2.y-disk1.y)/d;
                
                x = p2x + h*(disk1.y-disk2.y)/d;
                y = p2y - h*(disk1.x-disk2.x)/d;
                print ("d, ra, rb : " + d + " " + ra + " " + rb);
                println("Disk2 x,y is: " + disk2.x + "," + disk2.y);
                println("Current x,y is: " + current_disk.x + "," + current_disk.y);
                println("Setting x,y to: " + x + "," + y);
                             
              } 
            }
            else if (dx*dx + dy*dy > r*r)
            {
              //println("Uncollide");
              current_disk.uncollide(i);
            }
          } 
        }

        current_disk.set_center(x,y);
      }
    }
  }
}
