class BoxOnMap extends MyNode
{
    var scene;
    var flowTap = null;
    function BoxOnMap(s)
    {
        scene = s;
        bg = node().anchor(50, 50).pos(1018, 791);
        init();
        //分离动画和点击顶点
var ani = bg.addsprite("box0.png", ARGB_8888);
        ani.addaction(repeat(animate(getParam("boxOnMapTime"), "box0.png", "box1.png", "box2.png", "box3.png", "box4.png")));
        bg.size(ani.prepare().size());//设定尺寸

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function showFlowTap()
    {
        flowTap = bg.addsprite("tapIcon.png").pos(50, 27).anchor(50, 100); //box图片空白区域太大
        flowTap.addaction(sequence(delaytime(rand(2000)), repeat(moveby(500, 0, -20), delaytime(300), moveby(500, 0, 20))));
    }
    function update(diff)
    {
        if(flowTap == null && global.user.hasBox && len(global.user.helperList) >= PARAMS["maxBoxFriNum"])
        {
            showFlowTap();
        }
        else if(flowTap == null && global.user.db.get("openBoxYet") == null)
        {
            showFlowTap();
        }
    }
    var accMoved = 0;
    var lastPoints;
    function touchBegan(n, e, p, x, y, points)
    {
        accMoved = 0;
        lastPoints = n.node2world(x, y);
        scene.touchBegan(n, e, p, x, y, points); 
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPoint = lastPoints;
        lastPoints = n.node2world(x, y);
        accMoved += abs(lastPoints[0]-oldPoint[0])+abs(lastPoints[1]-oldPoint[1]);
        scene.touchMoved(n, e, p, x, y, points);
    }
    //只有touch在内部才可以
    function touchEnded(n, e, p, x, y, points)
    {
        if(accMoved <= 20)
        {
            global.user.db.put("openBoxYet", 1);
            if(flowTap != null && (len(global.user.helperList) < PARAMS["maxBoxFriNum"]))
            {
                flowTap.removefromparent();
                flowTap = null;
            }

            global.director.pushView(new TreasureBox(BOX_SELF, null), 1, 0);
        }
        scene.touchEnded(n, e, p, x, y, points);
    }
    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
}

