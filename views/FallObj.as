class FallObj extends MyNode
{
    var map;
    var kind;
    function FallObj(m,k){
        map = m;
        kind = k;
        bg = sprite("goods"+str(k)+".png").anchor(50,50).size(50,50);
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var tarPos;
    override function setPos(p)
    {
        tarPos = p;
        bg.pos(tarPos[0], tarPos[1]-400);
        bg.addaction(bounceout(moveby(1000, 0, 400)));
    }
    function touchBegan(n, e, p, x, y, points)
    {
        
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
        onclicked();
    }
    /*
    function animateFall(){
        //map.add(bg.pos(x,y-400),y);
        //bg.addaction(bounceout(moveby(1000,0,400)));
    }
    */
    
    function onclicked(){
        var coor = bg.pos();
        var coor2= map.bg.node2world(coor[0],coor[1]);
        bg.removefromparent();
        kind = -1;
        getscene().add(bg.pos(0, 0), 100);
        var dis = sqrt(distance(coor2, [256,460]));
        bg.addaction(sequence(sinein(bezierby(
                    500+dis*25,
                    coor2[0], coor2[1], 
                    coor2[0]+100, coor2[1]-100, 
                    coor2[0]+100, coor2[1]+100, 
                    256,460)),callfunc(removeSelf)));
        map.pickObj(this);
    }
}
