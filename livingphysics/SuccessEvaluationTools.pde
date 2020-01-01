ArrayList getAllAtomsConnectedTo(Atom a)
{
  ArrayList connected = new ArrayList();
  boolean added;
  connected.add(a);
  do {
    added = false;
    // add any new atoms connected to those in connected
    for(int i=0;i<connected.size();i++)
    {
      Atom b = (Atom)connected.get(i);
      for(int j=0;j<b.bonds.size();j++)
      {
        Atom c = (Atom)b.bonds.get(j);
        if(!connected.contains(c))
        {
          connected.add(c);
          added = true;
        }
      }
    }
  } while(added);
  return connected;
}

ArrayList getAllConnectedAtomsOfType(Atom a,int type)
{
  ArrayList connected = new ArrayList();
  boolean added;
  connected.add(a);
  do {
    added = false;
    // add any new atoms connected to those in connected, if they have the right type
    for(int i=0;i<connected.size();i++)
    {
      Atom b = (Atom)connected.get(i);
      for(int j=0;j<b.bonds.size();j++)
      {
        Atom c = (Atom)b.bonds.get(j);
        if(c.type==type && !connected.contains(c))
        {
          connected.add(c);
          added = true;
        }
      }
    }
  } while(added);
  return connected;
  // N.B. not equivalent to just filtering the result of getAllAtomsConnectedTo by type
  //      e.g. getAllConnectedAtomsOfType( A, A-A-A-B-B-A-A ) will return just A-A-A
}

// http://local.wasp.uwa.edu.au/~pbourke/geometry/insidepoly/
boolean PointInPolygon(PVector[] pts,float x,float y)
{
  int i, j = pts.length-1;
  boolean c = false;
  for (i = 0; i < pts.length; i++) 
  {
    if ((((pts[i].y <= y) && (y < pts[j].y)) ||
         ((pts[j].y <= y) && (y < pts[i].y))) &&
        (x < (pts[j].x - pts[i].x) * (y - pts[i].y) / (pts[j].y - pts[i].y) + pts[i].x))
      c = !c;
      j = i;
  }
  return c;
}

boolean AtomInBoundingBox(Atom a, ArrayList atoms)
{
  float min_x = MAX_FLOAT, min_y = MAX_FLOAT;
  float max_x = 0, max_y = 0;
  for(int i=0;i<atoms.size();i++)
  {
    Atom b = (Atom)atoms.get(i);
    if(b.x < min_x) min_x = b.x;
    if(b.y < min_y) min_y = b.y;
    if(b.x > max_x) max_x = b.x;
    if(b.y > max_y) max_y = b.y;
  }
  return(a.x > min_x && a.x < max_x && a.y > min_y && a.y < max_y);
}
