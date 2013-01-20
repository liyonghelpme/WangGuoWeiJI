/*
奖励： 每个等级增加的量由类型决定或者由level决定
levelMaxFallGain min(maxSilver, initSilver + addSilver*timer)
*/
class FallObj extends MyNode
{
    var map;
    var kind;
    var obj;
    var sx = 1;
    var sy = 1;
    var curMap = null;
    var buildLayer;
    //用于 移动场景到 该对象 
    var isBuilding = 1;
    /*
    背后的大bg 的anchor 决定了内部奖励物品图片的位置
    进行zord的计算进行比较
    
    kind 决定数据
    显示的图片由view 决定

    */
    var fallTimes;
    function FallObj(m, k, rx, ry, bl, ft)
    {
        fallTimes = ft;
        buildLayer = bl;
        map = m;
        kind = k;
        var fallData = getData(FALL_THING, kind);
        var view = fallData.get("view");
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
        buildLayer.mapGridController.updateRxRyMap(curMap[0], curMap[1], this);
    }
    override function exitScene()
    {
        buildLayer.mapGridController.clearRxRyMap(curMap[0], curMap[1], this);
        super.exitScene();
    }
    var tarPos;
    //通过设定目标位置 来 播放移动动画
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
    
    var player;
    function onclicked(){
        var fallData = getData(FALL_THING, kind);
        var reward = getFallObjValue(kind, fallTimes);
        var level = global.user.getValue("level");
        //不修改水晶的数量
        //奖励可能没有某些项 需要 将其设置默认0
        global.httpController.addRequest("goodsC/pickObj", dict([["uid", global.user.uid], ["silver", reward.get("silver", 0)], ["crystal", reward.get("crystal", 0)], ["gold", reward.get("gold", 0)]]), null, null);
        global.director.curScene.addChild(new FlyObject(bg, reward, pickMe));
        bg.setevent(EVENT_TOUCH|EVENT_UNTOUCH|EVENT_MOVE, null);
        //bg.removefromparent();
        bg.visible(0);

    }
    function pickMe()
    {
        removeSelf();
        map.pickObj(this);
        //测试任务完成 更新任务状态 
        global.taskModel.doAllTaskByKey("pick", 1);
    }
}
