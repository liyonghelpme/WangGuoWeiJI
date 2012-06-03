class MapLayer extends MyNode
{
    var scene;
    var island;
    //var lockPos = [[0,0],[0,0],[244,151],[272,173],[400,167],[235,235]];
    var LockPos = [[0, 0], [189, 164], [232, 141], [269, 166], [336, 146], [232, 180]];
    function MapLayer(s){
        scene = s;
        bg = node().size(1600,960).scale(50,50).anchor(50,50).pos(400,240);
        init();
        island = new Array(6);
        island[0] = bg.addsprite("map_island0.png",ARGB_8888, ALPHA_TOUCH).size(175,144).anchor(0,0).pos(512,402).rotate(0);
        island[1] = bg.addsprite("map_island1.png",ARGB_8888, ALPHA_TOUCH).size(431,390).anchor(0,0).pos(130,298).rotate(0);
        island[2] = bg.addsprite("map_island2.png",ARGB_8888, ALPHA_TOUCH).size(485,355).anchor(0,0).pos(336,594).rotate(0);
        island[3] = bg.addsprite("map_island3.png",ARGB_8888, ALPHA_TOUCH).size(548,439).anchor(0,0).pos(772,422).rotate(0);
        island[4] = bg.addsprite("map_island4.png",ARGB_8888, ALPHA_TOUCH).size(519,428).anchor(0,0).pos(994,220).rotate(0);
        island[5] = bg.addsprite("map_island5.png",ARGB_8888, ALPHA_TOUCH).size(524,439).anchor(0,0).pos(550,14).rotate(0);
        //map_label = bg.addsprite("map_label.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
        
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
    }
    function getIsland(big)
    {
        return island[big]; 
    }
    var inSmall = 0;
    function onClicked(param)
    {
        trace("mapOnclick", param);
        if(param == 0)
        {
            global.director.popScene();
        }
        else{
            inSmall = 1;
            scene.gotoIsland(param);
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
