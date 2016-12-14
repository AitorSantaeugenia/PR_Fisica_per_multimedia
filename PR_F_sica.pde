//:::::::::::::::: VARIABLES ::::::::::::::::
//variables del projectil incial
float pos_X;
float pos_Y;
float vel_X = 0;
float vel_Y = -90;

//variables projectil 1
float pos_1X;
float pos_1Y;
float vel_1X;
float vel_1Y;

//variables projectil 2
float pos_2X;
float pos_2Y;
float vel_2X;
float vel_2Y;

//massa total del projectil inicial
float massaT = 5;
//massa del projectil 1
float massa1 = 2;
//float massa2;

//variables pel projectil inicial i els posteriors trossos
PShape projectil;
PShape tros1;
PShape tros2;

//variable booleana pel run per tal de fer click posteriorment
boolean run = false;
boolean text = false;                  //Text explosió

//Variable per poder escriure text
PFont f;  
int startTime;                        //Inici temps
final int DISPLAY_DURATION = 1000;    //Temps duració del text "Boom!" de un segon

//boolean rectOver = false; //Variable botó iniciar

//:::::::::::::::: INICIALITZAR ::::::::::::::::
void iniciPrograma() {
      //Inicialitzem els trossos al centre de la escena
      pos_X = width/2;       
      pos_Y = height;        
      pos_1X = width/2;      
      pos_1Y = height;       
      pos_2X = width/2;      
      pos_2Y = height;       
      //Velocitat dels trossos (90 m/s)
      vel_X = 0;            
      vel_Y = -90;            
      vel_1X = 0;            
      vel_1Y = -90;         
      vel_2X = 0;            
      vel_2Y = -90;          
  }
  
//:::::::::::::::: RUN() ::::::::::::::::
//En el moment del click, tindrem que fer que els trossos canviïn de velocitat
void run() {
   //Velocitat en eix X d'un tros es 30 m/s
   //Velocitat en eix Y meitat del projectil en el moment de l'explosió i en sentit contrari
   vel_1X = 30;
   vel_1Y = -vel_Y/2;
   
   //Mt·Vt=M1·V1+M2·V2
   vel_2X = ( (massaT * vel_X) - (massa1 * vel_1X) ) / massaT-massa1;
   vel_2Y = ( (massaT * vel_Y) - (massa1 * vel_1Y) ) / massaT-massa1;
   
   //Canviam la variable text (per el Boom!) al fer click de ratolí (on aquest ens du al run() )
   //Si no posam això, el Boom! sen's quedarà si inicialitzem de nou (es a dir, si clicam altre cop amb el ratolí, el boom apareixerà en el tros total)
   text = true;
  }

//Posicionar els objectes tenint en compte la velocitat d'aquests
float posicio (float posicio, float velocitat) {
  return posicio + velocitat/60;                        //60 frames = 1 segon en processing
  }

//Modifiquem la velocitat dels trossos en l'eix Y
float velocitatgrav (float velocitat) {
  return velocitat + 9.8/60;                           //60 frames = 1 segon en processing
  }

//:::::::::::::::: SETUP ::::::::::::::::
void setup() {
  size (600,500);                                                    //Mida pantalla
  iniciPrograma();                                                   //Inicialitzam programa
  projectil =  createShape(ELLIPSE,0,0,18,18);                       //Cercle total
  tros1 = createShape(ELLIPSE,0,0,8,8);                            //Tros 1
  tros2 = createShape(ELLIPSE,0,0,10,10);                            //Tros 2
  //noCursor(); prova per no deixar ratolí en pantalla, varem estar provant amb un botó pero ho varem descartar
  noStroke();
  smooth();
  
  //Tipus de font per f i posterior text
  f = createFont("Arial", 12, true);
  
  //Càlcul de la massa del segon tros (massa total - massa tros 1)
  //massa2 = massaT - massa1;
}

//:::::::::::::::: DRAW ::::::::::::::::
void draw() {
  background(232,10);                      //Color del fons del programa
  //rect(0,0,width,height);
  
  //Modifiquem la velocitat de tots els trossos
  vel_Y = velocitatgrav (vel_Y);
  vel_1Y = velocitatgrav (vel_1Y);
  vel_2Y = velocitatgrav (vel_2Y);

  //Tornem a posicionar els trossos segons les velocitats amb la funcio posicio()
  pos_X = posicio(pos_X,vel_X);
  pos_Y = posicio(pos_Y,vel_Y);
  pos_1X = posicio(pos_1X,vel_1X);
  pos_1Y = posicio(pos_1Y,vel_1Y);
  pos_2X = posicio(pos_2X,vel_2X);
  pos_2Y = posicio(pos_2Y,vel_2Y);

  //Això ho empram per escriure el text en pantalla
  textFont(f);                                                          //Variable per el text F
  textAlign(CENTER);                                                    //Centram el text
  text("Practica de l'assignatura de Física", width/2, 20);               //Posicionam els textos al centre
  text("Universitat Oberta de Catalunya", width/2, 35);
  textAlign(LEFT);                                                      //Posicionam a la dreta (posa esquerre, pero realment ho posam a la dreta)
  text("Aitor Javier Santaeugenia Marí", width/2+100, height-20);          //A la dreta
  fill(0);                                                              //Color negre

  //Dibuixam el tros si no ha esplotat, o els trossos si ja ha explotat
  if (!run) {
      shape(projectil,pos_X,pos_Y);                                     //Dibuixam el tros
      
    }
  else{
      shape(tros1,pos_1X, pos_1Y);                                      //Dibuixam els dos trossos després de la explosió
      shape(tros2,pos_2X, pos_2Y);
    }
  
  //La variable text, la posicionam
  if(text){
       text("Boom!", pos_X, pos_Y);
      //Calculem el temps en que ha de aparèixer
      if (millis() - startTime > DISPLAY_DURATION){
        //Aturam de mostrar el text
        text = false;
  }
  }

  }

//:::::::::::::::: RUN ::::::::::::::::
/* Si clicam al ratolí el projectil explotará, i si tornam a clicar, s'iniciarà el programa de nou */
void mousePressed() {                                                   //Canviem la variable del text per tal de que no apareixi al clicar el ratolí i només ho faci
  text=false;                                                           //al explotar els dos trossos
  startTime = millis();                                                 //calculem el temps que porta
 if(run==false){                                                        //Si no ha explotat, iniciem la exploció amb la cridada a run()
    run();      
  }else{                                                                //Si ja ha explotat, cridem a iniciarPrograma() altre cop
    iniciPrograma();          
  }
  
  if(run){                                                              //Obliguem a la modificació de la variable run, sinó no es podría reinicialitzar
    run = false;
  }else{
    run = true;
  }
}

/* :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                                  TESTING
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
// PAC anterior exemple parabola
    fill (0, 0, 0);
    ellipse (ball_x1, ball_y, ball_radius/2, ball_radius/2);
    //ellipse (ball_x, ball_y, ball_radius, ball_radius);
    ball_x1 = ball_x0 - v_02*cos(angle)*time1 ;
    ball_y = ball_y + v_1*sin(angle)*time1 +g/2*sq(time1) ;
    time1 = time1 + 0.007;  
  
// Creació botó inicialitzar
void update(int x, int y) {
  if ( overRect(rectX, rectY, rectSize, rectSize) ) {
    rectOver = true;
  } else {
    rectOver = false;
  }
}

void mousePressed() {
  if (rectOver) {
    currentColor = rectColor;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
} 
*/