class MapLayer extends MyNode
{
    var scene;
    var island;
    var LockPos = [[0, 0], [189, 164], [232, 141], [269, 166], [336, 146], [232, 180]];
    var islandLayer;
    const LOCK_TAG = 1;
    function initLock()
    {

        islandLayer.removefromparent();

        islandLayer = bg.addnode();

        island = new Array(6);
        island[0] = islandLayer.addsprite("map_island0.png",ARGB_8888, ALPHA_TOUCH).size(175,144).anchor(0,0).pos(512,402).rotate(0);
        island[1] = islandLayer.addsprite("map_island1.png",ARGB_8888, ALPHA_TOUCH).size(431,390).anchor(0,0).pos(130,298).rotate(0);
        island[2] = islandLayer.addsprite("map_island2.png",ARGB_8888, ALPHA_TOUCH).size(485,355).anchor(0,0).pos(336,594).rotate(0);
        island[3] = islandLayer.addsprite("map_island3.png",ARGB_8888, ALPHA_TOUCH).size(548,439).anchor(0,0).pos(772,422).rotate(0);
        island[4] = islandLayer.addsprite("map_island4.png",ARGB_8888, ALPHA_TOUCH).size(519,428).anchor(0,0).pos(994,220).rotate(0);
        island[5] = islandLayer.addsprite("map_island5.png",ARGB_8888, ALPHA_TOUCH).size(524,439).anchor(0,0).pos(550,14).rotate(0);

        var i=0;
        //big small
        //big 0 1 2 3 4 5 
        //0 村落
        //1-5 其它岛屿
        //等级不足 不能开启
        //未击败不能开启

        var dx = rand(getParam("IslandDiffBase"))+getParam("IslandDiff");
        var dy = rand(getParam("IslandDiffBase"))+getParam("IslandDiff");
        var dir = rand(2);
        if(dir == 0)
            dir = -1;
        dy *= dir;
        dir = rand(2);
        if(dir == 0)
            dir = -1;
        dx *= dir;
        islandLayer.addaction(repeat(moveby(getParam("IslandTime"), dx, dy), moveby(getParam("IslandTime"), -dx, -dy)));

        /*
        for(i = 1; i < len(island); i++)
        {
            island[i].addaction(repeat(moveby(5000, dx, dy), moveby(5000, -dx, -dy)));
        }
        */

        for(i = 0; i <= PARAMS.get("bigNum"); i++)
        {
            var enable = checkBigEnable(i-1);
            if(enable)
            {
                island[i].color(100,100,100,100);
                new Button(island[i], onClicked, i);
            }
            else
            {
                island[i].color(40,40,40,100);
                var size=island[i].size();
                var lock = sprite("map_island_lock.png").anchor(50,50).pos(LockPos[i][0], LockPos[i][1]).scale(200);
                island[i].add(lock, LOCK_Z, LOCK_TAG);
                if(inSmall && curSmall == i)
                    lock.visible(0);

                new Button(island[i], onClicked, i);
            }
        }
    }
    function MapLayer(s){
        scene = s;
        bg = node().size(1600,960).scale(50,50).anchor(50,50).pos(400,240);
        init();
        
        islandLayer = bg.addnode();
        
    }
    override function enterScene()
    {
        super.enterScene();
        initLock();
    }
    /*
    跳跃动画：
        上升缩放  下降 放大 产生瞬间的 膨胀影子
    */
    function getIsland(big)
    {
        return island[big]; 
    }
    function updateData()
    {
        initLock();
    }
    var inSmall = 0;
    /*
    点击岛屿
    0 回到村庄
    其它 进入其它岛屿

    点击岛屿

    进入子菜单移除lock
    进入全局菜单加上lock
    */
    function onClicked(param)
    {
//        trace("mapOnclick", param);
        if(param == 0)
        {
            global.director.popScene();
        }
        else{//进入某个大关卡
            inSmall = 1;
            curSmall = param;

            //场景调用移动
            scene.gotoIsland(param);
            var lock = island[param].get(LOCK_TAG);
            if(lock != null)
                lock.visible(0);
        }
    }
    

    var curSmall = -1;
    function gotoIsland(param){
        //进入其它岛屿
        //背景中点为位置---> 800 480 则左上角 和 屏幕左上角对齐
        //移动岛屿到屏幕中心 位置   背景基础位置 + 移动位置
        if(param>0 && param < len(island)){
            var pos=island[param].pos();
            var size=island[param].size();
            pos[0] = 1200-pos[0]-size[0]/2;
            pos[1] = 720-pos[1]-size[1]/2;
            bg.addaction(spawn(sineout(scaleto(1000,100,100)),sineout(moveto(1000,pos[0],pos[1]))));
        }
        //回到经营页面 缩放
        else{
            inSmall = 0;
            curSmall = -1;
            bg.addaction(spawn(sinein(scaleto(1000,50,50)),sinein(moveto(1000,400,240))));
            for(var i = 0; i < len(island); i++)
            {
                var lock = island[i].get(LOCK_TAG);
                if(lock != null)
                    lock.visible(1);
            }
        }
    }
}
