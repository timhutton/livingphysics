final int reaction_event = 0;

class Event
{
  int type;
  int x,y;
  int age;
  boolean completed;
  
  Event(int type_in,int x_in,int y_in)
  {
    type = type_in;
    x = x_in;
    y = y_in;
    age = 0;
    completed = false;
  }
  
  void process()
  {
    switch(type)
    {
      case reaction_event:
        // animate a brief ripple spreading from the reaction location
        noFill();
        stroke(color(255,255,255));
        strokeWeight(2*pix);
        float r = 40*pix + 8*pix*age;
        ellipse(x,y,r,r);
        if(age>6) completed = true;
        break;
    }
    age++;
  }
}
