/*

 new ideas:
 
 - build something from scratch to achieve something: e.g. build a cross, 
 - 'rotation'
 - 'metabolise' : ingest, process, excrete (some artificial requirement: e.g. must keep atoms inside in pairs)
 - 'shapes fitting together' - hard version
 - hoist a blob up a cable against gravity
 - extend2: as extend, but without helpful starting states (for other levels too)
 - 'fold' (vague idea!)
 - zipalign: given two chains with partially matching colors, bond them together so that the matching bits overlap (cf. dna)
 - concertina ladder: as concertina but folding into a ladder shape
 
 
 ideas that need more thought:
 
 - 'coil' (not sure this can work)
 - make multiple copies of a molecule
 - build girder from floating triangles
 - rolling: roll a loop along a track (track widely spaced to avoid pulling approach?)
 - bud: break off a loop from a long chain (same as mitosis?)
 - engulf: break off a loop to enclose a thing
 - join two loose strands into a ladder?
 - squash: compress some loose atoms by having two pulling tracks and a dividing cable/girder
 
 rejected ideas:
 
 - bond an atom on the same side of a track as another atom in a different place (can you do it without needing to manually pull?) 
 - SqueezeChallenge (below) - same as Pull, but harder to evaluate
 
 */

// Level 0: Intro: no reactions needed, just pulling
// Level 1: Easy: needs one or two reactions, no pitfalls
// Level 2: Medium: up to three reactions, possible to make mistakes
// Level 3: Hard: needs a sequence of reactions
// Level 4: Fiendish: solution not obvious, needs experimentation and thought

Challenge teaser_challenges[] = {
  new LineChallenge(), // 0
  new JoinChallenge(), // 1
  new SurroundChallenge(), // 1.1
  new SplitLadderChallenge(), // 1
  new BreakOutChallenge(), // 1.5
  new SignalChallenge(), // 1.5
  new FitChallenge(), // 2
  new PairsChallenge(), // 2
  new CopyingChallenge(), // 2
  new ExtendChallenge(), // 2
  new AssemblyChallenge(), // 2.5
  new RainbowChallenge(), // 2.5
  new OneChallenge(), // 3
  new LinkChallenge(), // 3
  new BuildLadderChallenge(), // 3
};

class Challenge // base class for all our challenges
{
  String title,id,desc,desc2;
  boolean is_solved,allow_editing_of_reactions;
  String cheating_message;
  int min_reactions_required;
  void init() {
  }
  void evaluateSuccess() {
  }
  void detectCheating() {
  }
  Challenge() { 
    id = new String();
    title = new String(); 
    desc = new String(); 
    desc2 = new String();
    is_solved = false;
    allow_editing_of_reactions = true;
    cheating_message = new String();
    min_reactions_required = -1;
  }
  boolean isSolved() { 
    return is_solved;
  }
  void markAsSolved(boolean b) { 
    is_solved = b; 
    cheating_detected = false;
    if(b) 
      allow_editing_of_reactions = true; // (but leave true if was true before)
  }
}

//---------------------------------------------------

class LineChallenge extends Challenge 
{
  LineChallenge() {
    id = "line";
    title = "Line";
    desc = "Join all the atoms together in a line.";
    desc2 = "The reaction needed is already provided for you, so just pull the atoms into place.";
    allow_editing_of_reactions = false; // this is an intro level
  }
  void init()
  {
    atoms = new Atom[10];
    for (int i = 0; i < atoms.length; i++) 
    {
      int state = 0;
      if(i==0)
        state=1; 
      int type = 1;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
    // with this challenge we set up the reactions as required, to help the user understand
    reactions.clear();
    reactions.add(new Reaction(1,1,false,1,0,2,true,1));
  }

  void evaluateSuccess()
  {
    // are all the atoms connected?
    if(getAllAtomsConnectedTo(atoms[0]).size()==atoms.length)
      succeeded = true;
  }
}

//---------------------------------------------------

class JoinChallenge extends Challenge {
  JoinChallenge() { 
    id = "join";
    title = "Join";
    desc = "Join all the atoms together.";
    desc2 = "To solve this challenge you will have to add one or more reactions. Hit the '+' button, then click on the reaction to edit it.";
    min_reactions_required = 1;
  }
  void init()
  {
    atoms = new Atom[20];
    for (int i = 0; i < atoms.length; i++) 
    {
      int state = 0;
      int type = 2;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    // are all the atoms connected in a single block?
    if(getAllAtomsConnectedTo(atoms[0]).size()==atoms.length) 
      succeeded = true;
  }
}

//---------------------------------------------------

class SurroundChallenge extends Challenge {
  SurroundChallenge() { 
    id = "surround";
    title = "Surround";
    desc = "Join the six red atoms directly to the yellow atom.";
    min_reactions_required = 1;
  }
  void init()
  {
    atoms = new Atom[20];
    for (int i = 0; i < atoms.length; i++) 
    {
      int state = 0;
      int type = 0;
      if(i==0) type=1;
      else if(i<7) type=0;
      else type=2+i%4;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    // is atom 0 connected to six yellow atoms?
    if(atoms[0].bonds.size()!=6) return;
    for(int i=0;i<atoms[0].bonds.size();i++)
    {
      Atom a = (Atom)atoms[0].bonds.get(i);
      if(a.type!=0) return;
    }
    succeeded = true;
  }
}

//---------------------------------------------------

class PairsChallenge extends Challenge {
  PairsChallenge() {
    id = "pairs";
    title = "Pairs";
    desc = "Join all the atoms in red-green pairs.";
    desc2 = "(You will need to change their state numbers.)";
    min_reactions_required = 1;
  }
  void init() 
  {
    atoms = new Atom[20];
    for (int i = 0; i < atoms.length; i++) 
    {
      int state = 0;
      int type = (i%2==1)?0:2;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    // are all the red atoms connected to exactly one green atom?
    int n_true = 0;
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==0 && atoms[i].bonds.size()==1 && ((Atom)atoms[i].bonds.get(0)).type==2)
        n_true++;
    }
    // are all the green atoms connected to exactly one red atom?
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type==2 && atoms[i].bonds.size()==1 && ((Atom)atoms[i].bonds.get(0)).type==0)
        n_true++;
    }
    if(n_true==atoms.length)
      succeeded = true;
  }
}

//---------------------------------------------------

class BreakOutChallenge extends Challenge {
  BreakOutChallenge() {
    id = "breakout";
    title = "Break out";
    desc = "Bond the red and purple atoms together.";
    min_reactions_required = 2;
  }
  void init()
  {
    atoms = new Atom[24];
    PVector p1 = new PVector(atoms_area.width/2,atoms_area.height/4);
    PVector p2 = new PVector(atoms_area.width/2,3*atoms_area.height/4);
    atoms[0] = new Atom(p1.x,p1.y,0,0,0,atoms);
    atoms[1] = new Atom(p2.x,p2.y,1,5,0,atoms);
    final int N = 7;
    for(int i=0;i<N;i++)
    {
      atoms[2+i] = new Atom(p1.x+R*2.6*cos(i*TWO_PI/N),p1.y+R*2.6*sin(i*TWO_PI/N),
      2+i,1,1,atoms);
    }
    for(int i=0;i<N-1;i++)
      atoms[2+i].makeBond(atoms[2+i+1]);
    atoms[2+N-1].makeBond(atoms[2]);
    for(int i=0;i<N;i++)
    {
      atoms[2+N+i] = new Atom(p2.x+R*2.6*cos(i*TWO_PI/N),p2.y+R*2.6*sin(i*TWO_PI/N),
      2+N+i,1,1,atoms);
    }
    for(int i=0;i<N-1;i++)
      atoms[2+N+i].makeBond(atoms[2+N+i+1]);
    atoms[2+N+N-1].makeBond(atoms[2+N]);
    for (int i = 2+N+N; i < atoms.length; i++) 
    {
      int state = 0;
      int type = 2+i%3;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    succeeded = atoms[0].hasBondWith(atoms[1]);
  }
}

//---------------------------------------------------

class OneChallenge extends Challenge {
  OneChallenge() {
    id = "one";
    title = "One";
    desc = "Put all the atoms into state 1";
    min_reactions_required = 3;
  }
  void init()
  {
    atoms = new Atom[24];
    for (int i = 0; i < atoms.length; i++) 
    {
      int state = 0;
      int type = i%3;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    // are all the atoms in state 1?
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].state!=1) 
        return;
    }
    succeeded = true;
  }
}

//---------------------------------------------------

class LinkChallenge extends Challenge {
  LinkChallenge() {
    id = "link";
    title = "Link";
    desc = "Make a chain to connect the two fixed atoms.";
    min_reactions_required = 2;
  }
  void init()
  {
    atoms = new Atom[14];
    atoms[0] = new Atom(R,atoms_area.height/2,0,1,3,atoms);
    atoms[0].stuck = true;
    atoms[1] = new Atom(atoms_area.width-R,atoms_area.height/2,1,1,4,atoms);
    atoms[1].stuck = true;
    for (int i = 2; i < atoms.length; i++) 
    {
      int state = 0;
      int type = 1;
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,type,state,atoms);
    }
  }
  void evaluateSuccess()
  {
    // are atoms 0 and 1 connected?
    succeeded = getAllAtomsConnectedTo(atoms[0]).contains(atoms[1]);
  }
}

//---------------------------------------------------

class SplitLadderChallenge extends Challenge {
  SplitLadderChallenge() {
    id="split_ladder";
    title = "Split ladder";
    desc = "Split the ladder down the middle.";
    min_reactions_required = 1;
  }
  void init()
  {
    atoms = new Atom[20];
    for (int i = 0; i < atoms.length; i++) 
    {
      int type = 3;
      int state = 1+i%2;
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

class BuildLadderChallenge extends Challenge {
  BuildLadderChallenge() {
    id = "build_ladder";
    title = "Build ladder";
    desc = "Build the rest of the ladder.";
    min_reactions_required = 2;
  }
  void init()
  {
    atoms = new Atom[20];
    atoms[0] = new Atom(atoms_area.width/2-R,atoms_area.height-R,0,5,1,atoms);
    atoms[0].stuck = true;
    atoms[1] = new Atom(atoms_area.width/2+R,atoms_area.height-R,1,5,1,atoms);
    atoms[1].stuck = true;
    atoms[1].makeBond(atoms[0]);
    atoms[2] = new Atom(atoms_area.width/2-R,atoms_area.height-R*3,2,5,1,atoms);
    atoms[3] = new Atom(atoms_area.width/2+R,atoms_area.height-R*3,3,5,1,atoms);
    atoms[3].makeBond(atoms[2]);
    atoms[2].makeBond(atoms[0]);
    atoms[3].makeBond(atoms[1]);
    atoms[4] = new Atom(atoms_area.width/2-R,atoms_area.height-R*5,4,5,2,atoms);
    atoms[5] = new Atom(atoms_area.width/2+R,atoms_area.height-R*5,5,5,2,atoms);
    atoms[5].makeBond(atoms[4]);
    atoms[4].makeBond(atoms[2]);
    atoms[5].makeBond(atoms[3]);
    for(int i=6;i<atoms.length;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,5,0,atoms);
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
    if(getAllAtomsConnectedTo(atoms[0]).size()!=20) 
      return;
    succeeded=true;
  }
}

//---------------------------------------------------

class SignalChallenge extends Challenge {
  SignalChallenge() {
    id = "signal";
    title = "Signal";
    desc = "Set all the atoms to state 2 by passing the signal down the molecule.";
    desc2 = "Don't make or break any bonds.";
    min_reactions_required = 1;
  }
  void init()
  {
    int n_v = ceil((atoms_area.height-R*2)/(2*R));
    atoms = new Atom[n_v];
    for(int i=0;i<n_v;i++)
    {
      atoms[i] = new Atom(atoms_area.width/2,R+i*(atoms_area.height-R*2)/(n_v-1),i,2,i==0?2:1,atoms);
      if(i>0)
        atoms[i].makeBond(atoms[i-1]);
    }
  }
  void evaluateSuccess()
  {
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].state!=2) 
        return;
    }
    succeeded = true;
  }
  void detectCheating()
  {
    for(int i=0;i<reactions.size();i++)
    {
      Reaction r = (Reaction)reactions.get(i);
      if(!r.bonded_pre | !r.bonded_post)
      {
        cheating_detected = true;
        cheating_message = "Only use reactions that leave the atoms bonded together. Try again.";
        return;
      }
    }
  }
}

//---------------------------------------------------

class AssemblyChallenge extends Challenge { // compare with how clathrin works
  AssemblyChallenge() {
    id = "assembly";
    title = "Assembly";
    desc = "Bond the matching state 0 markers to assemble a structure.";
    min_reactions_required = 5;
  }
  void init() 
  {
    final int s[] = {
      0,2,3,4,5
    }; // anything but yellow
    final int N = 5;
    atoms = new Atom[N*5];
    for(int i=0;i<N;i++)
    {
      float y = i*2*R*4;
      atoms[5*i+0] = new Atom(atoms_area.width/2-R,atoms_area.height-R-y,5*i+0,1,1,atoms);
      atoms[5*i+1] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*2-y,5*i+1,s[i],0,atoms);
      atoms[5*i+1].makeBond(atoms[5*i+0]);
      atoms[5*i+2] = new Atom(atoms_area.width/2-R,atoms_area.height-R*3-y,5*i+2,1,1,atoms);
      atoms[5*i+3] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*4-y,5*i+3,s[(i+1)%N],0,atoms);
      atoms[5*i+3].makeBond(atoms[5*i+2]);
      atoms[5*i+2].makeBond(atoms[5*i+0]);
      atoms[5*i+3].makeBond(atoms[5*i+1]);
      atoms[5*i+2].makeBond(atoms[5*i+1]);
      atoms[5*i+4] = new Atom(atoms_area.width/2-R,atoms_area.height-R*5-y,5*i+4,1,1,atoms);
      atoms[5*i+4].makeBond(atoms[5*i+2]);
      atoms[5*i+4].makeBond(atoms[5*i+3]);
    }
    // (chains start off-screen but we actually liked the effect)
  }
  void evaluateSuccess()  
  {
    // is every non-yellow atom bonded with another of its own type?
    for(int i=0;i<atoms.length;i++)
    {
      if(atoms[i].type!=1)
      {
        boolean has_bond_with_same_type = false;
        for(int j=0;j<atoms[i].bonds.size();j++)
        {
          Atom b = (Atom)atoms[i].bonds.get(j);
          if(b.type==atoms[i].type)
          {
            has_bond_with_same_type = true;
            break;
          }
        }
        if(!has_bond_with_same_type)
          return;
      }
    }
    succeeded = true;
  }
  void detectCheating()
  {
    for(int i=0;i<reactions.size();i++)
    {
      Reaction r = (Reaction)reactions.get(i);
      if(r.bonded_pre | !r.bonded_post)
      {
        cheating_detected = true;
        cheating_message = "You don't need to use reactions that break bonds. Try again.";
        return;
      }
    }
  }
}

//---------------------------------------------------

class CopyingChallenge extends Challenge {
  CopyingChallenge() {
    id = "copying";
    title = "Copying";
    desc = "Bond a single matching color to each atom in the chain.";
    min_reactions_required = 3;
  }
  void init()
  {
    atoms = new Atom[30];
    final int N = 9;
    for(int i=0;i<N;i++)
    {
      int type = int(random(300))%3;
      atoms[i] = new Atom(R,atoms_area.height/2-2*R*((N-1)/2)+2*R*i,i,type,1,atoms);
      if(i>0)
        atoms[i].makeBond(atoms[i-1]);
      if(i==0 || i==N-1)
        atoms[i].stuck = true;
    }
    for(int i=9;i<atoms.length;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,atoms[i%N].type,0,atoms);
    }
  }
  void evaluateSuccess()
  {
    for(int i=0;i<8;i++)
    {
      int expected_n_bonds = 3;
      if(i==0 || i==8) expected_n_bonds = 2;
      if(atoms[i].bonds.size()!=expected_n_bonds) return;
      if(((Atom)atoms[i].bonds.get(atoms[i].bonds.size()-1)).type != atoms[i].type)
        return;
    }
    if(getAllAtomsConnectedTo(atoms[0]).size()!=18)
      return;
    succeeded = true;
  }
}

//---------------------------------------------------

class ExtendChallenge extends Challenge {
  ExtendChallenge() {
    id = "extend";
    title = "Extend";
    desc = "Break some of the bonds to extend the chain far enough to bond the two green atoms together.";
    desc2 = "But don't break the chain in two.";
    min_reactions_required = 3;
  }
  void init()
  {
    int nv = int(atoms_area.height / (2*R));
    int ns = int(nv/2);
    nv = ns*2;
    atoms = new Atom[nv+2];
    atoms[0] = new Atom(atoms_area.width/2-R,atoms_area.height-R,0,5,1,atoms);
    atoms[0].stuck = true;
    atoms[1] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*2,1,5,2,atoms);
    atoms[1].stuck = true;
    atoms[1].makeBond(atoms[0]);
    for(int i=2;i<nv;i+=2)
    {
      atoms[i] = new Atom(atoms_area.width/2-R,atoms_area.height-R-R*i,i,5,1,atoms);
      atoms[i+1] = new Atom(atoms_area.width/2-R+2*R*sin(60*TWO_PI/180),atoms_area.height-R*2-R*i,i+1,5,2,atoms);
      atoms[i+1].makeBond(atoms[i]);
      atoms[i].makeBond(atoms[i-2]);
      atoms[i+1].makeBond(atoms[i-1]);
      atoms[i].makeBond(atoms[i-1]);
    }
    atoms[nv] = new Atom(atoms_area.width/2-R,atoms_area.height-R-R*nv,nv,2,1,atoms);
    atoms[nv].makeBond(atoms[nv-1]);
    atoms[nv+1] = new Atom(atoms_area.x+atoms_area.width/2,R,nv+1,2,1,atoms);
    atoms[nv+1].stuck = true;
  }
  void detectCheating()
  {
    if(getAllAtomsConnectedTo(atoms[0]).size()<atoms.length-1)
    {
      cheating_detected = true;
      cheating_message = "The chain should be in one connected piece at all times. Try again.";
      return;
    }
  }
  void evaluateSuccess()
  {
    if(getAllAtomsConnectedTo(atoms[0]).size()==atoms.length)
      succeeded = true;
  }
}

//---------------------------------------------------

class SqueezeChallenge extends Challenge { // (not currently using this one)
  SqueezeChallenge() {
    id = "squeeze";
    title = "Squeeze";
    desc = "By pulling the green atom along the yellow track, squeeze the red atoms together.";
    desc2 = "";
  }
  void init() 
  {
    final int N = 20;
    atoms = new Atom[N+2+6];
    float radius = min(atoms_area.width/2,N*2*R/TWO_PI);
    int i=0;
    for(i=0;i<N;i++)
    {
      float angle = i*TWO_PI/N;
      int state = (i==0)?2:1;
      int type = (i==0)?2:1;
      atoms[i] = new Atom(atoms_area.width/2+radius*cos(angle),atoms_area.height/2+radius*sin(angle),i,type,state,atoms);
    }
    for(i=0;i<N;i++)
      atoms[i].makeBond(atoms[(i+1)%N]);
    atoms[N-1].state=3;
    i=N;
    atoms[i] = new Atom(atoms_area.width/2+radius*cos(0)+2*R,atoms_area.height/2+radius*sin(0),i,1,4,atoms);
    atoms[i].makeBond(atoms[i-1]);
    i++;
    atoms[i] = new Atom(atoms_area.width/2+radius*cos(0)+2*R*2,atoms_area.height/2+radius*sin(0),i,1,4,atoms);
    atoms[i].makeBond(atoms[i-1]);
    i++;
    for(;i<atoms.length;i++)
    {
      atoms[i] = new Atom(atoms_area.width/2-(i-(N+2))*R,atoms_area.height/2,i,0,0,atoms);
    }
  }
  void evaluateSuccess() 
  {
  }
}

//---------------------------------------------------

class RainbowChallenge extends Challenge {
  RainbowChallenge() {
    id = "rainbow";
    title = "Rainbow chains";
    desc = "Join the atoms into five rainbow chains.";
    desc2 = "Each chain should consist of six atoms: red, yellow, green, light blue, dark blue, purple, in that order.";
    min_reactions_required = 5;
  }
  void init() 
  {
    atoms = new Atom[5*6];
    for(int i=0;i<atoms.length;i++)
    {
      PVector pos = findAClearPlaceForAtom();
      atoms[i] = new Atom(pos.x,pos.y,i,i%6,0,atoms);
    }
  }
  void evaluateSuccess()
  {
    for(int i=0;i<atoms.length;i++)
    {
      switch(atoms[i].type)
      {
        case 0: 
          if(atoms[i].bonds.size()!=1) return; 
          if(!atoms[i].hasBondWithType(1)) return;
          break;
        case 1:
          if(atoms[i].bonds.size()!=2) return;
          if(!atoms[i].hasBondWithType(0) || !atoms[i].hasBondWithType(2)) return;
          break;
        case 2:
          if(atoms[i].bonds.size()!=2) return;
          if(!atoms[i].hasBondWithType(1) || !atoms[i].hasBondWithType(3)) return;
          break;
        case 3:
          if(atoms[i].bonds.size()!=2) return;
          if(!atoms[i].hasBondWithType(2) || !atoms[i].hasBondWithType(4)) return;
          break;
        case 4:
          if(atoms[i].bonds.size()!=2) return;
          if(!atoms[i].hasBondWithType(3) || !atoms[i].hasBondWithType(5)) return;
          break;
        case 5:
          if(atoms[i].bonds.size()!=1) return;
          if(!atoms[i].hasBondWithType(4)) return;
          break;
      }   
    }
    succeeded = true;
  }
}

//---------------------------------------------------

class FitChallenge extends Challenge {
  FitChallenge() {
    id = "fit";
    title = "Fit";
    desc = "Glue the two pieces together to make a perfect hexagon, with all the bonds intact.";
    min_reactions_required = 6;
  }
  void init()
  {
    // make a hexagon of atoms, 4 on a side
    atoms = new Atom[37];
    int i=0;
    int row_length[] = {4,5,6,7,6,5,4};
    float row_inset[] = {3*R,2*R,R,0,R,2*R,3*R};
    float vd = 2*R; // TODO: unit equilateral triangle height
    int shell[] = {0,0,0,0,0,1,1,1,0,0,1,2,2,1,0,0,1,2,3,2,1,0,0,1,2,2,1,0,0,1,1,1,0,0,0,0,0};
    int half[] =  {0,0,0,1,0,0,0,1,1,0,0,0,1,1,1,0,0,0,0,1,1,1,0,0,0,1,1,1,0,0,1,1,1,0,0,1,1};
    for(int y=0;y<7;y++)
    {
      for(int x=0;x<row_length[y];x++)
      {
        atoms[i] = new Atom(atoms_area.width/2-3*2*R+row_inset[y]+x*2*R-2*R+half[i]*4*R,atoms_area.height/2-3*vd+y*vd-4*R+half[i]*8*R,i,shell[i],0,atoms);
        if(x>0) atoms[i].makeBond(atoms[i-1]);
        if((y>0 && x<row_length[y]-1) || (y>3)) atoms[i].makeBond(atoms[i-row_length[y-1]]);
        if(y>3) atoms[i].makeBond(atoms[i-row_length[y-1]+1]);
        if(x>0 && y>0 && y<=3) atoms[i].makeBond(atoms[i-row_length[y-1]-1]);
        i++;
      }
    }
    // split the hexagon
    for(i=0;i<atoms.length;i++)
      for(int j=0;j<atoms.length;j++)
        if(half[i]!=half[j])
          atoms[i].breakBond(atoms[j]);
  }
  void evaluateSuccess()
  {
    int row_length[] = {4,5,6,7,6,5,4};
    int i=0;
    for(int y=0;y<7;y++)
    {
      for(int x=0;x<row_length[y];x++)
      {
        if(x>0) if(!atoms[i].hasBondWith(atoms[i-1])) return;
        if((y>0 && x<row_length[y]-1) || (y>3)) if(!atoms[i].hasBondWith(atoms[i-row_length[y-1]])) return;
        if(y>3) if(!atoms[i].hasBondWith(atoms[i-row_length[y-1]+1])) return;
        if(x>0 && y>0 && y<=3) if(!atoms[i].hasBondWith(atoms[i-row_length[y-1]-1])) return;
        i++;
      }
    }
    succeeded = true;
  }
}

//---------------------------------------------------

