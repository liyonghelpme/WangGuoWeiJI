class FallObject extends MyNode
{
    var map;
    var kind;
    var x;
    var y;
    function FallObject(m,k){
        map = m;
        kind = k;
        bg = sprite("apple.png").anchor(50,50).size(50,50);
        x = rand(m.size()[0]-100)+50;
        y = rand(m.size()[1]-400)+200;
        global.touchManager.addTargeted(new ButtonDelegate(bg,1,0,this,0),y,1);
    }
    
    function animateFall(){
        map.add(bg.pos(x,y-400),y);
        bg.addaction(bounceout(moveby(1000,0,400)));
    }
    
    function onclicked(){
        if(bg == null || kind<0){
            return;
        }
        var coor = bg.pos();
        var coor2= map.node2world(coor[0],coor[1]);
        bg.removefromparent();
        /*if(wh[1]*10 > wh[0]*6){
            scene.size(wh[0]*wh[1]/1700,wh[1]);
        }
        else{
            scene.size(wh[0],wh[1]*wh[0]/2400);
        }*/
        kind = -1;
        getscene().add(bg.pos(0,0),100);
        var dis = sqrt(distance(coor2, [256,460]));
        bg.addaction(sequence(sinein(bezierby(500+dis*25,coor2[0],coor2[1], coor2[0]+100, coor2[1]-100, coor2[0]+100,coor2[1]+100,256,460)),callfunc(removeSelf)));
    }
}