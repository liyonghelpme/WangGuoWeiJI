class FallObj extends MyNode
{
    var map;
    var kind;
    var obj;
    var sx = 1;
    var sy = 1;
    var curMap = null;
    /*
    背后的大bg 的anchor 决定了内部奖励物品图片的位置
    进行zord的计算进行比较
    */
    function FallObj(m,k, rx, ry){
        map = m;
        kind = k;
        curMap = [rx, ry];
        bg = node().size(100, 100).anchor(50, 80).scale(60);
        init();
        obj = bg.addsprite("goods"+str(k)+".png").anchor(50,50).size(30,30).pos(50, 50);
        var shadow = sprite("roleShadow.png").anchor(50, 50).pos(15, 30).size(39, 19);
        obj.add(shadow, -1);

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

        global.director.curScene.addChild(new FlyObject(bg, getFallThing(kind), pickMe));
        bg.setevent(EVENT_TOUCH|EVENT_UNTOUCH|EVENT_MOVE, null);
        bg.removefromparent();

    }
    function pickMe()
    {
        removeSelf();
        map.pickObj(this);
        //测试任务完成
        global.user.updateTask(0, 10, 0);
    }
}
