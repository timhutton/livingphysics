int i_challenge_being_shown;
Rect prev_challenge_rect,next_challenge_rect,cancel_challenge_choice_rect,
  accept_challenge_choice_rect;

void showLevelChooser()
{
  fill(0,0,0,100);
  noStroke();
  rect(0,0,width,height);
  Rect levels_window = new Rect(0,height/2-250*pix,width,500*pix);
  stroke(230,140,100);
  strokeWeight(1*pix);
  fill(0,0,0,GLOBAL_ALPHA);
  levels_window.drawRect();
  cancel_challenge_choice_rect = new Rect(width/2-60*pix-30*pix,levels_window.y+levels_window.height-70*pix,
    60*pix,60*pix);
  cancel_challenge_choice_rect.drawImage(cancel_image);
  accept_challenge_choice_rect = new Rect(width/2+60*pix-30*pix,levels_window.y+levels_window.height-70*pix,
    60*pix,60*pix);
  accept_challenge_choice_rect.drawImage(tick_image);
  fill(50,50,50,GLOBAL_ALPHA);
  noStroke();
  rect(levels_window.x+65*pix,levels_window.y+1*pix,levels_window.width-130*pix,levels_window.height-80*pix);
  if(i_challenge_being_shown>=0)
  {
    prev_challenge_rect = new Rect(levels_window.x+10*pix,height/2-45*pix,50*pix,50*pix);
    prev_challenge_rect.drawImage(move_left_image);
  }
  if(i_challenge_being_shown<challenges.length)
  {
    next_challenge_rect = new Rect(levels_window.x+levels_window.width-10*pix-50*pix,height/2-45*pix,
      50*pix,50*pix);
    next_challenge_rect.drawImage(move_right_image);
  }
  setTextSize(25*pix);
  textAlign(CENTER,TOP);
  fill(255,255,255,GLOBAL_ALPHA);
  if(i_challenge_being_shown>=0 && i_challenge_being_shown<challenges.length)
  {
    text("Challenge "+str(i_challenge_being_shown+1)+": \""+challenges[i_challenge_being_shown].title+"\"\n\n"+challenges[i_challenge_being_shown].desc,
      levels_window.x+75*pix,levels_window.y+10*pix,levels_window.width-150*pix,MAX_INT);
    if(challenges[i_challenge_being_shown].isSolved())
    {
      image(checkbox_ticked_image,width/2-60*pix,levels_window.y+1*pix+levels_window.height-80*pix-80*pix,
        60*pix,60*pix);
      textAlign(LEFT,CENTER);
      text("Solved",width/2+25*pix,levels_window.y+1*pix+levels_window.height-80*pix-80*pix+30*pix,MAX_INT);
    }
  }
  else
  {
    fill(200,200,200,GLOBAL_ALPHA);
    text("To suggest ideas for more levels, or to discuss solutions or report bugs, please visit the Living Physics community webpage - tap the tick button.",
      levels_window.x+75*pix,levels_window.y+55*pix,levels_window.width-150*pix,MAX_INT);
  }
}

void mousePressedInLevelChooser()
{
  if(prev_challenge_rect.contains(mouseX,mouseY))
  {
    i_challenge_being_shown = max(-1,i_challenge_being_shown-1);
  }
  else if(next_challenge_rect.contains(mouseX,mouseY))
  {
    i_challenge_being_shown = min(challenges.length,i_challenge_being_shown+1);
  }
  else if(cancel_challenge_choice_rect.contains(mouseX,mouseY))
  {
    showing_levels = false;
  }
  else if(accept_challenge_choice_rect.contains(mouseX,mouseY))
  {
    showing_levels = false;
    if(i_challenge_being_shown<0 || i_challenge_being_shown>=challenges.length)
    {
        goToURL(website_url);
    }
    else 
    {
      if(i_challenge_being_shown!=iChallenge)
      {
        iChallenge = i_challenge_being_shown;
        loadChallenge();
        is_settings_mode = false;
      }
    }
  }
}
