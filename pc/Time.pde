public class Time {
  private int initTime = 0;
  Time () {  
    initTime = second() + minute()*60 + hour()*3600;
  } 
  public int getInitTime (){
    return initTime;
  }
  
  public void setInitTime () {
    initTime = second() + minute()*60 + hour()*3600;
  }
  
  public int getCurrentTime(){
    return second() + minute()*60 + hour()*3600;
  }
}
