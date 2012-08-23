// Lectures in Graphics (LiG): sketch003
// Author(s): Kyle Harrigan, Donnie Smith               *** replace my name with yours and delete this guideline
// Subject: Template for class projects      *** replacwe with Project XXX: Project title
// Class: CS6491                   *** delete the wrong class number
// Last update on: August 22, 2012           *** update date of last modification
// Usage: press 'r' to see rows
//        click&drag mouse horizontally to change number of disks
// Contains: tools for using colors, images, screen (help) text                      *** update as needed
// Comments: Demonstrates loops, classes, 2D transforms                              *** update as needed

//**************************** global variables ****************************
Boolean scribeText=true; // toggle for displaying of help text
int n=20; 
float n_float=20; // number of disks shown, float is used to provide smooth mouse-drag edit of n
int unlocked=0;
// color variables are defined in the "utilities" tab and set in "defineColors" during initialization


//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(800, 600);            // canvas size
  disks1 = new ArrayList();
  disks2 = new ArrayList();
  loadDiskConfig();
  myFace1 = loadImage("data/kwharrigan.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  defineMyColors(); // sets HSB color mode and THEN defines values for color variables
}


//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  setTurnText(turn);
  displayDisks(); 
  pen(black, 3); // sets stroke color (to balck) and width (to 3 pixels)
  float r=width/(n+3); // radius of disks initialized to fill width of screen
  drawDividers(); // Draw a divider for player1/player2 spaces
  if (keyPressed && key=='r') { // if a key is pressed and the last key action was to press 'r'
    pushMatrix();
    translate(r, height/2);
    for (int j=0; j<4; j++) { // shows 4 rows
      ramp.setTo(red_hue, green_hue, saturated*(j+1)/5, light); // sets a different ramp
      pushMatrix(); // save previous frame to avoid residual translation
      for (int i=0; i<n; i++) { // paints row of disks
        translate(r, 0); // translate local frame to the right by r
        fill(ramp.at(i, n)); // set color using color i in a ramp of n colors 
        showDisk(0, 0, r-2); // shows disk of radius r-2 at origin of local frame
      } 
      popMatrix(); // restores saved frame, canceling all translations to the right
      translate(0, r*2);
    }
    popMatrix();
  }
  else { // SHOW SPIRAL 


    // shows mouse location or whether mouse is pressed an d which key is pressed               
    if (mousePressed) {
      disk D;
      float d=999999.0;
      int min_idx = -1;
      if (unlocked== 1) {
        for (int i=0; i < disks1.size(); i++) {
          if (turn == 0) {
            D = (disk) disks1.get(i);
          }
          else {
            D = (disk) disks2.get(i);
          }

          float tmpd = D.dis_ctr_to_mouse();
          if (tmpd < d & tmpd < 100) {
            d =  tmpd;
            min_idx=i;
          }
        }
      }

      if (min_idx > -1) {
        // Move that disk 
        if (turn == 0) {
          D = (disk) disks1.get(min_idx);
          D.set_center_to_mouse();
        }
        else if (turn == 1) {
          D = (disk) disks2.get(min_idx);
          D.set_center_to_mouse();
        }
      }
    }
    if (keyPressed) {
      fill(black); 
      text(str(key), mouseX-2, mouseY);
    }
    if (!mousePressed && !keyPressed) {
      unlocked=1;
      scribeMouseCoordinates();
    }

    //****************************** add your code here to display the two spirals ***************



    //************ submit your code (above) on paper (with your name and screen snap shot with your face) at the beginning of lecture on due date
  }

  if (scribeText) displayTextImage();
}  // end of draw()


// User actions
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
  // till it is released or another key is pressed or released
  if (key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if (key=='!') snapPicture(); // make a picture of the canvas
  if (key=='+') {
    n++; 
    n_float=n;
  }  // increment n and sets n_float in case it is dragged with a continuous motion of the mouse
  if (key=='-') if (n>=0) {
    n--; 
    n_float=n;
  }  // decrements n
  if (key=='d') {
    if (turn == 0){
      turn += 1;
    }
    else if (turn == 1){
      turn = 2;
      println("Game over, score both players");
    }
      
  }
  if (key=='Q') exit();  // quit application
}


void mouseDragged() { // executed when mouse is pressed and moved
  n_float+=20.*(mouseX-pmouseX)/width; // updates float value of n
  if (n_float>0) n=round(n_float);  // snaps n to closest int
}


// EDIT WITH PROPER CLASS, PROJECT, STUDENT'S NAME, AND DESCRIPTION OF ACTION KEYS ***************************
String title ="CS6491 Fall 2012, Project 1: Packing", name1 ="Kyle Harrigan", name2="Donnie Smith", 
menu="?:help(on/off), !:snapPicure,  r: to see ramp, d: player done with turn, Q:quit", 
guide="press&drag mouse right/left to move disks"; // help info

void displayDisks() {
  for (int i=0; i<disks1.size(); i++)
  {
    disk theDisk = (disk) disks1.get(i);
    theDisk.show();
  }
  for (int i=0; i<disks2.size(); i++)
  {
    disk theDisk = (disk) disks2.get(i);
    theDisk.show();
  }
}

