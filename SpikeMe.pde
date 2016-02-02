import controlP5.*;

import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import peasy.*;
import java.util.List;

// GLOBAL DECLERATION
ControlP5 cp5;
PeasyCam cam; 
PImage img;
PGraphics pg;

HE_Mesh mesh;
WB_Render render;
WB_SelectRender3D selrender;
HE_Selection Zone; 
HE_Selection Spike; 
HE_Selection SELECTION;
HE_Face currFace;//walkling face
long lastFaceKey=0;
ArrayList<HE_Face>allFaces = new ArrayList<HE_Face>() ;
ArrayList<Long> allFaceKeys = new ArrayList<Long>();
ArrayList<Long> zoneFaceKeys = new ArrayList<Long>();
ArrayList<Long> spikeFaceKeys = new ArrayList<Long>();
float zf = -100; // z position below which zone is selected.
int counter =0;

//GUI 
boolean SET=false;
boolean GO;
boolean clearSelect;
boolean EXPORT;
boolean RECORD;
int Growth_size;
int Growth_popu;
int Smooth_step;
float pX;
float mX;
float pY;
float mY;
float pZ;
float mZ;

// SETUP
void setup() {

  size(1280, 720, P3D); //set canvas size
  cam = new PeasyCam(this, 200); //set cam object
  //smooth(4); //???

  // Import .obj file.
  //HEC_FromOBJFile creator=new HEC_FromOBJFile(sketchPath("meQuad.obj"));
  HEC_FromOBJFile creator=new HEC_FromOBJFile(sketchPath("Paul2_2k.obj"));
  //HEC_FromOBJFile creator=new HEC_FromOBJFile(sketchPath("AfroGiraffeQuad.obj"));

  // Creation of mesh from .obj data
  creator.setScale(250); 
  textureMode(NORMAL);
  mesh=new HE_Mesh(creator); // Creat mesh from imported data
  HET_Diagnosis.validate(mesh); //Mesh diagonisis - takes time for large mesh

    //selZone(); // Zone selection

  // Rendering
  selrender=new WB_SelectRender3D(this);
  render=new WB_Render(this);
  guiInit();
}

// DRAW LOOP
void draw() {

  //Set canvas environment
  background(255);
  lights();

  // position mesh
  rotateX(-PI/2);
  rotateY(PI);
  rotateZ(PI/6);

  gui();
  stroke(192, 192, 192);
  render.drawEdges(mesh); 

  if (!GO) {
    clearSel();
    //Btm
    fill(255, 10);
    beginShape();
    vertex(-100, -100, pZ);
    vertex(100, -100, pZ);
    vertex(100, pY, pZ);
    vertex(-100, pY, pZ);
    endShape(CLOSE);

    beginShape();
    vertex(-100, pY, pZ);
    vertex(100, pY, pZ);
    vertex(100, pY, 100);
    vertex(-100, pY, 100);
    endShape(CLOSE);

  }

  if (GO && counter<1) {
    selZone();
  }

  if (GO && counter<Growth_popu+Smooth_step) {
    //selZone();
    fill(255, 215, 0);
    render.drawFaces(Zone);
    Grow();
    print(counter);
    counter++;
  } 
  if (GO && counter>=Growth_popu+Smooth_step && counter<Growth_popu+Smooth_step+1) {
    selSpikeFace();

    counter++;
    SET=true;
  }

  if (GO && SET) {

    stroke(192, 192, 192);
    render.drawEdges(mesh); 
    fill(192, 192, 192);    
    render.drawFaces(mesh);    
    fill(255, 215, 0);
    render.drawFaces(Zone);
//    fill(255, 215, 192);
    render.drawFaces(Spike);    

  }
  
    if (RECORD) {
      saveFrame("indiaCC-######.png");
      //saveFrame("indiaCC-######.tif");
      //saveFrame("indiaCC-######.jpg");
    }

  /////////
}
//*******************************************
void keyPressed() {
  RECORD = !RECORD ;
}
//*******************************************
void Grow() {
  if (counter<Growth_popu) {
    tentGrow(); //grows tentecles
    fill(125);
    render.drawFaces(Zone);
    stroke(0);
    render.drawEdges(mesh);
    print("Check");
  } else if (counter>=Growth_popu && counter<=Growth_popu+Smooth_step) {
    print("Smooth");
    tentSmooth();
    fill(125);
    render.drawFaces(Zone);
    stroke(0);
    render.drawEdges(mesh);
  } else {
    //fill(192,192,192);
    //render.drawFaces(mesh);
    stroke(192, 192, 192);
    render.drawEdges(mesh);    
    fill(255, 215, 0);
    render.drawFaces(Zone);
    // Export when completed
    if (EXPORT) {
      HET_Export.saveToSTL(mesh, sketchPath(""), "indiaCC");
      HET_Export.saveToOBJ(mesh, sketchPath(""), "indiaCC"); 
      EXPORT = false;
    }
  }
  //print(Growth_size, Growth_popu, Smooth_step, Growth_popu, pX, mX, pY, mY, pZ, mZ);
}
//*******************************************
void selZone() {
  clearSel();
  // Storing All face as array list
  HE_FaceIterator fItr1 = mesh.fItr(); //??
  HE_Face f;

  // loop through all faces to store key in array list
  while (fItr1.hasNext ()) {
    f = fItr1.next(); // extracts faces from mesh
    allFaceKeys.add(f.key()); // add key to face key array
    if (lastFaceKey<f.key()) {
      lastFaceKey=f.key();
    }
    // Zone selection
    WB_Point CP = f.getFaceCenter(); // get center point of face
    //if ( CP.yf()>pY || CP.zf()>pZ ) {
    if ( CP.yf()>pY || CP.zf()<pZ ) {
      zoneFaceKeys.add(f.key()); // add key to face key zone array
    } else {
      // Do nothing
    }
  }

  //Pick mesh from zone faces
  Zone = new HE_Selection(mesh); 
  for (long number : zoneFaceKeys) {     
    Zone.add(mesh.getFaceByKey(number));
  }

  //print(zoneFaceKeys.size());
}
//*******************************************
void tentGrow() {
  SELECTION = new HE_Selection(mesh); 
  int randIndex=int(random(zoneFaceKeys.size()));
  SELECTION.add(mesh.getFaceByKey(zoneFaceKeys.get(randIndex)));
  int randDist = int(random(Growth_size));
  HEM_Extrude extrude = new HEM_Extrude().setDistance(randDist);
  mesh.modifySelected( extrude, SELECTION );

  fill(0, 255, 255);
  render.drawFaces(SELECTION);
  noFill();
}
//*******************************************
void tentSmooth() {
  SELECTION = new HE_Selection(mesh); 
  HEM_Smooth modifier=new HEM_Smooth();
  modifier.setIterations(1);//4,10
  mesh.modifySelected(modifier, Zone );
  //mesh.modify(modifier);

  fill(0, 255, 255);
  render.drawFaces(SELECTION);
  noFill();
}
//*******************************************
void mousePressed() {

  if (mouseX<guiOnlyX) {
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}
//******************************************
void clearSel() { 
  ArrayList<Long> zoneFaceKeys = new ArrayList<Long>();
  Zone = new HE_Selection(null); 
  Zone.cleanSelection();
  SELECTION = new HE_Selection(mesh); 
  SELECTION.cleanSelection();
}
//*******************************************
void selSpikeFace() {

  // Storing All face as array list
  HE_FaceIterator fItr1 = mesh.fItr(); //??
  HE_Face f;
  // loop through all faces to store key in array list
  while (fItr1.hasNext ()) {
    f = fItr1.next(); // extracts faces from mesh
    if (f.key()>lastFaceKey) {
      spikeFaceKeys.add(f.key()); // add key to face key array
    }

    //Pick mesh from zone faces
    Spike = new HE_Selection(mesh); 
    for (long number : spikeFaceKeys) {     
      Spike.add(mesh.getFaceByKey(number));
    }
  }
}

