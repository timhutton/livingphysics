float editing_y,editing_radius;
int i_atom_being_edited=-1;
boolean showing_reaction_editor_help = false;
Rect delete_this_reaction_rect,done_editing_this_reaction_rect,help_with_editing_reaction_rect;
Rect reaction_editing_window;

void showReactionEditor()
{
  noStroke();
  fill(0,0,0,GLOBAL_ALPHA);
  rect(0,0,width,height);
  // draw the dialog outline
  reaction_editing_window = new Rect(0,height/2-200*pix,width-1,400*pix);
  stroke(230,140,100);
  strokeWeight(1*pix);
  fill(0,0,0,GLOBAL_ALPHA);
  reaction_editing_window.drawRect();

  editing_radius = 30*pix;

  Reaction r = (Reaction)reactions.get(i_reaction_being_edited);
  editing_y=reaction_editing_window.y+editing_radius*2;
  float p1=editing_radius*1.5;
  float p2=editing_radius*5.5;
  float p5=editing_radius*7;
  float p6=editing_radius*9;
  float p3=editing_radius*10.5;
  float p4=editing_radius*14;
  stroke(200,200,200,GLOBAL_ALPHA);
  strokeWeight(6*pix);
  if(r.bonded_pre) line(p1+editing_radius,editing_y,p2-editing_radius,editing_y);
  if(r.bonded_post) line(p3+editing_radius,editing_y,p4-editing_radius,editing_y);
  line(p5,editing_y,p6,editing_y);
  line(p6-10*pix,editing_y-10*pix,p6,editing_y);
  line(p6-10*pix,editing_y+10*pix,p6,editing_y);
  drawAnAtom(p1,editing_y,editing_radius,r.a_type,r.a_state_pre,ATOMS_ALPHA);
  drawAnAtom(p2,editing_y,editing_radius,r.b_type,r.b_state_pre,ATOMS_ALPHA);
  drawAnAtom(p3,editing_y,editing_radius,r.a_type,r.a_state_post,ATOMS_ALPHA);
  drawAnAtom(p4,editing_y,editing_radius,r.b_type,r.b_state_post,ATOMS_ALPHA);
  if(i_atom_being_edited>=0)
  {
    noFill();
    stroke(255,255,255,GLOBAL_ALPHA);
    strokeWeight(2*pix);
    switch(i_atom_being_edited) {
    case 0: 
      rect(p1-editing_radius-3*pix,editing_y-editing_radius-3*pix,editing_radius*2+6*pix,editing_radius*2+6*pix); 
      break;
    case 1: 
      rect(p2-editing_radius-3*pix,editing_y-editing_radius-3*pix,editing_radius*2+6*pix,editing_radius*2+6*pix); 
      break;
    case 2: 
      rect(p3-editing_radius-3*pix,editing_y-editing_radius-3*pix,editing_radius*2+6*pix,editing_radius*2+6*pix); 
      break;
    case 3: 
      rect(p4-editing_radius-3*pix,editing_y-editing_radius-3*pix,editing_radius*2+6*pix,editing_radius*2+6*pix); 
      break;
    }
    for(int type=0;type<6;type++)
      drawAnAtom(editing_radius*1.5 + editing_radius*2.55*type,editing_y+editing_radius*3,editing_radius,type,-1,ATOMS_ALPHA);
    for(int state=0;state<10;state++)
      drawAnAtom(editing_radius*1 + editing_radius*1.55*state,editing_y+editing_radius*6,editing_radius,-1,state,ATOMS_ALPHA);
  }

  help_with_editing_reaction_rect = new Rect(editing_radius*2,editing_y+editing_radius*7.8,80*pix,80*pix);
  help_with_editing_reaction_rect.drawImage(help_image);
  delete_this_reaction_rect = new Rect(editing_radius*7,editing_y+editing_radius*7.8,80*pix,80*pix);
  delete_this_reaction_rect.drawImage(trashcan_image);
  done_editing_this_reaction_rect = new Rect(editing_radius*12,editing_y+editing_radius*7.8,80*pix,80*pix);
  done_editing_this_reaction_rect.drawImage(tick_image);

  if(!showing_message && !showed_join_hint && match(challenges[iChallenge].title,"Join")!=null)
  {
    message_being_shown = new String("Hint:    Click *between* the two atoms on the right to specify that they should bond together.");
    showing_message = true;
    showed_join_hint = true;
  }

  if(!showing_message && !showed_surround_hint && match(challenges[iChallenge].title,"Surround")!=null)
  {
    message_being_shown = new String("Hint:    Click *on* an atom in this window to change its color or its state number.");
    showing_message = true;
    showed_surround_hint = true;
  }

  if(!showing_message && !showed_split_ladder_hint && match(challenges[iChallenge].title,"Split ladder")!=null)
  {
    message_being_shown = new String("Hint:   To split two atoms, have them bonded on the left of the reaction but not on the right.");
    showing_message = true;
    showed_split_ladder_hint = true;
  }
  
  if(showing_reaction_editor_help)
    showReactionEditorHelp();
}

void mousePressedInReactionEditor()
{
  if(asking_can_delete_reaction)
  {
    if(nearerThan(mouseX-(width/2-140*pix+40*pix),mouseY-(300*pix+40*pix),45*pix)) // cancel
    {
      asking_can_delete_reaction=false;
    }
    else if(nearerThan(mouseX-(width/2+140*pix-40*pix),mouseY-(300*pix+40*pix),45*pix)) // tick
    {
      asking_can_delete_reaction=false;
      reactions.remove(i_reaction_being_edited);
      editing_reaction = false;
    }
  }
  else if(showing_reaction_editor_help)
    mousePressedInReactionEditorHelpMode();
  else 
  {
    if(mouseX>editing_radius*2.5 && mouseX<editing_radius*4.5 && abs(mouseY-editing_y)<editing_radius) // click on bonded-pre
    {
      Reaction r = (Reaction)reactions.get(i_reaction_being_edited);
      r.bonded_pre = !r.bonded_pre;
      i_atom_being_edited=-1;
    }
    else if(mouseX>editing_radius*11.5 && mouseX<editing_radius*13 && abs(mouseY-editing_y)<editing_radius) // click on bonded-post
    {
      Reaction r = (Reaction)reactions.get(i_reaction_being_edited);
      r.bonded_post = !r.bonded_post;
      i_atom_being_edited=-1;
    }
    else if(nearerThan(mouseX-editing_radius*1.5,mouseY-editing_y,editing_radius))
    {
      i_atom_being_edited=0;
    }
    else if(nearerThan(mouseX-editing_radius*5.5,mouseY-editing_y,editing_radius))
    {
      i_atom_being_edited=1;
    }
    else if(nearerThan(mouseX-editing_radius*10.5,mouseY-editing_y,editing_radius))
    {
      i_atom_being_edited=2;
    }
    else if(nearerThan(mouseX-editing_radius*14,mouseY-editing_y,editing_radius))
    {
      i_atom_being_edited=3;
    }
    else if(i_atom_being_edited>=0)
    {
      if(abs(mouseY-(editing_y+editing_radius*3))<editing_radius)
      {
        int new_type = constrain(int((mouseX-editing_radius*0.3)/(editing_radius*2.55)),0,5);
        Reaction r = (Reaction)reactions.get(i_reaction_being_edited);
        if(i_atom_being_edited==0 || i_atom_being_edited==2)
          r.a_type = new_type;          
        else
          r.b_type = new_type;
      }
      else if(abs(mouseY-(editing_y+editing_radius*6))<editing_radius)
      {
        int new_state = constrain(int((mouseX-editing_radius*0.15)/(editing_radius*1.55)),0,9);
        Reaction r = (Reaction)reactions.get(i_reaction_being_edited);
        switch(i_atom_being_edited) {
        case 0: 
          r.a_state_pre = new_state; 
          break;
        case 1: 
          r.b_state_pre = new_state; 
          break;
        case 2: 
          r.a_state_post = new_state; 
          break;
        case 3: 
          r.b_state_post = new_state; 
          break;
        }
      }
      else if(done_editing_this_reaction_rect.contains(mouseX,mouseY)) // tick
      {
        i_atom_being_edited=-1;
        editing_reaction=false;
      }
      else if(delete_this_reaction_rect.contains(mouseX,mouseY)) // trashcan
      {
        i_atom_being_edited=-1;
        asking_can_delete_reaction = true;
      }
      else if(help_with_editing_reaction_rect.contains(mouseX,mouseY)) // help
      {
        showing_reaction_editor_help = true;
      }
      else
      {
        i_atom_being_edited=-1;
      }
    }
    else if(done_editing_this_reaction_rect.contains(mouseX,mouseY)) // tick
    {
      i_atom_being_edited=-1;
      editing_reaction=false;
    }
    else if(delete_this_reaction_rect.contains(mouseX,mouseY)) // trashcan
    {
      i_atom_being_edited=-1;
      asking_can_delete_reaction = true;
    }
    else if(help_with_editing_reaction_rect.contains(mouseX,mouseY)) // help
    {
      showing_reaction_editor_help = true;
    }
    else
    {
      // clicked on neutral space
      i_atom_being_edited=-1;
    }
  }
}

void mouseReleasedInReactionEditor()
{
  if(showing_reaction_editor_help)
    mouseReleasedInReactionEditorHelpMode();
}

void backButtonPressedInReactionEditor()
{
  if(showing_reaction_editor_help)
    showing_reaction_editor_help = false;
  else if(showing_message)
    showing_message = false;
  else if(asking_can_delete_reaction)
    asking_can_delete_reaction = false;
  else
  {
     i_atom_being_edited=-1;
     editing_reaction = false;
  }
}
