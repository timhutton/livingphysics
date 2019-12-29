class Reaction
{
  int a_type,a_state_pre,a_state_post;
  int b_type,b_state_pre,b_state_post;
  boolean bonded_pre,bonded_post;
  
  Reaction(int a_type_in,int a_state_pre_in,boolean bonded_pre_in,int b_type_in,int b_state_pre_in,
           int a_state_post_in,boolean bonded_post_in,int b_state_post_in)
  {
    a_type = a_type_in;
    a_state_pre = a_state_pre_in;
    bonded_pre = bonded_pre_in;
    b_type = b_type_in;
    b_state_pre = b_state_pre_in;
    a_state_post = a_state_post_in;
    bonded_post = bonded_post_in;
    b_state_post = b_state_post_in;
  }
  
  void tryReaction(Atom a,Atom b)
  {
    //if(events.size()>0) return; // slow chain reactions down (didn't like this because it stopped things happening when expected)
    // shortcut for null reactions (don't want the visual overload that results)
    if(bonded_pre==bonded_post && a_state_pre==a_state_post && b_state_pre==b_state_post)
      return;
    else if(matchesForA(a) && matchesForB(b) && bondMatches(a,b))
    {
      a.state = a_state_post;
      b.state = b_state_post;
      if(!bonded_pre && bonded_post) a.makeBond(b);
      if(bonded_pre && !bonded_post) a.breakBond(b);
      a.addReactionEvent(b);
      last_reaction=this;
      last_reaction_age=0;
    }
    else if(matchesForA(b) && matchesForB(a) && bondMatches(a,b))
    {
      a.state = b_state_post;
      b.state = a_state_post;
      if(!bonded_pre && bonded_post) a.makeBond(b);
      if(bonded_pre && !bonded_post) a.breakBond(b);
      a.addReactionEvent(b);
      last_reaction=this;
      last_reaction_age=0;
    }
  }
  
  boolean matchesForA(Atom atom)
  {
    return atom.type==a_type && atom.state==a_state_pre;
  }
  
  boolean matchesForB(Atom atom)
  {
    return atom.type==b_type && atom.state==b_state_pre;
  }
  
  boolean bondMatches(Atom a,Atom b)
  {
    return bonded_pre == a.hasBondWith(b);
  }
  
  String asString()
  {
    char at = "abcdef".charAt(a_type);
    char bt = "abcdef".charAt(b_type);
    return new String(at+str(a_state_pre)+(bonded_pre?"-":"+")+bt+str(b_state_pre)+
      "->"+at+str(a_state_post)+(bonded_post?"-":"+")+bt+str(b_state_post));
  }
  
  Reaction(String s)
  {
    // for now we assume single digit states, e.g. a3+b1->a5-b2
    a_type = "abcdef".indexOf(s.charAt(0));
    a_state_pre = "0123456789".indexOf(s.charAt(1));
    bonded_pre = ("-+".indexOf(s.charAt(2))==0);
    b_type = "abcdef".indexOf(s.charAt(3));
    b_state_pre = "0123456789".indexOf(s.charAt(4));
    a_state_post = "0123456789".indexOf(s.charAt(8));
    bonded_post = ("-+".indexOf(s.charAt(9))==0);
    b_state_post = "0123456789".indexOf(s.charAt(11));
  }
}
