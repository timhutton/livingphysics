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

