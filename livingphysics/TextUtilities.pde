boolean isWhitespace(char c)
{
  return c==' '; // Processing's text() doesn't seem to recognise \t as whitespace at all
}

int textTool(String message,float x,float y,float box_width,boolean draw_text)
{
  final float leading = 1.3; // could be a parameter
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
      char c = message.charAt(line_end);
      // skip whitespace at the beginning of the line (except on the first line)
      if(text_height>0 && line_end==line_begin && isWhitespace(c))
      {
        line_begin++;
        line_end++;
        continue;
      }
      if(c=='\n')
      {
        line_end++;
        break; 
      }
      if(textWidth(message.substring(line_begin,line_end+1))>box_width)
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
        char c = message.charAt(line_end);
        if(isWhitespace(c))
          break;
        line_end--;
      }
    }
    // this line is finished
    if(draw_text)
      text(message.substring(line_begin,line_end),x,y+text_height);//,box_width,height);
    line_begin = line_end;
    text_height += (textAscent()+textDescent())*leading; //g.textLeading;
  } while(line_begin<message.length());
  //if(is_js_version)
  //  text_height *= 0.6;

  text_height *= 2.5; // hacked to fix layout
  return text_height;
}

int textHeight(String message,float box_width)
{
  return textTool(message,0,0,box_width,false);
}

void drawText(String message,float x,float y,float box_width)
{
  text(message,x,y,box_width,MAX_INT);
  //textTool(message,x,y,box_width,true);
}

void setTextSize(float s)
{
  textSize(s);
  //if(is_js_version)
  //  textLeading(s*1.1); // leading should be proportional
}
