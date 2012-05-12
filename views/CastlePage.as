class Cloud extends MyNode
{
    var map;
    function Cloud(m, k)
    {
        map = m;
        var y = rand(300);
        bg = sprite("cloud"+str(k)+".png").pos(-700, y);
        init();
        if(k == 2 || k == 5)
            bg.addaction(sequence(
                    moveto(10000+rand(3000), 3000, 0), callfunc(remove)));
        else
            bg.addaction(sequence(
                    moveto(20000+rand(3000), 3000, 0), callfunc(remove)));
    }
    function remove()
    {
        removeSelf();
        map.remove(this);
    }
}

class Water extends MyNode
{
    function Water()
    {
        bg = node();
        var left = bg.addnode().pos(610, 362);
        var l0 = left.addsprite().pos(42, 21).addaction(repeat(animate(
            2000, 
            "rl1_0.png", "rl2_0.png", "rl3_0.png", "rl4_0.png", "rl5_0.png", "rl6_0.png", "rl7_0.png", "rl8_0.png" )));
        var l1 = left.addsprite().pos(338, 75).addaction(repeat(animate(
            2000,
            "rl1_1.png", "rl2_1.png", "rl3_1.png", "rl4_1.png", "rl5_1.png", "rl6_1.png", "rl7_1.png", "rl8_1.png" )));

        var l2 = left.addsprite().pos(297, 315).addaction(repeat(animate(
            2000,
            "rl1_2.png", "rl2_2.png", "rl3_2.png", "rl4_2.png", "rl5_2.png", "rl6_2.png", "rl7_2.png", "rl8_2.png" )));
        var l3 = left.addsprite().pos(372, 406).addaction(repeat(animate(
            2000,
            "rl1_3.png", "rl2_3.png", "rl3_3.png", "rl4_3.png", "rl5_3.png", "rl6_3.png", "rl7_3.png", "rl8_3.png" )));
        var l4 = left.addsprite().pos(358, 628).addaction(repeat(animate(
            2000,
            "rl1_4.png", "rl2_4.png", "rl3_4.png", "rl4_4.png", "rl5_4.png", "rl6_4.png", "rl7_4.png", "rl8_4.png" )));
        var rPos = [
        [239, 224],
        [134, 339],
        [237, 484],
        [346, 685]
        ];
        var right = bg.addnode().pos(1825, 363);
        var r0 = right.addsprite().pos(rPos[0]).addaction(repeat(animate(
            2000,
            "rr1_0.png", "rr2_0.png","rr3_0.png","rr4_0.png","rr5_0.png","rr6_0.png","rr7_0.png","rr8_0.png"
        )));
        var r1 = right.addsprite().pos(rPos[1]).addaction(repeat(animate(
            2000,
            "rr1_1.png", "rr2_1.png","rr3_1.png","rr4_1.png","rr5_1.png","rr6_1.png","rr7_1.png","rr8_1.png"
        )));
        var r2 = right.addsprite().pos(rPos[2]).addaction(repeat(animate(
            2000,
            "rr1_2.png", "rr2_2.png","rr3_2.png","rr4_2.png","rr5_2.png","rr6_2.png","rr7_2.png","rr8_2.png"
        )));
        var r3 = right.addsprite().pos(rPos[3]).addaction(repeat(animate(
            2000,
            "rr1_3.png", "rr2_3.png","rr3_3.png","rr4_3.png","rr5_3.png","rr6_3.png","rr7_3.png","rr8_3.png"
        )));
        /*

        var wll = bg.addsprite().pos(510+130, 214+123);
        wll.addaction(repeat(animate(2000,
            "wll0.png", "wll1.png","wll2.png","wll3.png","wll4.png","wll5.png","wll6.png")));

        var wrr = bg.addsprite().pos(1635+269, 213+130);
        wrr.addaction(repeat(animate(2000,
            "wrr0.png", "wrr1.png", "wrr2.png", "wrr3.png", "wrr4.png", "wrr5.png", "wrr6.png")));

        var falls = bg.addsprite().pos(2902+12, 770+18);
        falls.addaction(repeat(animate(2000,
            "pp0.png", "pp1.png", "pp2.png", "pp3.png", "pp4.png", "pp5.png", "pp6.png" 
        )));

        */
        /*
        bg = node().pos(1823, 247);
        var up = bg.addsprite("up0.png").pos(102, 109); 
        bg.addaction(repeat(animate(2000, "up0.png", "up1.png", "up2.png", "up3.png", "up4.png", "up5.png", "up6.png")));
        var mid = bg.addsprite("mid0.png").pos(99, 129);
        mid.addaction(
            repeat(animate(2000, 
            "mid0.png", "mid1.png", "mid2.png","mid3.png","mid4.png","mid5.png","mid6.png")));
        var down = bg.addsprite("down0.png").pos(170, 262);
        down.addaction(
            repeat(animate(2000, 
            "down0.png", "down1.png", "down2.png","down3.png","down4.png","down5.png","down6.png")));
        var low = bg.addsprite("low0.png").pos(222, 300);

        low.addaction(
            repeat(animate(2000, 
            "low0.png", "low1.png", "low2.png","low3.png","low4.png","low5.png","low6.png")));

        var xia = bg.addsprite("xia0.png").pos(83, 447);

        xia.addaction(
            repeat(animate(2000, 
            "xia0.png", "xia1.png", "xia2.png","xia3.png","xia4.png","xia5.png","xia6.png")));
        var end = bg.addsprite("end0.png").pos(78, 537);

        end.addaction(
            repeat(animate(2000, 
            "end0.png", "end1.png", "end2.png","end3.png","end4.png","end5.png","end6.png")));
        */
    }
}
class Sky extends MyNode
{
    function Sky()
    {
        //bg = sprite("sky.png").size(3000, 330);
        
        bg = node();
        bg.addsprite("sky0.png").pos(0, 0);
        bg.addsprite("sky1.png").pos(1000, 0);
        bg.addsprite("sky2.png").pos(2000, 0);
        
    }
}
class BuildLayer extends MyNode
{
    var map;
    var buildings = [];
    function BuildLayer(m)
    {
        map = m;
        bg = node();
        init();
    }
    override function addChild(chd)
    {
        super.addChild(chd);
        buildings.append(chd);
    }
        
    override function removeChild(chd)
    {
        super.removeChild(chd);
        buildings.remove(chd);
    }
    function touchBegan(n, e, p, x, y, points)
    {
    }
    function touchMoved(n, e, p, x, y, points)
    {
    }
    function touchEnded(n, e, p, x, y, points)
    {
    }
    function checkInBuild(n, e, p, x, y, points)
    {
        var curPos = n.node2world(x, y);
        for(var i = 0; i < len(buildings); i++)
        {
            if(checkIn(buildings[i].bg, curPos))
                return buildings[i];
        }
        return null;
    }
}
class CastlePage extends MyNode
{
    var farm;
    var build;
    var train;
    var touchDelegate;

    var fallGoods;
    var scene;
    var buildLayer;

    function CastlePage(s)
    {
        scene = s;
        bg = node().size(MapWidth, MapHeight);
        init();

        var sky = new Sky();
        addChildZ(sky, -2);


        bg.addsprite("flow0.png").pos(0, 48);
        bg.addsprite("flow2.png").pos(1650, 45);
        bg.addsprite("flow1.png").pos(2352, 13);


        farm = new FarmLand(this);
        addChild(farm);
        build = new BuildLand(this);
        addChild(build);
        train = new TrainLand(this);
        addChild(train);



        addChild(new Water());

        buildLayer = new BuildLayer(this);
        addChild(buildLayer);

        fallGoods = new FallGoods(this);
        addChild(fallGoods);

        
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;
        //touchDelegate.enterScene();
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);

        //global.timer.addTimer(this);

    }
    var inBuilding = 0;
    var curBuild = null;
    function beginBuild(building)
    {
        inBuilding = 1;
        curBuild = new Building(this, building);
        buildLayer.addChild(curBuild);
        moveToPoint(2526, 626);
    }
    function moveToPoint(tarX, tarY)
    {
        var worldPos = bg.node2world(tarX, tarY);
        var sSize = global.director.disSize;
        var difx = sSize[0]/2-worldPos[0];
        var dify = sSize[1]/2-worldPos[1];
        var curPos = bg.pos();
        curPos[0] += difx;
        curPos[1] += dify;

        var backSize = bg.size();
        bg.pos(0, 0);
        var maxX = 0;
        var maxY = 0;
        var w2 = bg.node2world(backSize[0], backSize[1])
        var minX = sSize[0]-w2[0];
        var minY = sSize[1]-w2[1];

        curPos[0] = min(max(minX, curPos[0]), maxX);
        curPos[1] = min(max(minY, curPos[1]), maxY);
        bg.pos(curPos);
    }
    function finishBuild()
    {
        inBuilding = 0; 
        curBuild.finishBuild();
        curBuild = null;
    }
    function cancelBuild()
    {
        inBuilding = 0;
        buildLayer.removeChild(curBuild);
        curBuild = null;
    }
    var touchBuild = null;
    function touchBegan(n, e, p, x, y, points)
    {
        scene.clearHideTime();
        touchDelegate.tBegan(n, e, p, x, y, points);
    }
    function touchMoved(n, e, p, x, y, points)
    {
        touchDelegate.tMoved(n, e, p, x, y, points);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        touchDelegate.tEnded(n, e, p, x, y, points);
    }
    override function enterScene()
    {
        trace("castal Enter Scene");
        super.enterScene();
        global.timer.addTimer(this);
    }
    function remove(c)
    {
        clouds.remove(c);
    }
    var clouds = [];
    var lastTime = 0;
    function update(diff)
    {
        lastTime += diff;
        if(lastTime >= 10000)
        {
            if(len(clouds) < 8 && rand(3) == 0)
            {
                var r = rand(7);
                var c = new Cloud(this, r);
                addChildZ(c, -1);
            }
            lastTime = 0;
        }
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }

}
