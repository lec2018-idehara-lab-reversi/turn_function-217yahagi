final int KURO = 1;
final int SHIRO = -1;
final int AKI = 0;
final int SOTO = 255;
final int BANSIZE = 640;
final int CELLSIZE = BANSIZE / 8;
final int STONESIZE = round(CELLSIZE * 0.9);

int[][] ban;
int player=KURO;
int teban = KURO;                                // 初手黒
int[] p=new int [2];                                //プレイヤー位置[0]=x,[1]=y
int [][]canp;                                    //現在配置可能位置


int[][]scan={                    //走査用上から時計回りに
  {0,0},
  {0,-1},                    //上
  {1,-1},                    //右上
  {1,0},                     //右
  {1,1},                     //右下
  {0,1},                     //↓
  {-1,1},                    //左下
  {-1,0},                    //左
  {-1,-1}                    //左上
};

String[] xcall={"","A","B","C","D","E","F","G","H"};        //呼び方

void setup()
{
//  size(BANSIZE, BANSIZE);
  size(640, 640);
  ban = new int[10][10];
  for(int y=0; y<10; y++)
  {
    for(int x=0; x<10; x++)
    {
      ban[x][y] = AKI;
      if( x==0 || x==9 || y==0 || y==9 )
      {
        ban[x][y] = SOTO;
      }
    }
  }
  ban[4][5] = SHIRO;
  ban[5][4] = SHIRO;
  ban[5][5] = KURO;
  ban[4][4] = KURO;
  p[0]=1;
  p[1]=1;
  tebandraw(1);
}

void showBan(int[][] b,int[] p)
{
  background(0,96,0);
  for(int i=0; i<9; i++)
  {
    line(0,i*CELLSIZE,BANSIZE,i*CELLSIZE);
    line(i*CELLSIZE,0,i*CELLSIZE,BANSIZE);
  }
  
  for(int y=1; y<=8; y++)
  {
    for(int x=1; x<=8; x++)
    {
      int xpos = x*CELLSIZE-CELLSIZE/2;        //xの表示位置  
      int ypos = y*CELLSIZE-CELLSIZE/2;        //yの表示位置
      switch(b[x][y])
      {
        case SOTO:
          break;
        case AKI:
          break;
        case KURO:
            fill(0,0,0);
            ellipse(xpos,ypos,STONESIZE,STONESIZE);
          break;
        case SHIRO:
            fill(256,256,256);
            ellipse(xpos,ypos,STONESIZE,STONESIZE);
          break;
      }
      if (canput(teban,p[0],p[1],false)==true &&p[0]==x&&p[1]==y){
         fill(211,211,211);
         ellipse(xpos,ypos,STONESIZE,STONESIZE);
      }
    }
  }
} 

void textdraw(String texts){
  textAlign(CENTER);
  fill(211,211,211);
  textSize(45);
  text(texts,300,300,300,150);
}

void tebandraw(int put){        //putは1で手番2で色だけ
  String d="";
  if(teban==KURO){
  d="黒";}
  else if (teban==SHIRO)d="白";
  switch(put){
  case 1:print(d+"の手番\n");break;
  case 2:print(d);break;
  }
}

//-----カラーとｘｙを指定して返すことができるか？できたらひっくり返すか？

boolean canput(int colors,int x, int y, boolean turn){
  boolean ta=false;
  if (ban[x][y]!=AKI){
   return false; 
  }
  for (int i=1;i<=8;i++){
    int xx=x;int yy=y;
    xx += scan[i][0];
    yy += scan[i][1];
    if (ban[xx][yy]==-colors){
      seachloop:while(true){
        xx += scan[i][0];
        yy += scan[i][1];
        switch(ban[xx][yy]){
          case SOTO:
            break seachloop;
          case AKI:
            break seachloop;
          default:
            if (ban[xx][yy]==colors){
              if (turn==true){
                int contx = x;int conty = y;
                while(true){                                //ひっくり返す
                 ban[contx][conty]=teban;
                 contx += scan[i][0];
                 conty += scan[i][1];
                 if (contx==xx&&conty==yy)break;
                }
              }
              //print(xcall[x],y);
              ta=true;
              continue;
            }
            else
              continue;
        } 
      }
    }
  }
  if(ta==true)
    return true;
  return false; 
}



int ALLcantput(int colors){
  int count=0;
  canp=new int [81][2];
  for(int xx=1;xx<=8;xx++){
    for (int yy=1;yy<=8;yy++){
      if(canput(colors,xx,yy,false)==true){
        canp[count][0]=xx;
        canp[count][1]=yy;
        count++;
      }
    }
  }
  return count;
}

void game(){
  if(player==teban){
    p[0]=mouseX/CELLSIZE+1;
    p[1]=mouseY/CELLSIZE+1;
    if (mousePressed == true){
      if(canput(teban,p[0],p[1],true)==true){
        tebandraw(2);
        print(xcall[p[0]]+p[1]+"\n");
        teban=-teban;
        tebandraw(1);
        
        p[0]=0;
      }
    }
    if(ALLcantput(teban)==0){
      print("パス\n");
      teban=-teban;
      tebandraw(1);
    }
   }
   else {
    p[0]=mouseX/CELLSIZE+1;
    p[1]=mouseY/CELLSIZE+1;
    if (mousePressed == true){
      if(canput(teban,p[0],p[1],true)==true){
        tebandraw(2);
        print(xcall[p[0]]+p[1]+"\n");
        teban=-teban;
        tebandraw(1);
        
        p[0]=0;
      }
    }
    if(ALLcantput(teban)==0){
      print("パス\n");
      teban=-teban;
      tebandraw(1);
    }
   }
}



void gameset(){
  textdraw("gameset");
  print("gamesset");
  //if (ALLcantput(KURO)<ALLcantput(SHIRO))print("白の勝ち");
  //else if (ALLcantput(KURO)>ALLcantput(SHIRO))print("黒の勝ち");
  //else print("同点");
}
class AI{

  void checkput(){
   // canput(teban,);
    
  }
  
}
void draw()
{
  game();
  showBan(ban,p);
  if(ALLcantput(KURO)==0&&ALLcantput(SHIRO)==0){
    gameset();
    delay(10*1000);
    exit();
  }
    
}
