class Disk {
  float x=0, y=0, r=10;
  Disk(float px, float py, float pr) {r=pr; x=px; y=py;}
  Disk set_radius_to_mouse() {r=sqrt(sq(x-mouseX)+sq(y-mouseY)); return this;}
  Disk set_center_to_mouse() {x=mouseX; y=mouseY; return this;}
  Disk set_center(float newX, float newY) {x=newX; y=newY; return this;}
  float get_x(){return x;}
  void  set_y(float val){y = val;}
  float get_y(){return y;}
  float get_r(){return r;}
  boolean contains(Disk testdisk){return false;}
  Disk show() {strokeWeight(1); fill(0, 255, 255); ellipse(x, y, 2*r, 2*r);return this;}
  Disk show_outline() {strokeWeight(1); noFill(); ellipse(x, y, 2*r, 2*r); return this;}
  float dis_ctr_to_mouse() {return sqrt(sq(x-mouseX)+sq(y-mouseY));}
  float dis_border_to_mouse() {return abs(dis_ctr_to_mouse()-r);}
  }

class Disks{
   // Arraylist of disks
   ArrayList disks;
   Disks() {disks = new ArrayList();}
   void sort(){
       println("Sorting disks by radius, biggest to smallest");
         Collections.sort(disks,new Comparator<Disk>() {
            public int compare(Disk disk1, Disk disk2) {
                return (int)(disk2.get_r() - disk1.get_r());
            }
        });
        for (int i=0; i < disks.size(); i++){
           Disk tmp = (Disk) disks.get(i);
          tmp.set_y(50*(i+1)); 
        }
        
   }
   void add(Disk toadd){disks.add(toadd);};
   Disk get(int position){return (Disk) disks.get(position);}
   int size(){return disks.size();}
  
  
}
// ************************************************************************ CONFIGURATION
int numDisks=0;
String line;
Disks disks1; // player 1 disks
Disks disks2; // player 2 disks
BufferedReader reader;
int turn=0; // player 1

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
