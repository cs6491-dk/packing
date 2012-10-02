class Disk {
  float x=0, y=0, r=10;
  Vector<Integer> collisions;
  
  Disk(float px, float py, float pr) {r=pr; x=px; y=py; collisions = new Vector<Integer>();}
  Disk set_radius_to_mouse() {r=sqrt(sq(x-mouseX)+sq(y-mouseY)); return this;}
  Disk set_center_to_mouse() {x=mouseX; y=mouseY; return this;}
  Disk set_center(float newX, float newY) {x=newX; y=newY; return this;}
  float get_x(){return x;}
  void  set_y(float val){y = val;}
  float get_y(){return y;}
  float get_r(){return r;}
  void collide(int disk_idx){ if (!collisions.contains(disk_idx)) collisions.add(disk_idx);}
  void uncollide(int disk_idx){if (collisions.contains(disk_idx)){println("uncollide"); collisions.removeElement(disk_idx);}}
  Vector get_collisions(){return collisions;}
  void print_collisions(){
    //print("Current collisions: "); for (int i=0; i < collisions.size(); i++) print(collisions.get(i)+","); println();
  }
  Disk show() {strokeWeight(1); fill(0, 255, 255); ellipse(x, y, 2*r, 2*r);return this;}
  Disk show_outline() {strokeWeight(1); noFill(); ellipse(x, y, 2*r, 2*r);text("Current Radius: " + r, x-r/2,y+r+10); return this;}
  Disk show_bounding() {strokeWeight(5); noFill(); ellipse(x, y, 2*r, 2*r);return this;}
  float dis_ctr_to_mouse() {return sqrt(sq(x-mouseX)+sq(y-mouseY));}
  float dis_border_to_mouse() {return abs(dis_ctr_to_mouse()-r);}
  }

class Disks {
   // Arraylist of disks
   ArrayList<Disk> disks;
   Disks() {disks = new ArrayList();}
   void sort(){
       println("Sorting disks by radius, biggest to smallest");
         Collections.sort(disks,new Comparator<Disk>() {
            public int compare(Disk disk1, Disk disk2) {
                return (int)(disk2.get_r() - disk1.get_r());
            }
        });
        for (int i=0; i < disks.size(); i++){
           Disk tmp = disks.get(i);
           tmp.set_y(25*(i+1)); 
        }
        
   }
   boolean enclosedby(Disk testdisk)
   { // Test to see if a given disks encloses all disks
       float dx, dy, d;
       for (int i=0; i < disks.size(); i++){
          Disk tmp = disks.get(i);
          dx = tmp.x-testdisk.x;
          dy = tmp.y-testdisk.y;
          d = sqrt(dx*dx+dy*dy);
          if (d > abs(tmp.r-testdisk.r)){
            println(i + " failed");
            return false;      
          }
       }
       return true;
   }
   void add(Disk toadd){disks.add(toadd);};
   Disk get(int position){return disks.get(position);}
   int size(){return disks.size();}
  
  
}
// ************************************************************************ CONFIGURATION
int numDisks=0;
String line;
BufferedReader reader;

void loadDiskConfig(){
  println("Loading disk config...");
  reader = createReader("data/disk_config.txt"); 
  boolean reading = true;
  int ct=0; 
  float rad;
  while (reading)
  {
    try
    {
      line = reader.readLine();
      ct += 1;
      if (line == null){
        reading = false;
      }
      else if (ct == 1) {
           numDisks = int(line);
           println("There are " + numDisks + " disks"); 
      }
      else {
      // Read a disk
         rad = float(line);
         disks1.add(new Disk(380, ct*50, rad));
         disks2.add(new Disk(420, ct*50, rad));
         println("Disk of size: "+rad + " added");
      }
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
      line = null;
      reading = false;
    }
  }
}
