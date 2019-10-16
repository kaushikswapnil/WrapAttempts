class CurveConstructor
{
   ArrayList<Node> m_Nodes;
   
   CurveConstructor()
   {
      m_Nodes = new ArrayList<Node>();
   }
   
   void TransferNodesToCurve()
   {
     g_Curve.SetNodes(m_Nodes);
     m_Nodes = new ArrayList<Node>();
   }
  
   void Display()
   {
     for (Node node : m_Nodes)
     {
       node.Display();
       
       if (node.m_Left != null)
       {
         line(node.m_Position.x, node.m_Position.y, node.m_Left.m_Position.x, node.m_Left.m_Position.y);
       }
       
       if (node.m_Right != null)
       {
         line(node.m_Position.x, node.m_Position.y, node.m_Right.m_Position.x, node.m_Right.m_Position.y);
       }
     }
   }
   
   boolean IsFreePosition(float posX, float posY)
   {
     boolean isFreePosition = true;
     for (Node node : m_Nodes)
     {
       if (IsLesserWithEpsilon(node.GetClosestDistanceToNodeSurface(new PVector(posX, posY)), 0.0f))
       {
         isFreePosition = false;
         break;
       }
     }
     
     return isFreePosition;
   }
   
   void AddNode(float posX, float posY)
   {
     m_Nodes.add(new Node(new PVector(posX, posY), 8));    
   }
}
