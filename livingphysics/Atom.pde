class Atom 
{
  float x, y;
  float vx, vy;
  int id;
  Atom[] others;
  int type;
  int state;
  ArrayList bonds;
  boolean stuck;
  
  final float time_scale = 0.5;
  final float max_speed = 6*pix;
  final float user_drag_strength = 1.0;
  final float bond_strength = 0.25;
 
  Atom(float xin, float yin, int ID, 
       int t, int s, Atom[] other_atoms) 
  {
    x = xin;
    y = yin;
    id = ID;
    type = t;
    state = s;
    others = other_atoms;
    float angle = random(0,TWO_PI);
    vx = max_speed * cos(angle);
    vy = max_speed * sin(angle);
    bonds = new ArrayList();
    stuck = false;
  } 
  
  void sumForces() 
  {
    bounceOffWalls();
    bounceOffAtoms();
    getPulledBySprings();
    getDraggedByUser();
  }
  
  void bounceOffWalls()
  {
    float minX = atoms_area.x+R;
    float minY = atoms_area.y+R;
    float maxX = atoms_area.x+atoms_area.width-R;
    float maxY = atoms_area.y+atoms_area.height-R;
    if(x<minX) vx += getForce(minX-x);
    if(y<minY) vy += getForce(minY-y);
    if(x>maxX) vx -= getForce(x-maxX);
    if(y>maxY) vy -= getForce(y-maxY);
  }
  
  void bounceOffAtoms()
  {
    for(int i=0;i<id;i++) // (only need to compute the force once for each pair)
    {
      Atom b = others[i];
      if(!nearerThan(x-b.x,y-b.y,2*R)) continue;
      float sep = mag(x-b.x,y-b.y);
      float k = getForce(R*2 - sep) / sep;
      float dx = k * (x - b.x);
      float dy = k * (y - b.y);
      vx += dx;
      vy += dy;
      b.vx -= dx;
      b.vy -= dy;
      // reactions apply when atoms collide
      doChemistry(b);
    }
  }
  
  void getPulledBySprings()
  {
    for(int i=0;i<bonds.size();i++)
    {
      Atom b = (Atom)bonds.get(i);
      if(b.id>id) continue; // only need to compute spring forces once for each bond
      float sep = mag(x-b.x,y-b.y);
      float force = getForce(sep - R*2) * bond_strength;
      // pull towards the other atom
      float dx = force * (x - b.x) / sep;
      float dy = force * (y - b.y) / sep;
      vx -= dx;
      vy -= dy;
      b.vx += dx;
      b.vy += dy;
    }
  }
  
  void getDraggedByUser()
  {
    if(isDragging && id==iAtomBeingDragged)
    {
      float d = mag(x-mouseX,y-mouseY);
      float dx = (mouseX-x)/d;
      float dy = (mouseY-y)/d;
      vx += dx * user_drag_strength;
      vy += dy * user_drag_strength;
    }
  }
  
  float getForce(float d) 
  {
    return d * 0.8;
  }
  
  void move()
  {
    if(stuck) return;
    
    // limit the speed
    if(!nearerThan(vx,vy,max_speed))
    {
      float speed = mag(vx,vy);
      vx *= max_speed/speed;
      vy *= max_speed/speed;
    }
    x += time_scale * vx;
    y += time_scale * vy;
  }
  
  void doChemistry(Atom b)
  {
    for(int i=0;i<reactions.size();i++)
    {
      Reaction r = (Reaction)reactions.get(i);
      r.tryReaction(this,b);
    }
  }
  
  void addReactionEvent(Atom b)
  {
    addEvent(reaction_event,int((x+b.x)/2),int((y+b.y)/2));
  }
  
  void drawBonds() 
  {
    for(int j=0;j<bonds.size();j++)
    {
      Atom b = (Atom)bonds.get(j);
      if(b.id>=id) continue;
      drawBondWith(b);
    }
  }
  
  void drawBondWith(Atom b)
  {
    bond_length = sqrt((x-b.x)*(x-b.x)+(y-b.y)*(y-b.y));
    float sx = x + (b.x-x)*R/bond_length;
    float sy = y + (b.y-y)*R/bond_length;
    float ex = b.x + (x-b.x)*R/bond_length;
    float ey = b.y + (y-b.y)*R/bond_length;
    line(sx,sy,ex,ey);
  }
  
  void drawAtom()
  {
    drawAnAtom(x,y,R,type,state,ATOMS_ALPHA);
  }
  
  void makeBond(Atom b)
  {
    if(!bonds.contains(b) && !b.bonds.contains(this))
    {
      bonds.add(b);
      b.bonds.add(this);
    }
  }
  
  void breakBond(Atom b)
  {
    if(hasBondWith(b))
    {
      bonds.remove(bonds.indexOf(b));
      b.bonds.remove(b.bonds.indexOf(this));
    }
  }
  
  boolean hasBondWith(Atom b)
  {
    return bonds.contains(b);
  }
  
  boolean hasBondWithType(int t)
  {
    for(int i=0;i<bonds.size();i++)
    {
      Atom b = (Atom)bonds.get(i);
      if(b.type==t)
        return true;
    }
    return false;
  }
}

void drawAnAtom(float x,float y,float r,int type,int state,int opacity)
{
   boolean show_type_label = true;
  if(type>=0) // sometimes we don't want to show the type, use -1 for this
  {
    final color[] atom_type_colors = { 0xff0000,0xffff00,0x00ff00,0x00ffff,0x0000ff,0xff00ff };
    color c = atom_type_colors[type];
    c |= opacity << 24;
    fill(c);
    noStroke();
    ellipse(x, y, r*2, r*2);
  }
  if(state>=0) // sometimes we don't want to show the state, use -1 for this
  {
    fill(255,255,255);
    noStroke();
    textAlign(CENTER,CENTER);
    if(show_type_label && type>=0)
    {
      setTextSize(r);
      text("abcdef"[type]+str(state),x,y,MAX_INT);
    }
    else
    {
      setTextSize(r*1.5);
      text(str(state),x,y,MAX_INT);
    }
  }
  else if(show_type_label && type>=0)
  {
    fill(255,255,255);
    noStroke();
    textAlign(CENTER,CENTER);
    setTextSize(r);
    text("abcdef"[type],x,y,MAX_INT);
  }
}

// N.B. This will hang if there are no clear places!
PVector findAClearPlaceForAtom()
{
  float minX = atoms_area.x+R;
  float minY = atoms_area.y+R;
  float maxX = atoms_area.x+atoms_area.width-R;
  float maxY = atoms_area.y+atoms_area.height-R;
  boolean found = false;
  PVector pos = new PVector();
  while(!found) 
  {
    found = true;
    pos.x = random(minX,maxX);
    pos.y = random(minY,maxY);
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i]!=null && nearerThan(pos.x-atoms[i].x,pos.y-atoms[i].y,2*R))
      {
        found = false;
        break;
      }
    }
  }
  return pos;
}

boolean nearerThan(float dx,float dy,float radius)
{
  if(dx>radius || dy>radius || dx<-radius || dy<-radius)
    return false;
  return dx*dx+dy*dy < radius*radius;
}
