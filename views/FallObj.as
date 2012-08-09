class FallObj extends MyNode
{
    var map;
    var kind;
    var obj;
    var sx = 1;
    var sy = 1;
    var curMap = null;
    var buildLayer;
    /*
    背后的大bg 的anchor 决定了内部奖励物品图片的位置
    进行zord的计算进行比较
    
    kind 决定数据
    显示的图片由view 决定

    */
    function FallObj(m, k, rx, ry, bl)
    {
        buildLayer = bl;
        map = m;
        kind = k;
        var fallData = getData(FALL_THING, kind);
        var view = fallData.get("view");
//        trace("genNewFallObj", m, k, rx, ry, view, "goods"+str(view)+".png");
        //升级奖励掉落物品

        curMap = [rx, ry];
        bg = node().size(100, 100).anchor(50, 80).scale(60);
        init();
        obj = bg.addsprite("goods"+str(view)+".png").anchor(50,50).size(30,30).pos(50, 50);
        var shadow = sprite("roleShadow.png").anchor(50, 50).pos(15, 30).size(39, 19);
        obj.add(shadow, -1);

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    override function enterScene()
    {
        super.enterScene();
        buildLayer.updateRxRyMap(curMap[0], curMap[1], this);
    }
    override function exitScene()
    {
        buildLayer.removeRxRyMap(curMap[0], curMap[1], this);
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
    
    function onclicked(){
        var fallData = getData(FALL_THING, kind);
        //var reward = getGain(FALL_THING, kind);
        var reward = getFallObjValue(kind);
        var level = global.user.getValue("level");
        if(fallData.get("possible") == 0)
        {
            if(reward.get("crystal") != 0 && reward.get("crystal") != null)
                reward.update("crystal", 3+level/reward.get("crystal"));//等级/10的水晶数量   
        }

        global.httpController.addRequest("goodC/pickObj", dict([["uid", global.user.uid], ["silver", reward.get("silver")], ["crystal", reward.get("crystal")], ["gold", reward.get("gold")]]), null, null);
        global.director.curScene.addChild(new FlyObject(bg, reward, pickMe));
        bg.setevent(EVENT_TOUCH|EVENT_UNTOUCH|EVENT_MOVE, null);
        bg.removefromparent();

    }
    function pickMe()
    {
        removeSelf();
        map.pickObj(this);
        //测试任务完成 更新任务状态 
        global.user.updateTask(0, 10, 0, 0);
    }
}
