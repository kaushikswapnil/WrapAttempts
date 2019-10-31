float g_RepulsionRange = 15.0f;

float g_NeighbourIdealProximityMin = 1.0f;
float g_NeighbourIdealProximityMax = 10.0f;
float g_NeighbourIdealProximity = 3.0f;

boolean g_LimitIdealSpringDist = true;

float g_ChanceToAddNewNode = 0.04f;

float g_SpringConstant = 0.001f;
float g_SpringFrictionCoeff = 0.4f;

Curve g_Curve;
CurveConstructor g_CurveConstructor;

PVector center;

PVector up = new PVector(0, -1);
PVector right = new PVector(1, 0);
PVector down = new PVector(0, 1);
PVector left = new PVector(-1, 0);

int g_ProgramMode;

boolean g_IsEditorMode = false;

Button g_CPGButton;

int g_RenderFrameGap = 30;

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
  
  g_ProgramMode = 0;
  
  if (g_IsEditorMode)
  {
   g_CurveConstructor = new CurveConstructor();
   g_CPGButton = new ChangeProgramModeButton(20, 20); 
  }
}

void draw()
{
  switch(g_ProgramMode)
  {
    case 0://Curve
    UpdateCurve();
    if (g_IsEditorMode)
    {
      g_CPGButton.Display();
    }
    break;
    
    case 1://Curve Constructor
    if (g_IsEditorMode)
    {
      UpdateCurveConstructor();
      g_CPGButton.Display();
    }
    else
    {
      g_IsEditorMode = false;
    }
    break;
  }
}

void UpdateCurve()
{
  background(255);
  
  stroke(0);
  
  g_Curve.Update();
  g_Curve.Display();
  
  if (frameCount % g_RenderFrameGap == 0)
  {
     saveFrame("render\\wrap_####.png"); 
  }
}

void UpdateCurveConstructor()
{
  background(255);

  text("Akways draw connections from Right -> Left", width/2 - 50.0f, 50);
  g_CurveConstructor.Display();
}

void mouseClicked()
{
  if(!g_IsEditorMode)
    return;
  
  if (mouseButton == LEFT)
  {
    if (g_CPGButton.IsPositionInsideButtonArea(mouseX, mouseY))
    {
      g_CPGButton.OnClicked();
    }
    else if (g_ProgramMode == 1)
    {
      if (g_CurveConstructor.IsFreePosition(mouseX, mouseY))
      {
         g_CurveConstructor.AddNode(mouseX, mouseY); 
      }
    }
  }
  else if (mouseButton == RIGHT && g_ProgramMode == 1)
  {
    PVector mousePos = new PVector(mouseX, mouseY);
    for (int iter = 0; iter < g_CurveConstructor.m_Nodes.size(); ++iter)
    {
       if (IsLesserOrEqualWithEpsilon(g_CurveConstructor.m_Nodes.get(iter).GetClosestDistanceToNodeSurface(mousePos), 0.0f))
       {
         g_CurveConstructor.m_Nodes.remove(iter);
         break;
       }
    }
  }
}

void mouseDragged()
{
  if (!g_IsEditorMode)
    return;
   
   if (g_ProgramMode == 1)
   {
     g_CurveConstructor.OnMouseDragged(mouseX, mouseY);
   }
}

void mouseReleased()
{
   if (!g_IsEditorMode)
   return;
   
   if (g_ProgramMode == 1)
   {
     g_CurveConstructor.OnMouseReleased(mouseX, mouseY);
   }
}

void keyPressed()
{
   boolean switchEditorMode = key == ' '; 
   
   if (!switchEditorMode)
   {
      return; 
   }
   
   if (g_IsEditorMode)
   {
     if (g_ProgramMode == 1)
     {
       g_CurveConstructor.TransferNodesToCurve();
     }
     else
     {
       g_CPGButton = null;
       g_CurveConstructor = null;
     }
   }
   else if (g_ProgramMode == 0)
   {
     g_CurveConstructor = new CurveConstructor();
     g_CPGButton = new ChangeProgramModeButton(20, 20); 
   }
   else
   {
     return; //Dont switch editor mode
   }
   
   g_IsEditorMode = !g_IsEditorMode;
}
