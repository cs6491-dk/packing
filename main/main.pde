// Lectures in Graphics (LiG)
// Author(s): Kyle Harrigan, Donnie Smith
// Subject: Packing Game
// Class: CS6491
// Last update on: August 22, 2012
// Usage: press 'r' to see rows
//        click&drag mouse horizontally to change number of disks
// Contains: tools for using colors, images, screen (help) text
// Comments: Demonstrates loops, classes, 2D transforms

//**************************** global variables ****************************
Boolean scribeText=true; // toggle for displaying of help text
int n=20; 
float n_float=20; // number of disks shown, float is used to provide smooth mouse-drag edit of n
int unlocked=0;
String title ="CS6491 Fall 2012, Project 1: Packing", name1 ="Kyle Harrigan", name2="Donnie Smith", 
  menu="?:help(on/off), !:snapPicure,  r: to see ramp, d: player done with turn, Q:quit", 
  guide="press&drag mouse right/left to move disks"; // help info
// color variables are defined in the "utilities" tab and set in "defineColors" during initialization

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(800, 600);            // canvas size
  disks1 = new ArrayList();
  disks2 = new ArrayList();
  loadDiskConfig();
  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  myFace1 = loadImage("data/kwharrigan.jpg");
  // sets HSB color mode and THEN defines values for color variables
  defineMyColors();
}

//**************************** display current frame ****************************
// executed at each frame
void draw() {
  background(white);
  setTurnText(turn);
  displayDisks(); 
  pen(black, 3);
  drawDividers(); // Draw a divider for player1/player2 spaces

  // shows mouse location or whether mouse is pressed an d which key is pressed               
  if (mousePressed) {
    disk D;
    float d=999999.0;
    int min_idx = -1;
    if (unlocked == 1) {
      for (int i=0; i < disks1.size(); i++) {
        if (turn == 0) {
          D = (disk) disks1.get(i);
        }
        else {
          D = (disk) disks2.get(i);
        }
        float tmpd = D.dis_ctr_to_mouse();
        if (tmpd < d & tmpd < 100) {
          d = tmpd;
          min_idx = i;
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

  if (scribeText) displayTextImage();
}

// User actions
// executed each time a key is pressed: sets the "keyPressed" and "key" state variables,
// till it is released or another key is pressed or released
void keyPressed() {
  if (key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if (key=='!') snapPicture(); // make a picture of the canvas
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

