class MapLayer extends MyNode
{
    var scene;
    var island;
    //var lockPos = [[0,0],[0,0],[244,151],[272,173],[400,167],[235,235]];
    var LockPos = [[0, 0], [189, 164], [232, 141], [269, 166], [336, 146], [232, 180]];
    var islandLayer;
    function initLock()
    {

        islandLayer.removefromparent();
        if(arrow != null)
        {
            arrow.removefromparent();
            arrow = null;
        }

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
        var curDif = getCurEnableDif(); 
        //big 0 1 2 3 4 5 
        //0 村落
        //1-5 其它岛屿
        //等级不足 不能开启
        //未击败不能开启
        var openBig = getOpenBig();
        for(;i <= curDif[0] && i <= ROUND_MAP_NUM && i <= openBig; i++){
            island[i].color(100,100,100,100);
            new Button(island[i], onClicked, i);
        }
        for(;i<=5;i++){
            island[i].color(40,40,40,100);
            var size=island[i].size();
            var lock = sprite("map_island_lock.png").anchor(50,50).pos(LockPos[i][0], LockPos[i][1]).scale(200);
            island[i].add(lock, LOCK_Z);
            new Button(island[i], onClicked, i);
        }
    }
    function MapLayer(s){
        scene = s;
        bg = node().size(1600,960).scale(50,50).anchor(50,50).pos(400,240);
        init();

        //map_label = bg.addsprite("map_label.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
        
        islandLayer = bg.addnode();
        //initLock();
        
        /*
        //var maxLevel = 132;
        var i=0;
        //big small
        var curDif = getCurEnableDif(); 
        for(;i <= curDif[0] && i <= 5; i++){
            island[i].color(100,100,100,100);
            //global.touchManager.addTargeted(new ButtonDelegate(island[i],1,0,bg.parent().get(),i),7-i,1);
            new Button(island[i], onClicked, i);
        }
        for(;i<=5;i++){
            island[i].color(40,40,40,100);
            var size=island[i].size();
            var lock = sprite("map_island_lock.png").anchor(50,50).pos(LockPos[i][0], LockPos[i][1]).scale(200);
            island[i].add(lock, LOCK_Z);
            //global.touchManager.addTargeted(new ButtonDelegate(island[i],1,0,bg.parent().get(),i),7-i,1);
            new Button(island[i], onClicked, i);
        }
        */
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
    var arrow = null;
    function showArrow()
    {
        if(arrow != null)
            return;
        island[0].prepare();
        var bsize = island[0].size();
        var bpos = island[0].pos();
        arrow = bg.addsprite("mapArrow.png").pos(bpos[0]+bsize[0]/2+14, bpos[1]-10).anchor(50, 100).addaction(repeat(moveby(500, 0, -20), moveby(500, 0, 20)));
        global.director.curScene.addChildZ(new UpgradeBanner(getStr("onVillage", null), [100, 100, 100]), MAX_MAP_LAYER);
    }
    function removeArrow()
    {
        if(arrow != null)
        {
            arrow.removefromparent();
            arrow = null;
        }
    }
    function getIsland(big)
    {
        return island[big]; 
    }
    var inSmall = 0;
    /*
    点击岛屿
    0 回到村庄
    其它 进入其它岛屿
    */
    function onClicked(param)
    {
//        trace("mapOnclick", param);
        if(param == 0)
        {
            global.director.popScene();
        }
        else{
            inSmall = 1;
            scene.gotoIsland(param);

            var curDif = getCurEnableDif(); 
            var openBig = getOpenBig();
            if(param > curDif[0] || param > openBig)
            {
                global.director.curScene.addChildZ(new UpgradeBanner(getStr("onNotOpen", null), [100, 100, 100]), MAX_MAP_LAYER);
            }
        }
    }
    

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
            bg.addaction(spawn(sinein(scaleto(1000,50,50)),sinein(moveto(1000,400,240))));
        }
    }
}
