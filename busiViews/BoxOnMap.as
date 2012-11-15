class BoxOnMap extends MyNode
{
    //var scene;
    var flowTap = null;
    function BoxOnMap()
    {
        //scene = s;
        bg = sprite("box0.png").anchor(50, 50).pos(1018, 791).setevent(EVENT_TOUCH, touchBegan);
        init();
        bg.addaction(repeat(animate(getParam("boxOnMapTime"), "box0.png", "box1.png", "box2.png", "box3.png", "box4.png")));
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
    function touchBegan()
    {
        global.user.db.put("openBoxYet", 1);
        if(flowTap != null && (len(global.user.helperList) < PARAMS["maxBoxFriNum"]))
        {
            flowTap.removefromparent();
            flowTap = null;
        }

        global.director.pushView(new TreasureBox(BOX_SELF, null), 1, 0);
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

