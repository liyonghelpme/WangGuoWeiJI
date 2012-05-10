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

class CastlePage extends MyNode
{
    var farm;
    var build;
    var train;
    var touchDelegate;

    var fallGoods;
    function CastlePage()
    {
        bg = node().size(3000, 880);
        init();

        var sky = sprite("sky.png").pos(1500, 0).anchor(50, 0).size(3000, 880);

        bg.add(sky, -2);

        bg.addsprite("flow0.png").pos(0, 48);
        bg.addsprite("flow2.png").pos(1650, 45);
        bg.addsprite("flow1.png").pos(2352, 13);


        farm = new FarmLand(this);
        addChild(farm);
        build = new BuildLand(this);
        addChild(build);
        train = new TrainLand(this);
        addChild(train);
        fallGoods = new FallGoods(this);
        addChild(fallGoods);

        
        touchDelegate = new StandardTouchHandler();
        touchDelegate.bg = bg;
        touchDelegate.enterScene();
        global.timer.addTimer(this);


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
