class Rect
{
  float x,y,width,height;
  
  Rect(float x_in,float y_in,float width_in,float height_in)
  {
    x=x_in; y=y_in; this.width=width_in; this.height=height_in;
  }
  
  boolean contains(float x_in,float y_in)
  {
    return x_in>=x && y_in>=y && x_in-x<width && y_in-y<height;
  }
  
  void drawImage(PImage im)
  {
    image(im,x,y,width,height);
  }
  
  void drawRect()
  {
    rect(x,y,width,height);
  }

}
