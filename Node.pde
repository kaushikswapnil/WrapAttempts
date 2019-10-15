class Node
{
   PVector m_Position;
   float m_Diameter;
   
   PVector m_Velocity, m_Acceleration;
   
   float m_Mass;
   
   Node m_Left, m_Right;
   
   Node(PVector position, float diameter)
   {
      m_Position = position.get();
      m_Diameter = diameter;
      
      m_Left = null;
      m_Right = null;
      
      m_Velocity = new PVector(0, 0);
      m_Acceleration = new PVector(0, 0);
      
      m_Mass = 1.0f;
   }
   
   Node(PVector position, Node left, Node right)
   {
      m_Position = position.get();
      m_Diameter = 1.0f;
      
      m_Left = left;
      m_Right = right;
      
      m_Velocity = new PVector(0, 0);
      m_Acceleration = new PVector(0, 0);
      
      m_Mass = 1.0f;
   }
   
   Node(PVector position, float diameter, Node left, Node right)
   {
      m_Position = position.get();
      m_Diameter = diameter;
      
      m_Left = left;
      m_Right = right;
      
      m_Velocity = new PVector(0, 0);
      m_Acceleration = new PVector(0, 0);
      
      m_Mass = 1.0f;
   }
   
   Node(PVector position, float diameter, Node left, Node right, float mass)
   {
      m_Position = position.get();
      m_Diameter = diameter;
      
      m_Left = left;
      m_Right = right;
      
      m_Velocity = new PVector(0, 0);
      m_Acceleration = new PVector(0, 0);
      
      m_Mass = mass;
   }
   
   void Display()
   {
      pushMatrix();
      fill(250, 0, 0);
      noStroke();
      ellipse(m_Position.x, m_Position.y, m_Diameter, m_Diameter);
      popMatrix();
   }
   
   void PhysicsUpdate()
   {
      m_Velocity.add(m_Acceleration); //<>// //<>//
      m_Position.add(m_Velocity); //<>// //<>//
      
      m_Acceleration.mult(0); //<>// //<>//
   }
   
   void AddForce(PVector force)
   {
      m_Acceleration = PVector.add(m_Acceleration, PVector.div(force, m_Mass));
   }
   
   float GetClosestDistanceToNodeSurface(PVector fromPos)
   {
      float radius = m_Diameter/2;
      float surfDist = m_Position.dist(fromPos) - radius;
      
      return surfDist;
   }
   
   float GetIdealSpringDist()
   {
      float idealDist;
      boolean hasLeftNbhr = m_Left != null;
      boolean hasRightNbhr = m_Right != null;
      
      if (hasLeftNbhr && hasRightNbhr)
      {
        float distFromLeftNbhr = m_Left.m_Position.dist(m_Position);
        float distFromRightNbhr = m_Right.m_Position.dist(m_Position);
        idealDist = (distFromRightNbhr + distFromLeftNbhr)/2;
      }
      else if(hasLeftNbhr)
      {
        idealDist = m_Left.m_Position.dist(m_Position);
      }
      else// if(hasRightNbhr)
      {
        idealDist = m_Right.m_Position.dist(m_Position);
      }
      
      if (g_LimitIdealSpringDist)
      {
        if (IsGreaterWithEpsilon(idealDist, g_NeighbourIdealProximityMax))
        {
          idealDist = g_NeighbourIdealProximityMax;
        }
        else if (IsLesserWithEpsilon(idealDist, g_NeighbourIdealProximityMin))
        {
           idealDist = g_NeighbourIdealProximityMin; 
        }
      }
      
      return idealDist;
   }
   
   boolean IsCorner()
   {
     return m_Left != null && m_Right != null;
   }
   
   float GetCornerAngle()
   {
     PVector leftEdgeDir = PVector.sub(m_Left.m_Position, m_Position);
     leftEdgeDir.normalize();
     
     PVector rightEdgeDir = PVector.sub(m_Right.m_Position, m_Position);
     rightEdgeDir.normalize();
     
     return PVector.angleBetween(leftEdgeDir, rightEdgeDir);
   }
}
