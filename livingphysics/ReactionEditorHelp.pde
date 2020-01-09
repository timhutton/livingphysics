float reaction_editor_help_scroll_pos=0;
Rect reaction_editor_help_ok_button_rect;
float reaction_editor_help_excess_height,dragged_reaction_editor_help_dialog_y;
boolean is_dragging_reaction_editor_help_dialog = false;

void showReactionEditorHelp()
{
  int dialog_border_left = int(20*pix);
  int dialog_border_right = int(60*pix);
  float left = dialog_border_left;
  float right = width-dialog_border_right;
  float top = -1;
  float bottom = height-top;
  float internal_border = 5*pix;
  
  String text_block1= "This is the reaction editor. The reaction only applies to atoms with matching type and state, so change them as necessary.\n\n"+
    "Click on an atom first, then on its new type or its new state number. Remember that an atom's type can never be changed.\n\n"+
    "To bond two atoms together, click between the two atoms on the right so that a line appears between them. Make sure there is no bond between the two atoms on the left.\n\n"+
    "To unbond two atoms, have them bonded before and unbonded afterwards.";
  
  reaction_editor_help_ok_button_rect = new Rect((left+right)/2-40*pix,bottom-90*pix,80*pix,80*pix);
  scroll_up_rect = new Rect(width-50*pix,0,50*pix,50*pix);
  scroll_down_rect = new Rect(width-50*pix,height-50*pix,50*pix,50*pix);
  setTextSize(28*pix);
  float text_height = textHeight(text_block1,right-left-internal_border*2);
  float y1 = reaction_editor_help_ok_button_rect.y-internal_border*4;
  float y2 = reaction_editor_help_ok_button_rect.y-internal_border*2;
  
  float panel_height = top+internal_border*2+text_height+20*pix+(height-y1);
  reaction_editor_help_excess_height = max(0, panel_height - height);

  if(is_dragging_reaction_editor_help_dialog)
  {
    reaction_editor_help_scroll_pos += dragged_reaction_editor_help_dialog_y-mouseY;
    dragged_reaction_editor_help_dialog_y = mouseY;
  }
  reaction_editor_help_scroll_pos = constrain(reaction_editor_help_scroll_pos,0,reaction_editor_help_excess_height);
  
  fill(0,0,0,100);
  rect(0,0,width,height);
  stroke(230,140,100);
  strokeWeight(1);
  strokeJoin(ROUND);
  fill(30,27,34);
  rect(left,top,right-left,bottom-top);
  
  textAlign(LEFT,TOP);
  fill(255,255,255);
  drawText(text_block1,left+internal_border,top+internal_border*2-reaction_editor_help_scroll_pos,right-left-internal_border*2);
  
  fill(30,27,34,200);
  noStroke();
  rect(left+1,y1,right-left-2,height-y1);
  fill(30,27,34);
  noStroke();
  rect(left+1,y2,right-left-2,height-y2);
  reaction_editor_help_ok_button_rect.drawImage(tick_image);
  
  if(reaction_editor_help_excess_height>0)
  {
    // show the scroll position
    stroke(200,200,200,200);
    strokeWeight(3*pix);
    float scroll_height = height*height/panel_height;
    float scroll_y = (height-scroll_height)*reaction_editor_help_scroll_pos/reaction_editor_help_excess_height;
    line(right+6*pix,scroll_y,right+6*pix,scroll_y+scroll_height);
    scroll_up_rect.drawImage(move_up_image);
    scroll_down_rect.drawImage(move_down_image);
  }
}

void mousePressedInReactionEditorHelpMode()
{
  // exit if on ok button
  if(reaction_editor_help_ok_button_rect.contains(mouseX,mouseY))
  {
    showing_reaction_editor_help = false;
  }
  else if(scroll_up_rect.contains(mouseX,mouseY))
  {
    reaction_editor_help_scroll_pos -= scroll_step;
  }
  else if(scroll_down_rect.contains(mouseX,mouseY))
  {
    reaction_editor_help_scroll_pos += scroll_step;
  }
  // otherwise start scrolling
  else if(reaction_editor_help_excess_height>0)
  {
    // start dragging the dialog contents up and down
    is_dragging_reaction_editor_help_dialog = true;  
    dragged_reaction_editor_help_dialog_y = mouseY;
  }
}

void mouseReleasedInReactionEditorHelpMode()
{
  is_dragging_reaction_editor_help_dialog = false;
}

