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
*/
class FriendSoldier extends MoveSoldier
{
    var privateData;
    var hasCry;
    var negtiveState = null;
    function FriendSoldier(d, m, hasC)
    {
        hasCry = hasC;
        privateData = d;
        id = privateData.get("id");
        data = getData(SOLDIER, id);
        map = m;
        //var colStr = "blue";

        load_sprite_sheet("soldierm"+str(id)+".plist");

        bg = node().scale(showSize);
        init();

        changeDirNode = bg.addsprite("soldierm"+str(id)+".plist/ss"+str(id)+"m0.png").anchor(50, 100);

        var bSize = changeDirNode.prepare().size();

        bg.size(bSize).anchor(50, 100).pos(524, 303);
        changeDirNode.pos(bSize[0]/2, bSize[1]);
        shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50).size(data.get("shadowSize"), 32);

        changeDirNode.add(shadow, -1);

        movAni = repeat(animate(1500, "soldierm"+str(id)+".plist/ss"+str(id)+"m0.png", "soldierm"+str(id)+".plist/ss"+str(id)+"m1.png","soldierm"+str(id)+".plist/ss"+str(id)+"m2.png","soldierm"+str(id)+".plist/ss"+str(id)+"m3.png","soldierm"+str(id)+".plist/ss"+str(id)+"m4.png","soldierm"+str(id)+".plist/ss"+str(id)+"m5.png","soldierm"+str(id)+".plist/ss"+str(id)+"m6.png"));
        shiftAni = moveto(0, 0, 0);
        
        state = SOL_FREE;

        showNegtiveState();

        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }


    function showNegtiveState()
    {
        if(hasCry == 1)
        {
            var bsize = bg.size();
            negtiveState = bg.addsprite("soldierMorale.png").pos(bsize[0]/2, -5).anchor(50, 100);
        }
    }

    var accMove = 0;
    var lastPoints;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
        //map.touchBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0] - oldPos[0];
        var dify = lastPoints[1] - oldPos[1];
        accMove += abs(difx)+abs(dify);
        //map.touchMoved(n, e, p, x, y, points); 
    }
    /*
    拥有水晶 增加对应数量的水晶
    需要修正好友数据中的水晶数量 
    */
    function touchEnded(n, e, p, x, y, points)
    {
        if(hasCry == 1)
        {
            hasCry = 0;
            var cry = 1;
            global.httpController.addRequest("friendC/helpFriendCry", dict([["uid", global.user.uid], ["kind", map.kind], ["crystal", cry]]), null, null);
            global.friendController.helpFriend(map.scene.getUid(), map.kind, cry);
            if(negtiveState != null)
            {
                negtiveState.removefromparent();
                negtiveState = null;
            }

            var temp = bg.addnode();
            temp.addsprite("crystal.png").anchor(0, 50).pos(0, -30).size(30, 30);
            temp.addlabel("+"+str(1), null, 25).anchor(0, 50).pos(35, -30).color(0, 0, 0);
            temp.addaction(sequence(moveby(500, 0, -40), fadeout(1000), callfunc(removeTempNode)));
        }
        //map.touchEnded(n, e, p, x, y, points);
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
