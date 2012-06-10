class FallObj extends MyNode
{
    var map;
    var kind;
    var obj;
    var sx = 1;
    var sy = 1;
    var curMap = null;
    function FallObj(m,k, rx, ry){
        map = m;
        kind = k;
        curMap = [rx, ry];
        bg = node().size(100, 100).anchor(50, 100);
        init();
        obj = bg.addsprite("goods"+str(k)+".png").anchor(50,50).size(30,30).pos(50, 50);

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    override function enterScene()
    {
        super.enterScene();
        global.user.updateRxRyMap(curMap[0], curMap[1], this);
    }
    override function exitScene()
    {
        global.user.removeRxRyMap(curMap[0], curMap[1], this);
        super.exitScene();
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


        /*
        var coor = bg.pos();
        var coor2= map.bg.node2world(coor[0],coor[1]);
        */

        global.director.curScene.addChild(new FlyObject(bg, getFallThing(kind), pickMe));

        bg.setevent(EVENT_TOUCH|EVENT_UNTOUCH|EVENT_MOVE, null);
        bg.removefromparent();

        //flyObject(bg, getFallThing(kind), pickMe);

        //kind = -1;
        //getscene().add(bg.pos(0, 0), 100);
        /*
        var tar = [[297, 460], [253, 460], [550, 460]];
        var add = fallThings[kind];
        var showPos = tar[0];
        if(add[0] != 0)
        {
            showPos = tar[0];
            obj.texture("silver.png"); 
        }
        else if(add[1] != 0)
        {
            showPos = tar[1];
            obj.texture("crystal.png");
        }
        else if(add[2] != 0)
        {
            showPos = tar[2];
            obj.texture("gold.png");
        }
        var dis = sqrt(distance(coor2, [256,460]));
        bg.addaction(sequence(sinein(bezierby(
                    500+dis*25,
                    coor2[0], coor2[1], 
                    coor2[0]+100, coor2[1]-100, 
                    coor2[0]+100, coor2[1]+100, 
                    showPos[0], showPos[1])),callfunc(pickMe)));
        */
    }
    function pickMe()
    {
        removeSelf();
        map.pickObj(this);
    }
}
