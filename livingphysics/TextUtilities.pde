boolean isWhitespace(int c)
{
  return c==32;
}

boolean isNewline(int c)
{
  return c==13 || c==10;
}

int textTool(String message,float x,float y,float box_width,boolean draw_text)
{
  final float leading = 1.2; // could be a parameter
  int line_begin = 0;
  int line_end = 0;
  int text_height = 0;
  boolean overflowed,saw_whitespace;
  do {
    overflowed = false;
    saw_whitespace = false;
    // add characters to the current line until it overflows or we reach the end of the text or a newline
    while(line_end<message.length())
    {
      int c = message.charCodeAt(line_end);
      // skip whitespace at the beginning of the line (except on the first line)
      if(text_height>0 && line_end==line_begin && isWhitespace(c))
      {
        line_begin++;
        line_end++;
        continue;
      }
      if(isNewline(c))
      {
        line_end++;
        break; 
      }
      if(textWidth(message.substring(line_begin,line_end+1))>box_width-5)
      {
        overflowed = true;
        break;
      }
      if(isWhitespace(c))
        saw_whitespace = true;
      line_end++;
    }
    if(overflowed && saw_whitespace)
    {
      // roll back to before the last word
      while(line_end>line_begin) // (just a safety check)
      {
        int c = message.charCodeAt(line_end);
        if(isWhitespace(c))
          break;
        line_end--;
      }
    }
    // this line is finished
    if(draw_text)
      text(message.substring(line_begin,line_end),x,y+text_height);
    line_begin = line_end;
    text_height += (textAscent()+textDescent())*leading;
  } while(line_begin<message.length());

  return text_height;
}

int textHeight(String message,float box_width)
{
  return textTool(message,0,0,box_width,false);
}

void drawText(String message,float x,float y,float box_width)
{
  //text(message,x,y,box_width,MAX_INT); // to debug, can draw both to check they line up
  //fill(200,100,100);
  textTool(message,x,y,box_width,true); // using our own text drawing function in order to get a reliable textHeight
}

void setTextSize(float s)
{
  textSize(s);
}
