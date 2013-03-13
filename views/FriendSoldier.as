/*

    const showSize = 50;
    var map;
    var changeDirNode;
    var shadow;
    var id;
    var privateData;
    var movAni;
    var shiftAni;
    var state;
    var sx = 1;
    var sy = 1;
    var tar;
    var data;
    var speed = 5;
    var curMap = null;

touch 跟业务逻辑相关
update 可能和业务逻辑相关
移动由地图控制


checkPosCollision
clearMap
updatePosMap

好友页面士兵的sid 是好友的sid
*/
class FriendSoldier extends MoveSoldier
{
    var privateData;
    var hasCry;
    var negtiveState = null;
    var sid;
    function getChangeDirNodeScale()
    {
        return getParam("SOL_SHOW_SIZE")*data["solSca"]/100;
    }
    function FriendSoldier(d, m, hasC, si)
    {
        sid = si;
        hasCry = hasC;
        privateData = d;
        id = privateData.get("id");
        data = getData(SOLDIER, id);
        map = m;

        load_sprite_sheet("soldierm"+str(id)+".plist");

        bg = node();//.scale(showSize);
        init();

changeDirNode = bg.addsprite("soldierm" + str(id) + ".plist/ss" + str(id) + "m0.png", ALPHA_TOUCH, ARGB_8888).anchor(50, 100).scale(getChangeDirNodeScale());
        trace("initChangeDirNode");

        var bSize = changeDirNode.prepare().size();

        bg.size(bSize).anchor(50, 100).pos(524, 303);
        changeDirNode.pos(bSize[0]/2, bSize[1]);

        var ss = SOL_SHADOW_SIZE.get(data["shadowWidth"], 3);
shadow = sprite(("roleShadow" + str(ss)) + ".png", ARGB_8888).pos(bSize[0] / 2, bSize[1]).anchor(50, 50).scale((getParam("SOL_SHOW_SIZE") * data["shadowXScale"]) / 100, getParam("SOL_SHOW_SIZE"));
        trace("initShadow")

        changeDirNode.add(shadow, -1);

        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
        shiftAni = moveto(0, 0, 0);
        
        state = SOL_FREE;

        showNegtiveState();

        changeDirNode.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        changeDirNode.setevent(EVENT_MOVE, touchMoved);
        changeDirNode.setevent(EVENT_UNTOUCH, touchEnded);
    }


    function getBloodHeightOff()
    {
        return data["sy"]*getParam("MAP_OFFY")*getParam("SOL_SHOW_SIZE")/getParam("mapSolScale"); 
    }
    function showNegtiveState()
    {
        if(hasCry == 1)
        {
            var bSize = bg.size();
negtiveState = bg.addsprite("soldierMorale.png", ARGB_8888).pos((bSize[0] / 2) + getParam("statusOffX"), (bSize[1] - getBloodHeightOff()) + getParam("statusOffY")).anchor(50, 100).scale(getParam("SOL_SHOW_SIZE"));

            negtiveState.setevent(EVENT_TOUCH, touchBegan);
            negtiveState.setevent(EVENT_MOVE, touchMoved);
            negtiveState.setevent(EVENT_UNTOUCH, touchEnded);
        }
    }

    var accMove = 0;
    var lastPoints;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0] - oldPos[0];
        var dify = lastPoints[1] - oldPos[1];
        accMove += abs(difx)+abs(dify);
    }
    /*
    拥有水晶 增加对应数量的水晶
    需要修正好友数据中的水晶数量 
    */
    function touchEnded(n, e, p, x, y, points)
    {
        trace("hasCry", hasCry);
        if(hasCry == 1)
        {
            hasCry = 0;
            var rd = rand(getParam("FriendSolCryMaxLevel")-getParam("FriendSolCryBaseLevel"))+getParam("FriendSolCryBaseLevel");
            var cry = rd*(global.user.getValue("level")+1);
            trace("helpEliminate", rd, cry);
            global.httpController.addRequest("friendC/helpFriendCry", dict([["uid", global.user.uid], ["kind", map.kind], ["crystal", cry]]), null, null);
            global.friendController.helpFriend(map.scene.getUid(), map.kind, cry);
            if(negtiveState != null)
            {
                negtiveState.removefromparent();
                negtiveState = null;
            }

            var temp = bg.addnode();
temp.addsprite("crystal.png", ARGB_8888).anchor(0, 50).pos(0, -30).size(30, 30);
temp.addlabel("+" + str(cry), getFont(), 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
            temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));

            global.taskModel.doAllTaskByKey("helpEliminate", 1);
        }
    }


    override function enterScene()
    {
        super.enterScene();
        map.solTimer.addTimer(this);
    }
    override function exitScene()
    {
        map.solTimer.removeTimer(this);
        super.exitScene();
    }
}
