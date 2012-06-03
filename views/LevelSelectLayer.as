const FLAG_WIDTH = 50;
const FLAG_HEIGHT = 50;
const FLAG_SX = 20;
const FLAG_SY = 30;

class Flag extends MyNode
{
    function Flag(p)
    {
        bg = node().size(FLAG_WIDTH, FLAG_HEIGHT).pos(p[0]-(FLAG_WIDTH-FLAG_SX)/2, p[1]-(FLAG_HEIGHT-FLAG_SY)/2);
        init();
        bg.addsprite("map_flag_complete.png").size(FLAG_SX, FLAG_SY).anchor(50, 50).pos(FLAG_WIDTH/2, FLAG_HEIGHT/2);
    }
}
class LevelSelectLayer extends MyNode
{
    var index;
    //var maxLevel = 132;
    //不同等级的地图位置不同
    var flagPos = [
    [],//Level 0 is village
    [[303, 81], [179, 87], [139, 155],[239, 155], [220, 199], [147, 252]],
    [[164, 49], [122, 113], [151, 176], [236, 173], [314, 161], [399, 87]],
    [[85, 132], [138, 191], [213, 245], [305, 241], [407, 202], [393, 120]],
    [[146, 92], [247, 108], [317, 125], [416, 132], [461, 209], [401, 266]],
    [[359, 235], [296, 233], [286, 186], [348, 137], [276, 104], [177, 89]],
    [[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]]
    ];
    
    var darkNode;
    var levelNode;
    var scene;
    var islandLayer;
    
    /*
    显示岛屿上的小关卡node
    点击选择难度的时候显示 新的浮动node 这个可以交给MapLayer 来控制
    index param diff
    */
    function LevelSelectLayer(param, s){
        scene = s;
        //maxLevel = global.user.getValue("maxLevel");
        bg = node();

        index = param;
        darkNode = null;
        levelNode = null;
        init();
        var jz=bg.addsprite("map_label_big.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
        jz.addlabel(getStr("mapIsland"+str(index), null),null,33).anchor(50,50).pos(75,22).color(0,0,0,100);
        var back=bg.addsprite("map_back.png").pos(50,360);
        new Button(back, goBack, 0);
        var i;

        //maxLevel 当前  5 大关 * 6 小关* 10 难度 = 300 个关卡
        //maxLevel/10 解锁的关卡 - island (1-5) 
        var curDif = getCurEnableDif();

        var island = scene.getIsland(param);
        islandLayer = island.addnode();
        //var isPos = island.pos();
        trace("select Level", param, curDif);
        //var newPos;
        for(i=0;i < 6 && index <= curDif[0]; i++){
            if(index == curDif[0] && i > curDif[1])
                break;
            //newPos = [isPos[0]+flagPos[index][i][0], isPos[1]+flagPos[index][i][1]]; 
            trace("flagPos", flagPos[index][i]);
            //var b = sprite("map_flag_complete.png").pos(flagPos[index][i]).size(20, 29);
            var b = new Flag(flagPos[index][i]);
            islandLayer.add(b.bg, FLAG_Z);
            new Button(b.bg, onSmall, i);
        }
        for(;i<6;i++){
            //newPos = [isPos[0]+flagPos[index][i][0], isPos[1]+flagPos[index][i][1]]; 
            var b2 = sprite("map_flag_notcomplete.png").pos(flagPos[index][i]).size(20, 29);
            islandLayer.add(b2, FLAG_Z);
        }
    }
    
    function onSmall(param)
    {
        trace("onSmall", param);
        scene.onSmall(param);   
    }
    function onDiff(param)
    {
        trace("on Dif", param);
        scene.onDiff(param);
    }
    override function exitScene()
    {
        islandLayer.removefromparent();
        super.exitScene();
    }
    /*
    function onClicked(param){
        trace("level select", param);
        scene.selectLevel(param);
    }
    */
    
    //状态:
    //全部岛屿 -> 某个岛屿小关 ->选择难度 -> 查看难度->进入游戏
    function goBack(){
        var sl = len(scene.contextStack);
        trace("goBack", sl, scene.contextStack);
        if(sl == 1){//返回主页面
            scene.gotoIsland(0);
        }
        else if(sl == 2){//返回小关页面
            darkNode.removefromparent();
            darkNode = null;
            levelNode.removefromparent();
            levelNode = null;
            scene.contextStack.pop();
        }
        else if(sl==3){//返回选择难度页面
            levelNode.addaction(sineout(moveto(1000,0,0)));
            scene.contextStack.pop();
        }
    }
    
    function selectSmall(param)
    {
        darkNode = sprite("dark.png").size(801,481);
        bg.add(darkNode,-1);
        levelNode = node();
        
        var first = 0;
        for(var i=0; i < 10 ; i++){
            var b=levelNode.addsprite("map_level_normal.png").anchor(50,50).pos(200+i%5*100, 180+i/5*90);
            //临时数据

            var starNum = getStar(index, param, i);

            //var level = getMaxLevel(index, param, i)
            //starNum = starNum[level];

            //if(maxLevel-index*60+60-param*10==i)
            //    starNum=0;
                
            var j;
            for(j=0;j < starNum;j++){
                b.addsprite("map_level_star1.png").anchor(50,0).pos(13+j*31,64);
            }
            for(;j<3;j++){
                b.addsprite("map_level_star0.png").anchor(50,0).pos(13+j*31,64);
            }
            new Button(b, onDiff, i);
            if(starNum == 0)
                break;
        }
        for(;i<10;i++){
            levelNode.addsprite("map_level_lock.png").anchor(50,50).pos(200+i%5*100, 180+i/5*90);
        }
        levelNode.addsprite("map_level_info.png").anchor(50,50).pos(1200,240);
        levelNode.addsprite("map_level_attack.png").anchor(100,0).pos(1550,360).setevent(EVENT_TOUCH, attackNow);
        bg.add(levelNode,0);
    }
    function attackNow()
    {
        trace("map index", index);
        global.director.pushScene(new Map(index-1, [[0, 0], [1, 1], [0, 2], [1, 3], [0, 10], [1, 11], [0, 12], [1, 13], [0, 20], [1, 21], [0, 22], [1, 23], [0, 30], [1, 31], [0, 32], [1, 33], [0, 40], [1, 41], [0, 42], [1, 43], [0, 50], [1, 51], [0, 52], [1, 53], [0, 60], [1, 61], [0, 62], [1, 63], [0, 70], [1, 71], [0, 72], [1, 73], [0, 80], [1, 81], [0, 82], [1, 83], [0, 90], [1, 91], [0, 92], [1, 93]]), 0, 0);
    }
    function selectDiff(param)
    {
        levelNode.addaction(sineout(moveto(1000,-800,0)));
    }
}
