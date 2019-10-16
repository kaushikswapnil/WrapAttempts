class Button
{
  float m_PosX, m_PosY;
  float m_Width, m_Height;
  
  String m_Name;
  
  int m_TextSize;
  
  int m_HeightOffset = 4;
  int m_WidthOffset = 4;
  
  Button(String name, float posX, float posY, int textSize)
  {
     m_Name = name;
     
     m_PosX = posX;
     m_PosY = posY;
     
     m_TextSize = textSize;
     
     textSize(m_TextSize);
     m_Width = textWidth(m_Name) + (2*m_WidthOffset);
     m_Height = textSize + (2*m_HeightOffset);
  }
  
  Button(String name, float posX, float posY, float buttonWidth, float buttonHeight)
  {  
    m_Name = name;
    
    m_PosX = posX;
    m_PosY = posY;
    
    m_Width = buttonWidth;
    m_Height = buttonHeight;
  }
  
  void Display()
  {
     rectMode(CORNER);
     stroke (0);
     fill(175);
     
     rect(m_PosX, m_PosY, m_Width, m_Height);
     fill(0);
     textSize(m_TextSize);
     text(m_Name, m_PosX + m_WidthOffset, m_PosY + m_TextSize + m_HeightOffset);
  }
  
  boolean IsPositionInsideButtonArea(float posX, float posY)
  {
    return (posX > m_PosX && posX < m_PosX + m_Width)
      && (posY > m_PosY && posY < m_PosY + m_Height);
  }
  
  void OnClicked() //Leave to descendents
  {
    
  }
}

class ChangeProgramModeButton extends Button
{
  ChangeProgramModeButton(float posX, float posY)
  {
    super("Change Program Mode", posX, posY, 10);
  }
  
  void OnClicked() //Leave to descendents
  {
    switch (g_ProgramMode)
    {
      case 0:
      break;
      
      case 1:
      g_CurveConstructor.TransferNodesToCurve();
      break;
    }
    
    g_ProgramMode = (g_ProgramMode+1)%2;
  }
}
