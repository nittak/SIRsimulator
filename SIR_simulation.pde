import controlP5.*;

ControlP5 cp5;
int susceptible = 4;  // 初期の感受性個体数
int infected = 2;     // 初期の感染者数
int recovered = 0;    // 初期の回復者数

Simulation simulation;

void setup() {
  size(1000, 600);

  cp5 = new ControlP5(this);

  cp5.addSlider("susceptible")
     .setPosition(50, 50)
     .setRange(0, 6) // Sの範囲設定
     .setValue(susceptible);

  cp5.addSlider("infected")
     .setPosition(50, 100)
     .setRange(0, 6) // Iの範囲設定
     .setValue(infected);

  cp5.addSlider("recovered")
     .setPosition(50, 150)
     .setRange(0, 6) // Rの範囲設定
     .setValue(recovered);

  cp5.addButton("startSimulation")
     .setPosition(50, 200)
     .setSize(100, 30)
     .setLabel("Start Simulation");

  simulation = new Simulation(susceptible, infected, recovered, 500, 0.5, 0.1);
}

void draw() {
  background(255);

  fill(0);
  textSize(16);
  text("Susceptible", 200, 65);
  text("Infected", 200, 115);
  text("Recovered", 200, 165);

  simulation.display();
}

void startSimulation() {
  simulation = new Simulation(susceptible, infected, recovered, 500, 0.5, 0.1);
}

class Simulation {
  int totalPopulation; // 総人口
  int numSteps;        // シミュレーションのステップ数
  float beta;          // 感染率
  float gamma;         // 回復率

  float[] S;           // 感受性のある個体
  float[] I;           // 感染者
  float[] R;           // 回復者

  int margin = 70;
  int graphWidth;
  int graphHeight;
  int graphStartX = 300;

  Simulation(int susceptible, int infected, int recovered, int numSteps, float beta, float gamma) {
    this.totalPopulation = susceptible + infected + recovered;
    this.numSteps = numSteps;
    this.beta = beta;
    this.gamma = gamma;

    graphWidth = width - graphStartX - margin;
    graphHeight = height - 2 * margin;

    S = new float[numSteps];
    I = new float[numSteps];
    R = new float[numSteps];

    // 初期条件
    S[0] = susceptible;
    I[0] = infected;
    R[0] = recovered;

    for (int t = 1; t < numSteps; t++) {
      float s = S[t-1] / totalPopulation;
      float i = I[t-1] / totalPopulation;

      S[t] = S[t-1] - beta * s * i * totalPopulation * 0.1;
      I[t] = I[t-1] + (beta * s * i - gamma * i) * totalPopulation * 0.1;
      R[t] = R[t-1] + gamma * i * totalPopulation * 0.1;

      S[t] = max(S[t], 0);
      I[t] = max(I[t], 0);
      R[t] = max(R[t], 0);
    }
  }
  
  void display() {
    stroke(0);
    line(graphStartX, height - margin, graphStartX + graphWidth, height - margin); // X軸
    line(graphStartX, height - margin, graphStartX, margin); // Y軸

    for (int i = 0; i <= totalPopulation; i++) {
      float y = map(i, 0, totalPopulation, height - margin, margin);
      stroke(200);
      line(graphStartX, y, graphStartX + graphWidth, y); // 横方向の補助線
      stroke(0);
      textAlign(RIGHT, CENTER);
      text(i, graphStartX - 10, y);
    }
    for (int t = 0; t <= numSteps; t += 100) {
      float x = map(t, 0, numSteps, graphStartX, graphStartX + graphWidth);
      stroke(200);
      line(x, height - margin, x, margin);
      stroke(0);
      textAlign(CENTER, TOP);
      text(t, x, height - margin + 10);
    }
    for (int t = 1; t < numSteps; t++) {
      float x1 = map(t - 1, 0, numSteps, graphStartX, graphStartX + graphWidth);
      float x2 = map(t, 0, numSteps, graphStartX, graphStartX + graphWidth);

      stroke(0, 200, 0); // S
      line(x1, map(S[t-1], 0, totalPopulation, height - margin, margin),
           x2, map(S[t], 0, totalPopulation, height - margin, margin));

      stroke(255, 0, 0); // I
      line(x1, map(I[t-1], 0, totalPopulation, height - margin, margin),
           x2, map(I[t], 0, totalPopulation, height - margin, margin));

      stroke(0, 0, 255); // R
      line(x1, map(R[t-1], 0, totalPopulation, height - margin, margin),
           x2, map(R[t], 0, totalPopulation, height - margin, margin));
    }

    fill(0);
    textSize(12);
    textAlign(LEFT, CENTER);
    text("S: Green (Susceptible)", graphStartX + 10, margin - 30);
    text("I: Red (Infected)", graphStartX + 10, margin - 10);
    text("R: Blue (Recovered)", graphStartX + 10, margin + 10);
    textSize(14);
    textAlign(CENTER, TOP);
    text("Time (steps)", graphStartX + graphWidth / 2, height - margin + 30);
    textAlign(CENTER, CENTER);
    pushMatrix();
    translate(graphStartX - 40, height / 2);
    rotate(-HALF_PI);
    text("Population (people)", 0, 0);
    popMatrix();
  }
}

// Tokyo Version
//int totalPopulation = 14000000;  // 東京都の総人口
//int susceptible = 13999900;      // 初期の感受性個体数
//int infected = 100;              // 初期の感染者数
//int recovered = 0;               // 初期の回復者数

//Simulation simulation;

//void setup() {
//  size(1000, 600);

//  simulation = new Simulation(susceptible, infected, recovered, 500, 0.5, 0.1);
//}

//void draw() {
//  background(255);

//  simulation.display();
//}

//class Simulation {
//  int totalPopulation; // 総人口
//  int numSteps;        // シミュレーションのステップ数
//  float beta;          // 感染率
//  float gamma;         // 回復率

//  float[] S;           // 感受性のある個体
//  float[] I;           // 感染者
//  float[] R;           // 回復者

//  int margin = 70;
//  int graphWidth;
//  int graphHeight;
//  int graphStartX = 300;
  
//  Simulation(int susceptible, int infected, int recovered, int numSteps, float beta, float gamma) {
//    this.totalPopulation = susceptible + infected + recovered;
//    this.numSteps = numSteps;
//    this.beta = beta;
//    this.gamma = gamma;

//    graphWidth = width - graphStartX - margin;
//    graphHeight = height - 2 * margin;

//    S = new float[numSteps];
//    I = new float[numSteps];
//    R = new float[numSteps];

//    S[0] = susceptible;
//    I[0] = infected;
//    R[0] = recovered;

//    for (int t = 1; t < numSteps; t++) {
//      float s = S[t-1] / totalPopulation;
//      float i = I[t-1] / totalPopulation;

//      S[t] = S[t-1] - beta * s * i * totalPopulation * 0.1;
//      I[t] = I[t-1] + (beta * s * i - gamma * i) * totalPopulation * 0.1;
//      R[t] = R[t-1] + gamma * i * totalPopulation * 0.1;

//      S[t] = max(S[t], 0);
//      I[t] = max(I[t], 0);
//      R[t] = max(R[t], 0);
//    }
//  }

//  void display() {
//    stroke(0);
//    line(graphStartX, height - margin, graphStartX + graphWidth, height - margin); // X軸
//    line(graphStartX, height - margin, graphStartX, margin); // Y軸

//    for (int i = 0; i <= totalPopulation; i += totalPopulation / 10) {
//      float y = map(i, 0, totalPopulation, height - margin, margin);
//      stroke(200);
//      line(graphStartX, y, graphStartX + graphWidth, y);
//      stroke(0);
//      textAlign(RIGHT, CENTER);
//      text(i, graphStartX - 10, y);
//    }

//    for (int t = 0; t <= numSteps; t += 100) {
//      float x = map(t, 0, numSteps, graphStartX, graphStartX + graphWidth);
//      stroke(200);
//      line(x, height - margin, x, margin);
//      stroke(0);
//      textAlign(CENTER, TOP);
//      text(t, x, height - margin + 10);
//    }

//    for (int t = 1; t < numSteps; t++) {
//      float x1 = map(t - 1, 0, numSteps, graphStartX, graphStartX + graphWidth);
//      float x2 = map(t, 0, numSteps, graphStartX, graphStartX + graphWidth);

//      stroke(0, 200, 0); // S
//      line(x1, map(S[t-1], 0, totalPopulation, height - margin, margin),
//           x2, map(S[t], 0, totalPopulation, height - margin, margin));

//      stroke(255, 0, 0); // I
//      line(x1, map(I[t-1], 0, totalPopulation, height - margin, margin),
//           x2, map(I[t], 0, totalPopulation, height - margin, margin));

//      stroke(0, 0, 255); // R
//      line(x1, map(R[t-1], 0, totalPopulation, height - margin, margin),
//           x2, map(R[t], 0, totalPopulation, height - margin, margin));
//    }

//    fill(0);
//    textSize(12);
//    textAlign(LEFT, CENTER);
//    text("S: Green (Susceptible)", graphStartX + 10, margin - 30);
//    text("I: Red (Infected)", graphStartX + 10, margin - 10);
//    text("R: Blue (Recovered)", graphStartX + 10, margin + 10);
//    textSize(14);
//    textAlign(CENTER, TOP);
//    text("Time (steps)", graphStartX + graphWidth / 2, height - margin + 30);
//    textAlign(CENTER, CENTER);
//    pushMatrix();
//    translate(graphStartX - 40, height / 2);
//    rotate(-HALF_PI);
//    text("Population (people)", 0, 0);
//    popMatrix();
//  }
//}
