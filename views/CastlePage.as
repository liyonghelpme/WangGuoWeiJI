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
    }
}
class Sky extends MyNode
{
    function Sky()
    {
        bg = sprite("sky.png").size(3000, 330);
        /*
        bg.addsprite("sky0.png").pos(0, 0);
        bg.addsprite("sky1.png").pos(1000, 0);
        bg.addsprite("sky2.png").pos(2000, 0);
        */
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
    function CastlePage(s)
    {
        scene = s;
        bg = node().size(3000, 880);
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
        fallGoods = new FallGoods(this);
        addChild(fallGoods);


        
        touchDelegate = new StandardTouchHandler(this);
        touchDelegate.bg = bg;
        touchDelegate.enterScene();
        global.timer.addTimer(this);

    }
    function beginBuild(id)
    {
           
    }
    function touchBegan()
    {
        scene.clearHideTime();
    }
    override function enterScene()
    {
        //trace("castal Enter Scene");
        //global.director.pushPage(new MenuLayer(), 1);
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
    }

}
