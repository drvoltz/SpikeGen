//DBOT (Design Bulit On Technology) 
//Workshop : Creative Coding
//29-31 Jan 2016, Bangalore, India
//Course Tutor: Immanuel Koh
//www.immanuelkoh.net
//Copyrights

//boolean GO;
//boolean clearSelect;
//boolean EXPORT;
//boolean RECORD;
//int Growth_size;
//int Growth_popu;
//int Smooth_step;
//float pX;
//float mX;
//float pY;
//float mY;
//float pZ;
//float mZ;
int guiOnlyX = 220;


void guiInit() {
  cp5 = new ControlP5(this);

  cp5.addSlider("Growth_size")
    .setPosition(guiOnlyX*0.2, 50)
      .setSize(60, 20)
        .setRange(10, 200)
          .setValue(50)
            .setColorCaptionLabel(color(0))
              .setColorForeground(color(255))
                .setColorActive(color(255))
                  .setColorValueLabel(color(0))
                    ;
  cp5.addSlider("Growth_popu")
    .setPosition(guiOnlyX*0.2, 100)
      .setSize(60, 20)
        .setRange(0, 2000)
          .setValue(500)
            .setColorCaptionLabel(color(0))
              .setColorForeground(color(255))
                .setColorActive(color(255))
                  .setColorValueLabel(color(0))
                    ;
                    
  cp5.addSlider("Smooth_step")
    .setPosition(guiOnlyX*0.2, 150)
      .setSize(60, 20)
        .setRange(0, 5)
          .setValue(2)
            .setColorCaptionLabel(color(0))
              .setColorForeground(color(255))
                .setColorActive(color(255))
                  .setColorValueLabel(color(0))
                    ;

//  cp5.addSlider("pX")
//    .setPosition(guiOnlyX*0.2, 200)
//      .setSize(20, 60)
//        .setRange(-250, 250)
//          .setValue(0)
//            .setColorCaptionLabel(color(0))
//              .setColorForeground(color(255))
//                .setColorActive(color(255))
//                  .setColorValueLabel(color(0))
//                    ;
//  cp5.addSlider("mX")
//    .setPosition(guiOnlyX*0.6, 200)
//      .setSize(20, 60)
//        .setRange(-250, 250)
//          .setValue(0)
//            .setColorCaptionLabel(color(0))
//              .setColorForeground(color(255))
//                .setColorActive(color(255))
//                  .setColorValueLabel(color(0))
//                    ;    

  cp5.addSlider("pY")
    .setPosition(guiOnlyX*0.2, 200)
      .setSize(20, 60)
        .setRange(-250, 250)
          .setValue(0)
            .setColorCaptionLabel(color(0))
              .setColorForeground(color(255))
                .setColorActive(color(255))
                  .setColorValueLabel(color(0))
                    ;
//  cp5.addSlider("mY")
//    .setPosition(guiOnlyX*0.6, 300)
//      .setSize(20, 60)
//        .setRange(-250, 250)
//          .setValue(0)
//            .setColorCaptionLabel(color(0))
//              .setColorForeground(color(255))
//                .setColorActive(color(255))
//                  .setColorValueLabel(color(0))
//                    ;  
                    
  cp5.addSlider("pZ")
    .setPosition(guiOnlyX*0.6, 200)
      .setSize(20, 60)
        .setRange(-250, 250)
          .setValue(0)
            .setColorCaptionLabel(color(0))
              .setColorForeground(color(255))
                .setColorActive(color(255))
                  .setColorValueLabel(color(0))
                    ; 
//  cp5.addSlider("mZ")
//    .setPosition(guiOnlyX*0.6, 400)
//      .setSize(20, 60)
//        .setRange(-250, 250)
//          .setValue(0)
//            .setColorCaptionLabel(color(0))
//              .setColorForeground(color(255))
//                .setColorActive(color(255))
//                  .setColorValueLabel(color(0))
//                    ; 
//    cp5.addToggle("SET")
//    .setPosition(guiOnlyX*0.2, 500)
//      .setSize(50, 20)
//        .setValue(false)
//          .setMode(ControlP5.SWITCH)
//            .setColorCaptionLabel(color(0))
//              .setColorForeground(color(0))
//                .setColorActive(color(255))
//                  .setColorValueLabel(color(0))
//                    ;
     cp5.addToggle("RECORD")
    .setPosition(guiOnlyX*0.5, 300)
      .setSize(50, 20)
        .setValue(false)
          .setMode(ControlP5.SWITCH)
            .setColorCaptionLabel(color(0))
              .setColorForeground(color(0))
                .setColorActive(color(255))
                  .setColorValueLabel(color(0))
                    ;                   
  cp5.addBang("GO")
    .setPosition(guiOnlyX*0.2, 350)
      .setSize(80,40)
        .setColorCaptionLabel(color(0))
          .setColorForeground(color(0))
            .setColorActive(color(0,255,0))
              .setColorValueLabel(color(0))
                ;
      
                
  cp5.setAutoDraw(false);
}

void gui() {

  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  cp5.draw();
  pushStyle();
  stroke(0);
  strokeWeight(1);
  line(guiOnlyX, 0, guiOnlyX, height);

  popStyle();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);

  if (GO) {
//  print(Growth_size,Growth_popu,Smooth_step,Growth_popu,pX,mX,pY,mY,pZ,mZ);
  }
}
