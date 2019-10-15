float g_RepulsionRange = 15.0f;

float g_NeighbourIdealProximityMin = 1.0f;
float g_NeighbourIdealProximityMax = 10.0f;
float g_NeighbourIdealProximity = 3.0f;

boolean g_LimitIdealSpringDist = true;

float g_ChanceToAddNewNode = 0.04f;

float g_SpringConstant = 0.001f;
float g_SpringFrictionCoeff = 0.4f;

Curve g_Curve;

PVector center;

PVector up = new PVector(0, -1);
PVector right = new PVector(1, 0);
PVector down = new PVector(0, 1);
PVector left = new PVector(-1, 0);

void setup()
{
  size(1000, 1000);
  
  center = new PVector(width/2, height/2);
  
  g_Curve = new Curve();
  
  float idealSpringDist = g_NeighbourIdealProximity; 

  PVector nodeAPos = PVector.add(center, PVector.mult(up, idealSpringDist));
  
  PVector downRight = PVector.add(right, down);
  downRight.normalize();
  PVector nodeBPos = PVector.add(center, PVector.mult(downRight, idealSpringDist));
  
  PVector downLeft = PVector.add(left, down);
  downLeft.normalize();
  PVector nodeCPos = PVector.add(center, PVector.mult(downLeft, idealSpringDist));
  
  Node nodeA = new Node(nodeAPos, null, null);
  Node nodeB = new Node(nodeBPos, nodeA, null);
  Node nodeC = new Node(nodeCPos, nodeB, null);
  
  nodeC.m_Right = nodeA;
  nodeA.m_Left = nodeC;
  nodeA.m_Right = nodeB;
  nodeB.m_Right = nodeC;
  
  g_Curve.m_Nodes.add(nodeA);
  g_Curve.m_Nodes.add(nodeB);
  g_Curve.m_Nodes.add(nodeC);
}

void draw()
{
  background(255);
  
  stroke(0);
  
  g_Curve.Update();
  g_Curve.Display();
}
