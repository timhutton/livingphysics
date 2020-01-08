// Level 0: Intro: no reactions needed, just pulling
// Level 1: Easy: needs one or two reactions, no pitfalls
// Level 2: Medium: up to three reactions, possible to make mistakes
// Level 3: Hard: needs a sequence of reactions
// Level 4: Fiendish: solution not obvious, needs experimentation and thought

Challenge full_version_challenges[] = {
  new UnzipChallenge(), // 3
  new InsertChallenge(), // 3
  new ZipChallenge(), // 3
  new BuildGirderChallenge(), // 3
  new MessagePassingChallenge(), // 3
  new GrowMembraneChallenge(), // 3.5
  new PullingChallenge(), // 3.5
  new ConcertinaChallenge(), // 3.5
  new MitosisChallenge(), // 3.5
  new LadderFromRungsChallenge(), // 3.5
  new RollChallenge(), // 3.6
  new PeristalsisChallenge(), // 4
  new EatChallenge(), // 4.1
  new MatchChallenge(), // 4.2
  new FilterChallenge(), // 4.5
};

class UnzipChallenge extends Challenge {
  UnzipChallenge() {
    id = "unzip";
    title = "Unzip";
    desc = "Split the ladder down the middle.";
    min_reactions_required = 2;
  }
  void init()
  {
    atoms = new Atom[20];
    for (int i = 0; i < atoms.length; i++) 
    {
      int type = 3;
      int state = 1;
      if(i<2) state = 2;
      if(i%2==0)
        atoms[i] = new Atom(atoms_area.width/2-R,R*4+R*(i-i%2),i,type,state,atoms);
      else
        atoms[i] = new Atom(atoms_area.width/2+R,R*4+R*(i-i%2),i,type,state,atoms);
      if(i>1)
        atoms[i].makeBond(atoms[i-2]);
      if(i%2==1)
        atoms[i].makeBond(atoms[i-1]);
    }
  }
  void evaluateSuccess()
  {
    ArrayList left = getAllAtomsConnectedTo(atoms[0]);
    if(left.size()!=10) return;
    ArrayList right = getAllAtomsConnectedTo(atoms[1]);
    if(right.size()!=10) return;
    succeeded = true;
  }
}

//---------------------------------------------------

class InsertChallenge extends Challenge {
  InsertChallenge() {
    id = "insert";
    title = "Insert";
    desc = "Insert a green atom into the middle of the chain, without breaking it";
    min_reactions_required = 3;
  }
  void init()
  {
    atoms = new Atom[24];
    for(int i=0;i<10;i++)
    {
      int type = i<5?1:0;
      int state = 1;
      if(i==4) state=2; 
      else if(i==5) state=3;
      atoms[i] = new Atom(atoms_area.width/2,R*3+i*R*2,i,type,state,atoms);
      if(i>0)
        atoms[i].makeBond(atoms[i-1]);
      if(i==0 || i==9)
        atoms[i].stuck = true;
    }
    for (int i = 10; i < atoms.length; i++) 
    {
      int state = 0;
      int type = 2;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    ArrayList chain = getAllAtomsConnectedTo(atoms[0]);
    if(chain.size()!=11) return;
    for(int i=0;i<5;i++)
    {
      Atom a = (Atom)chain.get(i);
      if(a.id!=i || a.type!=1) return;
      int n_expected_bonds = i==0?1:2;
      if(a.bonds.size()!=n_expected_bonds) return;
    }
    for(int i=0;i<5;i++)
    {
      Atom a = (Atom)chain.get(6+i);
      if(a.id!=5+i || a.type!=0) return;
      int n_expected_bonds = i==4?1:2;
      if(a.bonds.size()!=n_expected_bonds) return;
    }
    Atom a= (Atom)chain.get(5);
    if(a.type!=2) return;
    if(a.bonds.size()!=2) return;
    succeeded = true;
  }
  void detectCheating()
  {
    ArrayList chain = getAllAtomsConnectedTo(atoms[0]);
    if(chain.size()<10) {
      cheating_detected = true;
      cheating_message = "Keep the chain intact at all times. Try again.";
    }
  }
}

//---------------------------------------------------

class ZipChallenge extends Challenge {
  ZipChallenge() {
    id = "zip";
    title = "Zip";
    desc = "Zip the two strands together to complete the ladder.";
    min_reactions_required = 2;
  }
  void init()
  {
    atoms = new Atom[20];
    for (int i = 0; i < atoms.length; i++) 
    {
      int type = 3;
      int state = 1;
      if(i>13) state = 2;
      float f = i<13?3:1; // we pull the two strands apart to ensure there's no trivial solution
      if(i%2==0)
        atoms[i] = new Atom(atoms_area.width/2-R*f,R*4+R*(i-i%2),i,type,state,atoms);
      else
        atoms[i] = new Atom(atoms_area.width/2+R*f,R*4+R*(i-i%2),i,type,state,atoms);
      if(i>1)
        atoms[i].makeBond(atoms[i-2]);
      if(i%2==1 && i>13)
        atoms[i].makeBond(atoms[i-1]);
    }
  }
  void evaluateSuccess()
  {
    for(int i=0;i<20;i+=2)
    {
      if(!atoms[i].bonds.contains(atoms[i+1]))
        return;
    }
    ArrayList all = getAllAtomsConnectedTo(atoms[0]);
    if(all.size()!=20) return;
    succeeded = true;
  }
}

//---------------------------------------------------

class BuildGirderChallenge extends Challenge {
  BuildGirderChallenge() {
    id = "build_girder";
    title = "Build girder";
    desc = "Build the rest of the girder.";
    min_reactions_required = 2;
  }
  void init()
  {
    atoms = new Atom[20];
    atoms[0] = new Atom(atoms_area.width/2-R,atoms_area.height-R,0,5,1,atoms);
    atoms[0].stuck = true;
    atoms[1] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*2,1,5,1,atoms);
    atoms[1].stuck = true;
    atoms[1].makeBond(atoms[0]);
    atoms[2] = new Atom(atoms_area.width/2-R,atoms_area.height-R*3,2,5,1,atoms);
    atoms[3] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*4,3,5,1,atoms);
    atoms[3].makeBond(atoms[2]);
    atoms[2].makeBond(atoms[0]);
    atoms[3].makeBond(atoms[1]);
    atoms[2].makeBond(atoms[1]);
    atoms[4] = new Atom(atoms_area.width/2-R,atoms_area.height-R*5,4,5,2,atoms);
    atoms[5] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*6,5,5,3,atoms);
    atoms[5].makeBond(atoms[4]);
    atoms[4].makeBond(atoms[2]);
    atoms[5].makeBond(atoms[3]);
    atoms[4].makeBond(atoms[3]);
    for(int i=6;i<atoms.length;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,5,0,atoms);
    }
  }
  void evaluateSuccess()
  {
    // count how many atoms have how many bonds
    int n_2=0,n_3=0,n_4=0;
    for(int i=0;i<atoms.length;i++)
    {
      switch(atoms[i].bonds.size())
      {
      case 2: 
        n_2++; 
        break;
      case 3: 
        n_3++; 
        break;
      case 4: 
        n_4++; 
        break;
      default: 
        return;
      }
    }
    if(n_2!=2 || n_3!=2) return;
    if(getAllAtomsConnectedTo(atoms[0]).size()!=20) 
      return;
    succeeded=true;
  }
}

//---------------------------------------------------

class MessagePassingChallenge extends Challenge {
  MessagePassingChallenge() {
    id = "message_passing";
    title = "Message";
    desc = "Without breaking any bonds, attach the blue atoms to each end of the same green chain.";
    desc2 = "Can you do it without relying on pulling the atoms into place?";
    min_reactions_required = 4;
  }
  void init() 
  {
    int n_v = ceil((atoms_area.height-R*2)/(2*R))+1;
    int n_chains = (n_v-(n_v%3))/3;
    atoms = new Atom[n_v+n_chains*6+2];
    int j=0;
    for(int i=0;i<n_v;i++)
    {
      float y = R+i*(atoms_area.height-R*2)/(n_v-1);
      if(i%3!=2)
      {
        atoms[j] = new Atom(atoms_area.width/2,y,j,5,0,atoms);
        atoms[j].stuck = true;
        if(i>0 && i%3!=0)
          atoms[j].makeBond(atoms[j-1]);
        else if(i>0)
          atoms[j].makeBond(atoms[j-4]);
        j++;
      }
      else
      {
        for(int k=0;k<7;k++)
        {
          atoms[j] = new Atom(atoms_area.width/2-2*R*3+2*R*k,y,j,2,k==0?2:(k==6?3:1),atoms);
          if(k==3)
          {
            atoms[j].makeBond(atoms[j-4]);
            atoms[j].stuck = true;
          }
          if(k>0)
            atoms[j].makeBond(atoms[j-1]);
          j++;
        }
      }
    }
    atoms[j] = new Atom(R,R,j,3,0,atoms);
    j++;
    atoms[j] = new Atom(atoms_area.width-R,atoms_area.height-R,j,3,0,atoms);
  }
  void evaluateSuccess()
  {
    Atom b_left = atoms[atoms.length-2];
    Atom b_right = atoms[atoms.length-1];
    if(b_left.bonds.size()!=1 | b_right.bonds.size()!=1)
      return;
    Atom g_left = (Atom)b_left.bonds.get(0);   
    Atom g_right = (Atom)b_right.bonds.get(0);
    if(g_right.id == g_left.id+6)
      succeeded = true;
  }
  void detectCheating()
  {
    for(int i=0;i<reactions.size();i++)
    {
      Reaction r = (Reaction)reactions.get(i);
      if(r.bonded_pre && !r.bonded_post)
      {
        cheating_detected = true;
        cheating_message = "Reactions that break bonds are not allowed in this challenge. Try again.";
        return;
      }
    }
  }
}

//---------------------------------------------------

class GrowMembraneChallenge extends Challenge {
  GrowMembraneChallenge() {
    id = "grow_membrane";
    title = "Grow loop";
    desc = "Grow the loop by adding the loose yellow atoms, giving the contents more room to move.";
    desc2 = "Don't let the red atoms out!";
    min_reactions_required = 3;
  }
  void init()
  {
    atoms = new Atom[25];
    PVector p1 = new PVector(atoms_area.width/2,atoms_area.height/2);
    atoms[0] = new Atom(p1.x-R,p1.y,0,0,0,atoms);
    atoms[1] = new Atom(p1.x+R,p1.y,1,0,0,atoms);
    atoms[2] = new Atom(p1.x,p1.y-R,2,0,0,atoms);
    final int N = 8;
    for(int i=0;i<N;i++)
    {
      atoms[3+i] = new Atom(p1.x+R*2.6*cos(i*TWO_PI/N),p1.y+R*2.6*sin(i*TWO_PI/N),
      3+i,1,1,atoms);
    }
    for(int i=0;i<N-1;i++)
      atoms[3+i].makeBond(atoms[3+i+1]);
    atoms[3+N-1].makeBond(atoms[3]);
    atoms[3].state=2;
    atoms[4].state=3;
    int choice[] = {
      1,1,1,2,3,4,5
    };
    for (int i = 3+N; i < atoms.length; i++) 
    {
      int state = 0;
      int type = choice[i%7];
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    ArrayList membrane = getAllAtomsConnectedTo(atoms[3]);
    if(membrane.size()!=14) return;
    for(int i=0;i<membrane.size();i++)
    {
      Atom a = (Atom)membrane.get(i);
      if(a.type!=1) return;
      if(a.bonds.size()!=2) return;
    }  
    // collect the membrane vertices in order
    PVector verts[] = new PVector[membrane.size()];
    Atom prev = atoms[3];
    Atom curr = (Atom)membrane.get(1);
    verts[0] = new PVector(prev.x,prev.y);
    verts[1] = new PVector(curr.x,curr.y);
    for(int i=2;i<membrane.size();i++)
    {
      for(int j=0;j<curr.bonds.size();j++)
      {
        Atom b = (Atom)curr.bonds.get(j);
        if(b==prev) continue;
        prev = curr;
        curr = b;
        verts[i] = new PVector(b.x,b.y);
        break;
      }
    }    
    // check the red atoms are still inside
    if(!PointInPolygon(verts,atoms[0].x,atoms[0].y) || 
      !PointInPolygon(verts,atoms[1].x,atoms[1].y) || 
      !PointInPolygon(verts,atoms[2].x,atoms[2].y))
      return;
    // check that the other atoms are still inside
    for(int i=7;i<atoms.length;i++)
    {
      if(atoms[i].type==1) continue;
      if(PointInPolygon(verts,atoms[i].x,atoms[i].y))
        return;
    }
    succeeded = true;
  }
}

//---------------------------------------------------

class PullingChallenge extends Challenge {
  PullingChallenge() {
    id = "pull";
    title = "Pull";
    desc = "Pull the red atom along the track to connect it to the green atom.";
    desc2 = "Keep the track intact.";
    min_reactions_required = 4;
  }
  void init()
  {
    atoms = new Atom[25];
    int N = int((atoms_area.height-4*R)/(2*R));
    for(int i=0;i<N;i++)
    {
      int type = (i==N-1)?2:4;
      int state = (i==0)?3:1;
      atoms[i] = new Atom(atoms_area.width/2,4*R+i*2*R,i,type,state,atoms);
      if(i==0 || i==N-1)
        atoms[i].stuck = true;
      if(i>0)
        atoms[i].makeBond(atoms[i-1]);
    }
    atoms[N] = new Atom(atoms_area.width/2+2*R,4*R,N,0,2,atoms);
    atoms[N].makeBond(atoms[0]);
    for(int i=N+1;i<atoms.length;i++)
    {
      int type = 1;
      int state = 0;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    // is a green atom connected to a red one?
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==2)
      {
        for(int j=0;j<atoms[i].bonds.size();j++)
        {
          Atom b = (Atom)atoms[i].bonds.get(j);
          if(b.type==0)
            succeeded = true;
        }
        return;
      }
    }
  }
  void detectCheating()
  {
    // is the track intact?
    for(int i=1;i<atoms.length;i++)
    {
      if(atoms[i].type==0) break;
      if(!atoms[i].hasBondWith(atoms[i-1]))
      {
        cheating_detected = true;
        cheating_message = "Keep the track intact at all times. Try again.";
        return;
      }
    }
    // is a red atom connected to neither a green nor a blue atom?
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==0)
      {
        for(int j=0;j<atoms[i].bonds.size();j++)
        {
          Atom b = (Atom)atoms[i].bonds.get(j);
          if(b.type==4 || b.type==2)
            return; // OK
        }
        cheating_detected = true;
        cheating_message = "The red atom should be directly attached to the track at all times. Try again.";
        return;
      }
    }
  }
}

//---------------------------------------------------

class ConcertinaChallenge extends Challenge {
  ConcertinaChallenge() {
    id = "concertina";
    title = "Concertina";
    desc = "Fold the chain together and bond into a girder like the bottom section.";
    min_reactions_required = 4;
  }
  void init()
  {
    int ns = int(atoms_area.height/(2*R))-2;
    atoms = new Atom[ns*2];
    int state,type;
    for(int i=0;i<=2;i+=2)
    {
      state = 2;
      atoms[i] = new Atom(atoms_area.width/2-R,atoms_area.height-R-R*i,i,1,state,atoms);
      state = 2;
      atoms[i+1] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*2-R*i,i+1,2,state,atoms);
      atoms[i+1].makeBond(atoms[i]);
      if(i>0)
        atoms[i].makeBond(atoms[i-1]);
      if(i==2)
      {
        atoms[i].makeBond(atoms[i-2]);
        atoms[i+1].makeBond(atoms[i-1]);
      }
      if(i==0)
      {
        atoms[i].stuck = true;
        atoms[i+1].stuck = true;
      }
    }
    for(int i=4;i<atoms.length;i++)
    {
      state = 1;
      type = (i%2==0)?1:2;
      atoms[i] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*2-R*4-2*R*(i-4),i,type,state,atoms);
      atoms[i].makeBond(atoms[i-1]);
    }
  }
  void detectCheating()
  {
    if(getAllAtomsConnectedTo(atoms[0]).size()<atoms.length)
    {
      cheating_detected = true;
      cheating_message = "The chain should be in one connected piece at all times. Try again.";
      return;
    }
  }
  void evaluateSuccess()
  {
    // count how many atoms have how many bonds
    int n_2=0,n_3=0,n_4=0;
    for(int i=0;i<atoms.length;i++)
    {
      switch(atoms[i].bonds.size())
      {
      case 2: 
        n_2++; 
        break;
      case 3: 
        n_3++; 
        break;
      case 4: 
        n_4++; 
        break;
      default: 
        return;
      }
    }
    if(n_2!=2 || n_3!=2) return;
    if(getAllAtomsConnectedTo(atoms[0]).size()!=atoms.length) 
      return;
    succeeded=true;
  }
}

//---------------------------------------------------

class LadderFromRungsChallenge extends Challenge {
  LadderFromRungsChallenge() {
    id = "rungs";
    title = "Rungs";
    desc = "Assemble the ladder using the rungs provided.";
    desc2 = "Can you do it without relying on pulling the atoms into place?";
    min_reactions_required = 4;
  }
  void init()
  {
    atoms = new Atom[20];
    float xp=0;
    for(int i=0;i<atoms.length;i++)
    {
      if(i%2==0)
        xp = random(-2*R,2*R);
      float x = atoms_area.width/2-R + 2*R*(i%2) + xp;
      float y = atoms_area.height-R-2*R*(i-i%2)/2;
      int type = 5;
      int state;
      if(i<4) state=1;
      else if(i<6) state=2;
      else state=0;
      atoms[i] = new Atom(x,y,i,type,state,atoms);
      if(i%2==1)
        atoms[i].makeBond(atoms[i-1]);
      if(i>1 && i<6)
        atoms[i].makeBond(atoms[i-2]);
      if(i<2)
        atoms[i].stuck = true;
    }
  }
  void evaluateSuccess()
  {
    // count how many atoms have how many bonds
    int n_2=0,n_3=0;
    for(int i=0;i<atoms.length;i++)
    {
      switch(atoms[i].bonds.size())
      {
      case 2: 
        n_2++; 
        break;
      case 3: 
        n_3++; 
        break;
      default: 
        return;
      }
    }
    if(n_2!=4) return;
    if(getAllAtomsConnectedTo(atoms[0]).size()!=20) return;
    succeeded=true;
  }
  void detectCheating()
  {
    // is every atom still bonded with its partner
    for(int i=0;i<atoms.length;i+=2)
    {
      if(!atoms[i].hasBondWith(atoms[i+1]))
      {
        cheating_detected = true;
        cheating_message = "The rungs should be intact at all times. Try again.";
        return;
      }
    }
  }
}

//---------------------------------------------------

class RollChallenge extends Challenge {
  RollChallenge() {
    id = "roll";
    title = "Roll";
    desc = "Roll the red triangles to the opposite ends of the track.";
    desc2 = "Keep the track and the triangles intact, and keep the triangles connected to the track.";
    min_reactions_required = 4;
  }
  void init()
  {
    int nv = int(atoms_area.height/(2*R));
    atoms = new Atom[nv+12+12];
    // four red triangles
    int i=0;
    // a
    atoms[i] = new Atom(atoms_area.width/2-2*R,2*R,i,0,2,atoms); // 0
    i++;
    atoms[i] = new Atom(atoms_area.width/2-4*R,2*R,i,0,4,atoms);
    atoms[i].makeBond(atoms[i-1]);
    i++;
    atoms[i] = new Atom(atoms_area.width/2-3*R,3.5*R,i,0,3,atoms);
    atoms[i].makeBond(atoms[i-1]);
    atoms[i].makeBond(atoms[i-2]);
    i++;
    // b
    atoms[i] = new Atom(atoms_area.width/2-2*R,5*R,i,0,2,atoms); // 3
    i++;
    atoms[i] = new Atom(atoms_area.width/2-4*R,5*R,i,0,4,atoms);
    atoms[i].makeBond(atoms[i-1]);
    i++;
    atoms[i] = new Atom(atoms_area.width/2-3*R,6.5*R,i,0,3,atoms);
    atoms[i].makeBond(atoms[i-1]);
    atoms[i].makeBond(atoms[i-2]);
    i++;
    // c
    atoms[i] = new Atom(atoms_area.width/2+2*R,atoms_area.height-2*R,i,0,2,atoms); // 6
    i++;
    atoms[i] = new Atom(atoms_area.width/2+4*R,atoms_area.height-2*R,i,0,4,atoms);
    atoms[i].makeBond(atoms[i-1]);
    i++;
    atoms[i] = new Atom(atoms_area.width/2+3*R,atoms_area.height-3.5*R,i,0,3,atoms);
    atoms[i].makeBond(atoms[i-1]);
    atoms[i].makeBond(atoms[i-2]);
    i++;
    // d
    atoms[i] = new Atom(atoms_area.width/2+2*R,atoms_area.height-5*R,i,0,2,atoms); // 9
    i++;
    atoms[i] = new Atom(atoms_area.width/2+4*R,atoms_area.height-5*R,i,0,4,atoms);
    atoms[i].makeBond(atoms[i-1]);
    i++;
    atoms[i] = new Atom(atoms_area.width/2+3*R,atoms_area.height-6.5*R,i,0,3,atoms);
    atoms[i].makeBond(atoms[i-1]);
    atoms[i].makeBond(atoms[i-2]);
    i++;
    // track
    for(int j=0;j<nv;j++)
    {
      atoms[i] = new Atom(atoms_area.width/2,R+j*2*R,i,4,1,atoms);
      if(j>0)
        atoms[i].makeBond(atoms[i-1]);
      if(j==0 || j==nv-1)
        atoms[i].stuck = true;
      i++;
    }
    atoms[12].makeBond(atoms[0]);
    atoms[14].makeBond(atoms[3]);
    atoms[11+nv].makeBond(atoms[6]);
    atoms[11+nv-2].makeBond(atoms[9]);
    // others
    for(;i<atoms.length;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,1,0,atoms);
    }
  }
  void evaluateSuccess()
  {
    float a = atoms_area.y + 2*atoms_area.height/5;
    float b = atoms_area.y + 3*atoms_area.height/5;
    if(atoms[0].y>b && atoms[1].y>b && atoms[2].y>b && atoms[3].y>b && atoms[4].y>b && atoms[5].y>b &&
      atoms[6].y<a && atoms[7].y<a && atoms[8].y<a && atoms[9].y<a && atoms[10].y<a && atoms[11].y<a)
      succeeded = true;
  }
  void detectCheating()
  {
    // triangles intact?
    for(int i=0;i<4;i++)
    {
      if(!atoms[i*3+1].hasBondWith(atoms[i*3]) || !atoms[i*3+2].hasBondWith(atoms[i*3+1]) || !atoms[i*3+2].hasBondWith(atoms[i*3]))
      {
        cheating_detected = true;
        cheating_message = "Keep the red triangles intact at all times. Try again.";
        return;
      }
    }
    // track intact?
    for(int i=13;i<atoms.length;i++)
    {
      if(atoms[i].type!=4) break;
      if(!atoms[i].hasBondWith(atoms[i-1]))
      {
        cheating_detected = true;
        cheating_message = "Keep the track intact at all times. Try again.";
        return;
      }
    }
    // triangles connected to track?
    boolean tri_a_connected = false,tri_b_connected = false,tri_c_connected = false,tri_d_connected = false;
    for(int i=12;i<atoms.length;i++)
    {
      if(atoms[i].type!=4) break;
      if(atoms[i].hasBondWith(atoms[0]) || atoms[i].hasBondWith(atoms[1]) || atoms[i].hasBondWith(atoms[2]))
        tri_a_connected = true;
      if(atoms[i].hasBondWith(atoms[3]) || atoms[i].hasBondWith(atoms[4]) || atoms[i].hasBondWith(atoms[5]))
        tri_b_connected = true;
      if(atoms[i].hasBondWith(atoms[6]) || atoms[i].hasBondWith(atoms[7]) || atoms[i].hasBondWith(atoms[8]))
        tri_c_connected = true;
      if(atoms[i].hasBondWith(atoms[9]) || atoms[i].hasBondWith(atoms[10]) || atoms[i].hasBondWith(atoms[11]))
        tri_d_connected = true;
    }
    if(!tri_a_connected || !tri_b_connected || !tri_c_connected || !tri_d_connected)
    {
      cheating_detected = true;
      cheating_message = "Keep the red triangles connected to the blue track at all times. Try again.";
      return;
    }
  }
}

//---------------------------------------------------

class FilterChallenge extends Challenge {
  FilterChallenge() {
    id = "filter";
    title = "Filter";
    desc = "Move all the red and green atoms to different sides of the chain.";
    desc2 = "Can you do it without relying on pulling the atoms into place?";
    min_reactions_required = 19;
  }
  void init()
  {
    float left = 2*R;
    float right = atoms_area.width-2*R;
    int n_between = int( (right-left) / (R*2) )+2;
    atoms = new Atom[2+n_between+18];
    atoms[0] = new Atom(R,atoms_area.height/2+R,0,1,3,atoms);
    atoms[0].stuck = true;
    atoms[1] = new Atom(atoms_area.width-R,atoms_area.height/2,1,1,4,atoms);
    atoms[1].stuck = true;
    for (int i = 2; i < 2+n_between; i++) 
    {
      int type = 1;
      int state = 1;
      atoms[i] = new Atom(left+(i-2)*(right-left)/n_between,atoms_area.height/2,i,type,state,atoms);
      if(i>2)
        atoms[i].makeBond(atoms[i-1]);
    }
    atoms[2].makeBond(atoms[0]);
    atoms[2+n_between-1].makeBond(atoms[1]);
    atoms[2+n_between] = new Atom(R,atoms_area.height/2-R,2+n_between,1,2,atoms);
    atoms[2+n_between].stuck = true;
    atoms[2+n_between].makeBond(atoms[0]);
    atoms[2+n_between].makeBond(atoms[2]);
    for(int i=2+n_between+1;i<atoms.length;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      int type = i%2==1?0:2;
      atoms[i] = new Atom(pos.x,pos.y,i,type,0,atoms);
    }
  }
  void evaluateSuccess()
  {
    // are the red and green atoms separated?
    boolean all_red_above=true,all_red_below=true;
    boolean all_green_above=true,all_green_below=true;
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==0)
      {
        if(atoms[i].y>atoms_area.height/2) all_red_above = false;
        else all_red_below = false;
      }
      if(atoms[i].type==2)
      {
        if(atoms[i].y>atoms_area.height/2) all_green_above = false;
        else all_green_below = false;
      }
    }
    if( !((all_red_above && all_green_below) || (all_red_below && all_green_above)) )
      return;
    // are atoms 0 and 1 connected?
    ArrayList chain = getAllAtomsConnectedTo(atoms[0]);
    if(!chain.contains(atoms[1])) return;
    succeeded = true;
  }
  void detectCheating()
  {
    // are atoms 0 and 1 connected?
    ArrayList chain = getAllAtomsConnectedTo(atoms[0]);
    if(!chain.contains(atoms[1]))
    {
      cheating_detected = true;
      cheating_message = "Keep the chain connected at all times. Try again.";
      return;
    }
  }
}

//---------------------------------------------------

class PeristalsisChallenge extends Challenge {
  PeristalsisChallenge() {
    id = "peristalsis";
    title = "Peristalsis";
    desc = "By opening and closing the 'rungs', move the green atom down through the blue tube into the lower area, and bond it to a red atom.";
    desc2 = "No more than 3 rungs can be open at a time. (There are already 2 rungs open.)";
    min_reactions_required = 6;
  }
  void init()
  {
    float top = atoms_area.height/6;
    int n_v = int((atoms_area.height-top*2)/(2*R))+1;
    int n_h = int((atoms_area.width-2*2*R)/(2*2*R))+1;
    atoms = new Atom[n_v*2+n_h*4+7];
    for(int i=0;i<n_v*2;i++)
    {
      float x = atoms_area.width/2-R + 2*R*(i%2);
      float y = top + 2*R*(i-i%2)/2;
      int type = 3;
      int state = 1;
      if(i==4 || i==5)
        state = 2;
      else if(i==6 || i==7)
        state = 3;
      else if(i==8 || i==9)
        state = 4;
      atoms[i] = new Atom(x,y,i,type,state,atoms);
      if(i%2==1 && /*i!=3 &&*/ i!=5 && i!=7)
        atoms[i].makeBond(atoms[i-1]);
      if(i>1)
        atoms[i].makeBond(atoms[i-2]);
    }
    for(int i=n_v*2;i<n_v*2+n_h*4;i++)
    {
      float x,y;
      if(i-n_v*2 < n_h*2)
        x = R+(i-n_v*2 - (i-n_v*2)%2)*R;
      else
      {
        int j = i-n_v*2-n_h*2;
        x = atoms_area.width - R - (j - j%2)*R;
      }
      y = top;
      if((i-n_v*2)%2==1)
        y += 2*R*(n_v-1);
      atoms[i] = new Atom(x,y,i,1,1,atoms);
      if( (i-n_v*2>1 && i-n_v*2<n_h*2) || i-n_v*2-n_h*2>1)
        atoms[i].makeBond(atoms[i-2]);
      else
        atoms[i].stuck = true;
    }
    atoms[0].makeBond(atoms[n_v*2+n_h*2-2]);
    atoms[1].makeBond(atoms[n_v*2+n_h*4-2]);
    atoms[n_v*2-2].makeBond(atoms[n_v*2+n_h*2-1]);
    atoms[n_v*2-1].makeBond(atoms[n_v*2+n_h*4-1]);
    // 'bolus'
    atoms[n_v*2+n_h*4] = new Atom(atoms_area.width/2,top+3*R,n_v*2+n_h*4,2,0,atoms);
    // 'digestive enzymes'
    atoms[n_v*2+n_h*4+1] = new Atom(atoms_area.width/2+R,atoms_area.height-R,n_v*2+n_h*4+1,0,0,atoms);
    atoms[n_v*2+n_h*4+2] = new Atom(atoms_area.width/2-R,atoms_area.height-R,n_v*2+n_h*4+2,0,0,atoms);
    // 'food'
    atoms[n_v*2+n_h*4+3] = new Atom(atoms_area.width/2+R,R,n_v*2+n_h*4+3,2,0,atoms);
    atoms[n_v*2+n_h*4+4] = new Atom(atoms_area.width/2-R,R,n_v*2+n_h*4+4,2,0,atoms);
    // 'other organs'
    atoms[n_v*2+n_h*4+5] = new Atom(R,atoms_area.height/2,n_v*2+n_h*4+5,5,0,atoms);
    atoms[n_v*2+n_h*4+6] = new Atom(atoms_area.width-R,atoms_area.height/2,n_v*2+n_h*4+6,5,0,atoms);
  }
  void evaluateSuccess()
  {
    // is a green atom bonded to a red?
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==2)
      {
        for(int j=0;j<atoms[i].bonds.size();j++)
        {
          Atom b = (Atom)atoms[i].bonds.get(j);
          if(b.type==0)
          {
            succeeded = true;
            return;
          }
        }
      }
    }
  }
  void detectCheating()
  {
    int n_rungs_broken=0;
    for(int i=0;i<atoms.length;i++)
    {
      switch(atoms[i].type)
      {
      case 3: // tube wall
        {
          if(i>1 && !atoms[i].hasBondWith(atoms[i-2]))
          {
            cheating_detected = true;
            cheating_message = "The blue tube walls must remain intact. Try again.";
            return;
          }
          if(i%2==0 && !atoms[i].hasBondWith(atoms[i+1]))
          {
            n_rungs_broken++;
          }
        }
        break;
      case 1: // side wall
        {
          if( (atoms[i].stuck && atoms[i].bonds.size()!=1) || (!atoms[i].stuck && atoms[i].bonds.size()!=2) )
          {
            cheating_detected = true;
            cheating_message = "The yellow walls must remain intact. Try again.";
            return;
          }
        }
        break;
      }
    }
    if(n_rungs_broken>3)
    {
      cheating_detected = true;
      cheating_message = "No more than 3 'rungs' should be open at any one time. Try again.";
      return;
    }
  }
}

//---------------------------------------------------

class EatChallenge extends Challenge {
  EatChallenge() {
    id = "eat";
    title = "Eat";
    desc = "Move all of the green atoms into the cell. Leave the blue atoms outside.";
    desc2 = "Don't let the red atom out.";
    min_reactions_required = 8;
  }
  void init() 
  {
    final int N = 14;
    atoms = new Atom[N+9];
    float radius = min(atoms_area.width/2,N*2*R/TWO_PI);
    for(int i=0;i<N;i++)
    {
      float angle = i*TWO_PI/N;
      int state = 1;
      if(i==0) state=2;
      else if(i==1) state=3;
      atoms[i] = new Atom(atoms_area.width/2+radius*cos(angle),atoms_area.height/2+radius*sin(angle),i,1,state,atoms);
    }
    for(int i=0;i<N;i++)
      atoms[i].makeBond(atoms[(i+1)%N]);
    int i=N;
    atoms[i] = new Atom(atoms_area.width/2,atoms_area.height/2,i,0,0,atoms);
    i++;
    for(int j=0;j<8;j++)
    {
      int type = 2;
      if(j<4) type=3;
      atoms[i] = new Atom(R+2*R*j,R,i,type,0,atoms); // some green and cyan atoms outside
      i++;
    }
  }
  void evaluateSuccess() 
  {
    int n_yellow=0;
    for(int i=0;i<atoms.length;i++)
      if(atoms[i].type==1) n_yellow++;
    ArrayList membrane = getAllAtomsConnectedTo(atoms[0]);
    if(membrane.size()!=n_yellow) return;
    for(int i=0;i<membrane.size();i++)
    {
      Atom a = (Atom)membrane.get(i);
      if(a.type!=1) return;
      if(a.bonds.size()!=2) return;
    }  
    // collect the membrane vertices in order
    PVector verts[] = new PVector[membrane.size()];
    Atom prev = atoms[0];
    Atom curr = (Atom)membrane.get(1);
    verts[0] = new PVector(prev.x,prev.y);
    verts[1] = new PVector(curr.x,curr.y);
    for(int i=2;i<membrane.size();i++)
    {
      for(int j=0;j<curr.bonds.size();j++)
      {
        Atom b = (Atom)curr.bonds.get(j);
        if(b==prev) continue;
        prev = curr;
        curr = b;
        verts[i] = new PVector(b.x,b.y);
        break;
      }
    }    
    // check the red atom is still inside
    if(!PointInPolygon(verts,atoms[n_yellow].x,atoms[n_yellow].y))
      return;
    // check that the green atoms are inside
    for(int i=n_yellow+1;i<atoms.length;i++)
    {
      if(atoms[i].type==2 && !PointInPolygon(verts,atoms[i].x,atoms[i].y))
        return;
      else if(atoms[i].type==3 && PointInPolygon(verts,atoms[i].x,atoms[i].y))
        return;
    }
    succeeded = true;
  }
}

//---------------------------------------------------

class MatchChallenge extends Challenge {
  MatchChallenge() {
    id = "match";
    title = "Match";
    desc = "Without changing the states of the edge atoms or breaking the pair, bond each atom of the pair to its matching color on the edge.";
    desc2 = "Can you get it to work reliably without having to pull the atoms into place?";
    min_reactions_required = 8;
  }
  void init()
  {
    float sep=3.5*R;
    int nv = int(atoms_area.height/sep); // number of atoms vertically up each side
    atoms = new Atom[nv*2+6+2];
    int i;
    // add the fixed atoms on the two sides
    for(i=0;i<nv;i++)
    {
      atoms[i] = new Atom(R,R+sep*i,i,1,0,atoms);
      atoms[i].stuck = true;
      atoms[nv+i] = new Atom(atoms_area.width-R,R+sep*i,nv+i,1,0,atoms); // all yellow-zero for now
      atoms[nv+i].stuck = true;
    }
    // make a random neighboring pair on one side into red-purple
    int side = int(random(2));
    int start = side*nv + 1+int(random(nv-2));
    atoms[start].type = 5; // purple
    atoms[start+1].type = 0; // red
    // set the colors of the other atoms on both sides to random colors in (red, yellow, purple)
    // but without making any more red-purple pairs
    int ts[] = {0,5,1}; // red, purple, yellow
    for(i=1;i<nv-1;i++)
    {
      if(atoms[i].type==1) // if currently yellow
      {
        do {
          atoms[i].type = ts[int(random(0,100))%3];
        } while((atoms[i].type==0 && atoms[i-1].type==5) || (atoms[i].type==5 && atoms[i-1].type==0) || 
          (atoms[i].type==0 && atoms[i+1].type==5) || (atoms[i].type==5 && atoms[i+1].type==0));
      }
    }
    for(i=nv+1;i<nv*2-1;i++)
    {
      if(atoms[i].type==1){
        do {
          atoms[i].type = ts[int(random(0,100))%3];
        } while((atoms[i].type==0 && atoms[i-1].type==5) || (atoms[i].type==5 && atoms[i-1].type==0) || 
          (atoms[i].type==0 && atoms[i+1].type==5) || (atoms[i].type==5 && atoms[i+1].type==0));
      }
    }
    // add the free-floating atoms
    int ts2[] = {2,3,4}; // green-, cyan-, blue-zero
    for(i=nv*2;i<nv*2+6;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,ts2[i%3],0,atoms);
    }
    // add the two bonded atoms (red-one, purple-one)
    i = nv*2+6;
    atoms[i] = new Atom(atoms_area.width/2,atoms_area.height/2,i,0,1,atoms);
    i++;
    atoms[i] = new Atom(atoms_area.width/2,atoms_area.height/2+2*R,i,5,1,atoms);
    atoms[i].makeBond(atoms[i-1]);
  }
  void evaluateSuccess()
  {
    if(atoms[atoms.length-2].hasBondWithType(atoms[atoms.length-2].type) && 
      atoms[atoms.length-1].hasBondWithType(atoms[atoms.length-1].type))
      succeeded = true;
  }
  void detectCheating()
  {
    for(int i=0;i<atoms.length-2;i++)
    {
      if(atoms[i].state!=0) {
        cheating_detected = true;
        cheating_message = "The atoms on the edges should have state 0 at all times. Try again.";
        return;
      }
    }
    if(!atoms[atoms.length-1].hasBondWith(atoms[atoms.length-2]))
    {
      cheating_detected = true;
      cheating_message = "The pair of atoms should remain bonded. Try again.";
      return;
    }
  }
}

//---------------------------------------------------

class MitosisChallenge extends Challenge {
  MitosisChallenge() {
    id = "mitosis";
    title = "Mitosis";
    desc = "Divide the loop into two separate loops. Keep the red atoms inside.";
    desc2 = "You can use the two state 2 atoms if you want.";
    min_reactions_required = 8;
  }
  void init() 
  {
    // make a loop of yellow atoms
    final int N = 20;
    atoms = new Atom[N+8];
    float radius = min(atoms_area.width/2,N*2*R/TWO_PI);
    for(int i=0;i<N;i++)
    {
      float angle = i*TWO_PI/N;
      int state = (i==0||i==N/2)?2:1;
      atoms[i] = new Atom(atoms_area.width/2+radius*cos(angle),atoms_area.height/2+radius*sin(angle),i,1,state,atoms);
    }
    for(int i=0;i<N;i++)
      atoms[i].makeBond(atoms[(i+1)%N]);
    // put two red atoms inside
    atoms[N] = new Atom(atoms_area.width/2,atoms_area.height/2-R,N,0,0,atoms);
    atoms[N+1] = new Atom(atoms_area.width/2,atoms_area.height/2+R,N+1,0,0,atoms);
    // scatter some other atoms
    final int s[] = { 2,3,4,5 }; // anything but yellow or red
    for(int i=N+2;i<atoms.length;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,s[i%4],0,atoms);
    }
  }
  void evaluateSuccess() 
  {
    // are there exactly two blocks of yellow atoms with every atom having exactly two bonds?
    int n_groups=0,n_total=0;
    boolean seen[] = new boolean[atoms.length];
    for(int i=0;i<atoms.length;i++)
      seen[i] = false;
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==1 && !seen[i])
      {
        ArrayList connected = getAllAtomsConnectedTo(atoms[i]);
        n_groups++;
        n_total += connected.size();
        // mark every atom as seen and check bonds
        for(int j=0;j<connected.size();j++)
        {
          Atom b = (Atom)connected.get(j);
          if(b.type!=1) return; // shouldn't have other types in the yellow groups
          if(b.bonds.size()!=2) return; // every yellow atom should have 2 bonds
          seen[b.id] = true;
        }
      }
    }
    if(n_groups==2 && n_total==20)
      succeeded = true;
  }
  void detectCheating()
  {
    // check that each red atom is within the bounding box of at least one of the connected groups of yellow atoms
    // (this is a weak check but better than nothing)
    Atom red1 = atoms[20];
    Atom red2 = atoms[21];
    boolean red1_inside = false;
    boolean red2_inside = false;
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==1)
      {
        ArrayList connected = getAllConnectedAtomsOfType(atoms[i],1);
        if(AtomInBoundingBox(red1, connected))
        {
            red1_inside = true;
        }
        if(AtomInBoundingBox(red2, connected))
        {
            red2_inside = true;
        }
      }
    }
    if(!red1_inside || !red2_inside)
    {
      cheating_detected = true;
      cheating_message = "The two red atoms should be kept inside. Try again.";
      return;
    }
  }
}

//---------------------------------------------------

