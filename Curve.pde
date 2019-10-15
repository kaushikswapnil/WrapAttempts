class Curve
{
   ArrayList<Node> m_Nodes;
   
   Curve(ArrayList<Node> initialConfig)
   {
      m_Nodes = initialConfig; 
   }
   
   Curve()
   {
      m_Nodes = new ArrayList<Node>();
   }
   
   void Update()
   {
      for (Node node : m_Nodes)
      {
         Node nodeLeft = node.m_Left;
         Node nodeRight = node.m_Right;
         
         float idealDist = node.GetIdealSpringDist();
         
         if (nodeLeft != null)
         {
           PVector springForce = GetSpringForce(nodeLeft, node, idealDist);
             
           node.AddForce(springForce);
           //nodeLeft.AddForce(PVector.mult(springForce, -1));
         }
         
         if (nodeRight != null)
         {
           PVector springForce = GetSpringForce(nodeRight, node, idealDist);
             
           node.AddForce(springForce);
           //nodeLeft.AddForce(PVector.mult(springForce, -1));
         }
         
         //Spring Friction
         PVector velocityDir = node.m_Velocity.get();
         velocityDir.normalize();
         float velocityMag = node.m_Velocity.mag();
         
         PVector springFriction = PVector.mult(velocityDir, -g_SpringFrictionCoeff*velocityMag); //<>// //<>//
         node.AddForce(springFriction); //<>// //<>//
         
         PVector repulsionForce = new PVector(0, 0); //<>// //<>//
         
         for (Node otherNode : m_Nodes)
         {
            if (otherNode != node
              && otherNode != node.m_Left
              && otherNode != node.m_Right)
              {
                 float nodeDist = otherNode.m_Position.dist(node.m_Position);
                 
                 if (IsLesserOrEqualWithEpsilon(nodeDist, g_RepulsionRange))
                 {
                     PVector nodeDir = PVector.sub(otherNode.m_Position, node.m_Position);
                     nodeDir.normalize();
                     
                     PVector repulsionForceForNode = PVector.mult(nodeDir, -(g_RepulsionRange - nodeDist)*g_SpringConstant);
                     repulsionForce.add(repulsionForceForNode);
                 }
              }
         }
         
         node.AddForce(repulsionForce);
         
         //Physics Update
         node.PhysicsUpdate();
      }
      
      if (IsLesserWithEpsilon(random(1.0), g_ChanceToAddNewNode))
      {
        //int randomNodeIndex = (int)(random(m_Nodes.size()));
        
        Node recordNode = null;
        float recordAngle = -10000.0f;
        
        for (Node node : m_Nodes)
        {
           //Node node = m_Nodes.get(nodeIter);
           if (node.IsCorner())
           {
             float cornerAngle = node.GetCornerAngle();
             if (IsGreaterWithEpsilon(cornerAngle, recordAngle))
             {
                recordAngle = cornerAngle; 
                recordNode = node;
             }
           }
        }

        //recordNode = null;
        //do
        //{
        //  int randomNodeIndex = (int)(random(m_Nodes.size()));
        //  recordNode = m_Nodes.get(randomNodeIndex);
        //}
        //while(!recordNode.IsCorner());
        
        if (recordNode != null)
        {
          //add new node to right of this node
          Node nodeA = recordNode;
          Node nodeB;
          
          boolean bIsLeftNode;
          if (IsLesserWithEpsilon(random(1.0), 0.5f))
          {
            nodeB = nodeA.m_Left;
            bIsLeftNode = true;
          }
          else
          {
            nodeB = nodeA.m_Right;
            bIsLeftNode = false;
          }
          
          PVector edgeDir = PVector.sub(nodeB.m_Position, nodeA.m_Position);
          float edgeDist = edgeDir.mag();
          edgeDir.normalize();
          
          Node newNode = new Node(PVector.add(nodeA.m_Position, PVector.mult(edgeDir, edgeDist/2)), null, null);
          
          if (bIsLeftNode)
          {
            nodeA.m_Left = newNode;
            newNode.m_Right = nodeA;
            newNode.m_Left = nodeB;
            nodeB.m_Right = newNode;
          }
          else
          {
             nodeA.m_Right = newNode;
             newNode.m_Left = nodeA;
             newNode.m_Right = nodeB;
             nodeB.m_Left = newNode; 
          }
          
          m_Nodes.add(newNode);
        }
      }
   }
   
   void Display()
   {
      strokeWeight(3);
      for (Node node : m_Nodes)
      {
         if (node.m_Left != null)
         {
            line(node.m_Position.x, node.m_Position.y, node.m_Left.m_Position.x, node.m_Left.m_Position.y);
         }
         
         if (node.m_Right != null)
         {
            line(node.m_Position.x, node.m_Position.y, node.m_Right.m_Position.x, node.m_Right.m_Position.y);
         }
         //fill(0);
         //textAlign(CENTER);
         //String toPrint = ""+node.m_Position.x+" "+node.m_Position.y+" "+node.m_Position.z+"";
         //text(toPrint, node.m_Position.x, node.m_Position.y);
      }  
   }
   
   PVector GetSpringForce(Node attachedPoint, Node freePoint, float idealDist)
   {             
     PVector springForceDir = PVector.sub(attachedPoint.m_Position, freePoint.m_Position);
     float distBetweenNodes = springForceDir.mag();
     springForceDir.normalize();
     
     return PVector.mult(springForceDir, (idealDist - distBetweenNodes)*-g_SpringConstant);
   }
   
   boolean IsCurveStable()
   {
     boolean isCurveStable = true;
     for (Node node : m_Nodes)
     {
       if (node.m_Velocity.mag() > 0)
       {
         isCurveStable = false;
       }
     }
     
     return isCurveStable;
   }
}
