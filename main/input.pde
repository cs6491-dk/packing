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
                println("Two disk collision: ");
                float d12x, d12y, n12, n1c, n2c, angle, cx, cy, mcx, mcy;
                Disk disk1 = disks.get(collisions.get(0));
                Disk disk2 = disks.get(collisions.get(1));
                d12x = disk2.x - disk1.x;
                d12y = disk2.y - disk1.y;
                n12 = sqrt(d12x*d12x + d12y*d12y);
                n1c = disk1.r + current_disk.r;
                n2c = disk2.r + current_disk.r;
                dx = x - disk1.x;
                dy = y - disk1.y;
                // http://en.wikipedia.org/wiki/Law_of_cosines#Vector_formulation
                // Cos(C) = (a^2+b^2-c^2)/2*a*b
                angle = acos((n12*n12+n1c*n1c-n2c*n2c)/(2*n12*n1c));
                println("Angle: " + angle*180/PI);
                cx = disk1.x + d12x/n12*cos(angle)*(disk1.r+current_disk.r);
                cy = disk1.y + d12y/n12*cos(angle)*(disk1.r+current_disk.r);
                println("Solved value of c: " + cx + "," + cy);
                mcx = cx-x;
                mcy = cy-y;
                
                
                //x = disk1.x + dx/n12*cos(angle)*(disk1.r+current_disk.r);
                //y = disk1.y + dy/n12*cos(angle)*(disk1.r+current_disk.r);
                println("r1 r2 cdr = " +  disk1.r + "," + disk2.r + "," + current_disk.r);
                println("Disk1 xy = " + disk1.x + "," + disk1.y);
                println("Disk2 xy = " + disk2.x + "," + disk2.y);
                println("Current Disk xy = " + current_disk.x + "," + current_disk.y);               
                println("Setting x,y to ("+ x + "," + y + ")");            
              } 
            }
            else
            {
            current_disk.uncollide(i);
            }
          } 
        }

        current_disk.set_center(x,y);
      }
    }
  }
}
