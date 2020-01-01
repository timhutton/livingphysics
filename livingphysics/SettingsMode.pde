int dialog_border_left, dialog_border_right;
boolean is_dragging_settings_dialog = false;
int dragged_settings_dialog_y;
float settings_dialog_scrollPos = 0;
float excess_height;
float reactions_start_y;
float radius;
boolean asking_can_delete_all_reactions=false;
boolean asking_can_reload_challenge=false;
Rect delete_all_reactions_rect,done_editing_reactions_rect,
  reload_rect,levels_rect,add_reaction_rect,help_with_level_rect;

boolean editing_reaction=false;
int i_reaction_being_edited;
boolean asking_can_delete_reaction=false;

boolean showing_message = false;
String message_being_shown;
boolean showed_join_hint = false;
boolean showed_surround_hint = false;
boolean showed_split_ladder_hint = false;

boolean showing_levels = false;
boolean showing_settings_help = false;

void drawSettingsMode()
{
  // need to set these here too for textHeight
  setTextSize(30*pix);
  textAlign(LEFT,TOP);

  String challenge_text = "Challenge "+str(iChallenge+1)+": \""+challenges[iChallenge].title+"\"\n\n" +
    challenges[iChallenge].desc;
  if(challenges[iChallenge].desc2.length()>0)
    challenge_text += "\n\n" + challenges[iChallenge].desc2;
  if(challenges[iChallenge].min_reactions_required>0)
    challenge_text += "\n\n(A good solution might require " +
      ((challenges[iChallenge].min_reactions_required>1)?
      ("as few as "+str(challenges[iChallenge].min_reactions_required)+" reactions.)"):
      "only one reaction.)");

  dialog_border_left = int(20*pix);
  dialog_border_right = int(60*pix);
  radius = 22*pix;
  final float challenge_text_height = textHeight(challenge_text,width-dialog_border_left-dialog_border_right-20*pix)+10*pix;
  float reactions_y = challenge_text_height+40*pix;
  reactions_start_y = reactions_y+60*pix;
  float panel_height = reactions_start_y + reactions.size()*radius*3+radius*8;
  excess_height = max(0,panel_height - height);

  if(is_dragging_settings_dialog)
  {
    settings_dialog_scrollPos += dragged_settings_dialog_y-mouseY;
    dragged_settings_dialog_y = mouseY;
  }
  settings_dialog_scrollPos = constrain(settings_dialog_scrollPos,0,excess_height);

  drawAtomsMode();

  // (need to re-set these in case changed in atoms mode drawing)
  setTextSize(30*pix);
  textAlign(LEFT,TOP);

  // draw the dialog outline
  stroke(230,140,100);
  strokeWeight(1*pix);
  fill(0,0,0,GLOBAL_ALPHA);
  rect(dialog_border_left,-2*pix,width-dialog_border_left-dialog_border_right,height+4*pix);

  // show the challenge text
  fill(255,255,255,GLOBAL_ALPHA);
  drawText(challenge_text,dialog_border_left+10*pix,10*pix-settings_dialog_scrollPos,width-dialog_border_left-dialog_border_right-20*pix);

  // show the reactions
  float p1=dialog_border_left+radius*1.5;
  float p2=dialog_border_left+radius*4.5;
  float p3=dialog_border_left+radius*9;
  float p4=dialog_border_left+radius*12;
  float p5=dialog_border_left+radius*6;
  float p6=dialog_border_left+radius*7.5;
  noStroke();
  fill(50,50,50,GLOBAL_ALPHA);
  rect(dialog_border_left+5*pix,reactions_start_y-radius*3.5-settings_dialog_scrollPos,p4-p1+radius*3,reactions.size()*radius*3+radius*6.5);
  setTextSize(30*pix);
  textAlign(LEFT,TOP);
  fill(255,255,255,GLOBAL_ALPHA);
  text("Reactions:",dialog_border_left+10*pix,reactions_y-settings_dialog_scrollPos);
  for(int i=0;i<reactions.size();i++)
  {
    float y = reactions_start_y+i*radius*3-settings_dialog_scrollPos;
    Reaction r = (Reaction)reactions.get(i);
    noStroke();
    fill(0,0,0,GLOBAL_ALPHA);
    rect(p1-radius*1.1,y-radius*1.1,
    (p4+radius*1.1)-(p1-radius*1.1),radius*1.1*2);
    stroke(200,200,200,GLOBAL_ALPHA);
    strokeWeight(6*pix);
    if(r.bonded_pre) line(p1+radius,y,p2-radius,y);
    if(r.bonded_post) line(p3+radius,y,p4-radius,y);
    line(p5,y,p6,y);
    line(p6-10*pix,y-10*pix,p6,y);
    line(p6-10*pix,y+10*pix,p6,y);
    drawAnAtom(p1,y,radius,r.a_type,r.a_state_pre,ATOMS_ALPHA);
    drawAnAtom(p2,y,radius,r.b_type,r.b_state_pre,ATOMS_ALPHA);
    drawAnAtom(p3,y,radius,r.a_type,r.a_state_post,ATOMS_ALPHA);
    drawAnAtom(p4,y,radius,r.b_type,r.b_state_post,ATOMS_ALPHA);
  }

  help_with_level_rect = new Rect(dialog_border_left+radius*1,
    reactions_start_y+reactions.size()*radius*3+radius*4-settings_dialog_scrollPos,
    80*pix,80*pix);
  help_with_level_rect.drawImage(help_image);

  if(challenges[iChallenge].allow_editing_of_reactions)
  {
    if(reactions.size()>0)
    {
      delete_all_reactions_rect = new Rect(dialog_border_left+radius*1,
        reactions_start_y+reactions.size()*radius*3-radius-settings_dialog_scrollPos,
        70*pix,70*pix);
      delete_all_reactions_rect.drawImage(trashcan_image);
    }
    add_reaction_rect = new Rect(dialog_border_left+radius*6,
      reactions_start_y+reactions.size()*radius*3-radius-settings_dialog_scrollPos,
      70*pix,70*pix);
    add_reaction_rect.drawImage(add_image);
  }

  levels_rect = new Rect(dialog_border_left+radius*5.4,
    reactions_start_y+reactions.size()*radius*3+radius*4-settings_dialog_scrollPos,
    80*pix,80*pix);
  levels_rect.drawImage(clipboard_image);

  reload_rect = new Rect(dialog_border_left+radius*9.6,
    reactions_start_y+reactions.size()*radius*3+radius*4-settings_dialog_scrollPos,
    80*pix,80*pix);
  reload_rect.drawImage(reload_image);
  done_editing_reactions_rect = new Rect(dialog_border_left+radius*14,
    reactions_start_y+reactions.size()*radius*3+radius*4-settings_dialog_scrollPos,
    80*pix,80*pix);
  done_editing_reactions_rect.drawImage(tick_image);

  scroll_up_rect = new Rect(width-50*pix,0,50*pix,50*pix);
  scroll_down_rect = new Rect(width-50*pix,height-50*pix,50*pix,50*pix);

  if(excess_height>0)
  {
    // show the scroll position
    stroke(200,200,200,GLOBAL_ALPHA);
    strokeWeight(3*pix);
    float scroll_height = height*height/panel_height;
    float scroll_y = (height-scroll_height)*settings_dialog_scrollPos/excess_height;
    line(width-dialog_border_right+6*pix,scroll_y,width-dialog_border_right+6*pix,scroll_y+scroll_height);
    scroll_up_rect.drawImage(move_up_image);
    scroll_down_rect.drawImage(move_down_image);
  }

  if(editing_reaction)
    showReactionEditor();

  if(showing_levels)
    showLevelChooser();

  if(showing_settings_help)
    showSettingsHelp();

  if(asking_can_delete_reaction)
    showYesNoQuestion("Delete this reaction?",GLOBAL_ALPHA);
  if(asking_can_delete_all_reactions)
    showYesNoQuestion("Delete all reactions?",GLOBAL_ALPHA);
  if(asking_can_reload_challenge)
    showYesNoQuestion("Restart this challenge?",GLOBAL_ALPHA);
  if(showing_message)
    showMessage(message_being_shown,GLOBAL_ALPHA);
}

void showYesNoQuestion(String message,int GLOBAL_ALPHA)
{
  noStroke();
  fill(0,0,0,GLOBAL_ALPHA);
  rect(0,0,width,height);
  stroke(230,140,100);
  strokeWeight(1*pix);
  fill(0,0,0,GLOBAL_ALPHA);
  rect(50*pix,200*pix,width-100*pix,220*pix);
  setTextSize(30*pix);
  textAlign(CENTER,TOP);
  fill(255,255,255,GLOBAL_ALPHA);
  text(message,width/2,220*pix);
  image(cancel_image,width/2-140*pix,300*pix,80*pix,80*pix);
  image(tick_image,width/2+140*pix-80*pix,300*pix,80*pix,80*pix);
}

void showMessage(String message,int GLOBAL_ALPHA)
{
  // decide how high the box needs to be
  setTextSize(30*pix);
  textAlign(CENTER,TOP);
  float h_border = 50*pix;
  float internal_border = 10*pix;
  float dlg_width = width - h_border*2;
  float ht = textHeight(message,dlg_width-internal_border*2);
  float dlg_height = ht+100*pix;
  float v_border = (height-dlg_height)/2;
  noStroke();
  fill(0,0,0,GLOBAL_ALPHA);
  rect(0,0,width,height);
  stroke(230,140,100);
  strokeWeight(1*pix);
  fill(0,0,0,GLOBAL_ALPHA);
  rect(h_border,v_border,dlg_width,dlg_height);
  fill(255,255,255,GLOBAL_ALPHA);
  text(message,h_border+internal_border,v_border+10*pix,dlg_width-internal_border*2,MAX_INT);
  image(tick_image,width/2-40*pix,height-v_border-90*pix,80*pix,80*pix);
}

void mousePressedInSettingsMode()
{
  if(asking_can_delete_all_reactions)
  {
    if(nearerThan(mouseX-(width/2-140*pix+40*pix),mouseY-(300*pix+40*pix),45*pix)) // cancel
    {
      asking_can_delete_all_reactions=false;
    }
    else if(nearerThan(mouseX-(width/2+140*pix-40*pix),mouseY-(300*pix+40*pix),45*pix)) // tick
    {
      asking_can_delete_all_reactions=false;
      reactions.clear();
    }
  }
  else if(asking_can_reload_challenge)
  {
    if(nearerThan(mouseX-(width/2-140*pix+40*pix),mouseY-(300*pix+40*pix),45*pix)) // cancel
    {
      asking_can_reload_challenge=false;
    }
    else if(nearerThan(mouseX-(width/2+140*pix-40*pix),mouseY-(300*pix+40*pix),45*pix)) // tick
    {
      asking_can_reload_challenge=false;
      saveReactions();
      reloadChallengeKeepingExistingReactions();
      is_settings_mode = false;
    }
  }
  else if(showing_settings_help)
    mousePressedInSettingsHelpMode();
  else if(showing_levels)
    mousePressedInLevelChooser();
  else if(showing_message)
  {
    showing_message = false;
  }
  else if(editing_reaction)
    mousePressedInReactionEditor();
  else if(challenges[iChallenge].allow_editing_of_reactions && mouseY>reactions_start_y-settings_dialog_scrollPos-radius &&
    mouseY<reactions_start_y+radius*3*reactions.size()-radius*2-settings_dialog_scrollPos &&
    mouseX<dialog_border_left+radius*13) // click on a reaction
  {
    editing_reaction=true;
    i_reaction_being_edited = int((mouseY - (reactions_start_y-settings_dialog_scrollPos-radius)) / (radius*3));
  }
  else if(challenges[iChallenge].allow_editing_of_reactions && reactions.size()>0 && delete_all_reactions_rect.contains(mouseX,mouseY))
  {
    asking_can_delete_all_reactions = true;
  }
  else if(challenges[iChallenge].allow_editing_of_reactions && add_reaction_rect.contains(mouseX,mouseY))
  {
    reactions.add(new Reaction(2,0,false,2,0,0,false,0));
    editing_reaction=true;
    i_reaction_being_edited = reactions.size()-1;
  }
  else if(levels_rect.contains(mouseX,mouseY))
  {
    showing_levels = true;
    i_challenge_being_shown = iChallenge;
  }
  else if(reload_rect.contains(mouseX,mouseY))
  {
    asking_can_reload_challenge = true;
  }
  else if(done_editing_reactions_rect.contains(mouseX,mouseY))
  {
    is_settings_mode = false;
    saveReactions();
  }
  else if(help_with_level_rect.contains(mouseX,mouseY))
  {
    showing_settings_help = true;
  }
  else if(scroll_up_rect.contains(mouseX,mouseY))
  {
    settings_dialog_scrollPos -= scroll_step;
  }
  else if(scroll_down_rect.contains(mouseX,mouseY))
  {
    settings_dialog_scrollPos += scroll_step;
  }
  else if(excess_height>0)
  {
    // start dragging the dialog contents up and down
    is_dragging_settings_dialog = true;
    dragged_settings_dialog_y = mouseY;
  }
}

void mouseReleasedInSettingsMode()
{
  if(showing_settings_help)
    mouseReleasedInSettingsHelpMode();
  else if(editing_reaction)
    mouseReleasedInReactionEditor();
  //else if(showing_levels)
  //  mouseReleasedInLevelChooser();
  else
    is_dragging_settings_dialog = false;
}

void backButtonPressedInSettingsMode()
{
  if(showing_settings_help)
    showing_settings_help = false;
  else if(editing_reaction)
    backButtonPressedInReactionEditor();
  else if(showing_levels)
    showing_levels = false;
  else if(asking_can_delete_all_reactions)
    asking_can_delete_all_reactions = false;
  else if(asking_can_reload_challenge)
    asking_can_reload_challenge = false;
  else if(showing_message)
    showing_message = false;
  else
    is_settings_mode = false;
}
