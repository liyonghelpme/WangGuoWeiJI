const FLAG_WIDTH = 50;
const FLAG_HEIGHT = 50;
const FLAG_SX = 20;
const FLAG_SY = 30;

class Flag extends MyNode
{
    var flag;
    //var showYet;
    var showArr;
    function Flag(p, sA)//如果旗帜是第一个红色旗帜那么显示相应的箭头 闯关结束数据更新则 相应的关卡更新 旗帜
    {
        bg = node().size(FLAG_WIDTH, FLAG_HEIGHT).pos(p[0]-(FLAG_WIDTH-FLAG_SX)/2, p[1]-(FLAG_HEIGHT-FLAG_SY)/2);
        init();
        flag = null;
        //showYet = 0;
        //if(showArr == 1)
        flag = bg.addsprite("map_flag_complete.png").size(FLAG_SX, FLAG_SY).anchor(50, 50).pos(FLAG_WIDTH/2, FLAG_HEIGHT/2);
        showArr = sA;
//        trace("showArr", showArr);
        if(showArr == 1)
            flag.addsprite("mapArrow.png").anchor(50, 100).pos(FLAG_SX/2, -20).addaction( repeat(moveby(500, 0, -20), moveby(500, 0, 20)) );
    }
    /*
    function update(diff)
    {
//        trace("showFlag", diff, flag, showYet);
        if(flag != null && showYet == 0)
        {
            showYet = 1;
            flag.addsprite("mapArrow.png").anchor(50, 100).pos(FLAG_SX/2, -20).addaction(sequence(delaytime(5000), repeat(moveby(500, 0, -20), moveby(500, 0, 20))));
        }
        global.timer.removeTimer(this); 
    }
    override function enterScene()
    {
//        trace("flag enterScene");
        super.enterScene();
        if(showArr == 1)
            global.timer.addTimer(this);
    }
    override function exitScene()
    {
        if(showArr == 1)
            global.timer.removeTimer(this);
        super.exitScene();
    }
    */
}
class LevelSelectLayer extends MyNode
{
    var index;
    //var maxLevel = 132;
    //不同等级的地图位置不同
    var flagPos = [
    [],//Level 0 is village
    [[303, 81], [241, 71], [179, 87], [139, 155],[239, 155], [220, 199], [147, 252]],
    [[164, 49], [122, 113], [151, 176], [236, 173], [314, 161], [399, 141], [399, 87]],
    [[85, 132], [138, 191], [213, 245], [305, 241], [391, 246], [407, 202], [393, 120]],
    [[146, 92], [360, 202], [247, 108], [317, 125], [416, 132], [461, 209], [401, 266]],
    [[359, 235], [296, 233], [286, 186], [348, 137], [276, 104], [218, 100], [151, 79]],

    //[[300,200],[340,220],[380,240],[420,260],[460,280],[500,300]]
    ];
    
    var darkNode;
    var levelNode;
    var scene;
    var islandLayer;
    var island;
    
    /*
    显示岛屿上的小关卡node
    点击选择难度的时候显示 新的浮动node 这个可以交给MapLayer 来控制
    index param diff
    */
    function setIslandLayer()
    {
        island = scene.getIsland(index);//大关

        var curDif = getCurEnableDif(); 
        islandLayer.removefromparent();
        islandLayer = island.addnode();

        trace("select Level", index, curDif);//小关
        var i;
        for(i=0; i < len(flagPos[index]) && index <= curDif[0]; i++){//该大关 某些关卡被开启 
            if(index == curDif[0] && i > curDif[1])//该大关 绿色表示 改关卡需要征服才能部分被开启
                break;

            var showArr = 0;
            if(index == curDif[0] && i == curDif[1])
                showArr = 1;
            var b = new Flag(flagPos[index][i], showArr);
            islandLayer.add(b.bg, FLAG_Z);
            new Button(b.bg, onSmall, i);
        }
        for(; i < len(flagPos[index]); i++){
            var b2 = sprite("map_flag_notcomplete.png").pos(flagPos[index][i]).size(20, 29);
            islandLayer.add(b2, FLAG_Z);
        }
    }
    //大关  
    function LevelSelectLayer(param, s){
        scene = s;
        //maxLevel = global.user.getValue("maxLevel");
        bg = node();
        init();

        index = param;
        darkNode = null;
        levelNode = null;

        var jz=bg.addsprite("map_label_big.png").size(150,45).anchor(0,0).pos(615,27).rotate(0);
        jz.addlabel(getStr("mapIsland"+str(index), null),null,33).anchor(50,50).pos(75,22).color(0,0,0,100);
        var back=bg.addsprite("map_back.png").pos(50,360);
        new Button(back, goBack, 0);
        var i;

        //maxLevel 当前  5 大关 * 6 小关* 10 难度 = 300 个关卡
        //maxLevel/10 解锁的关卡 - island (1-5) 
        island = scene.getIsland(index);//大关
        islandLayer = island.addnode();

    }
    
    function onSmall(param)
    {
//        trace("onSmall", param);
        scene.onSmall(param);   
    }
    function onDiff(param)
    {
//        trace("on Dif", param);
        scene.onDiff(param);
    }
    /*
    如果切换场景的话 就会关闭掉选择页面 但是岛屿上的旗帜没有回来
    如果关闭这个view 就需要彻底删除islander 
    */
    override function enterScene()
    {
        super.enterScene();
        //islandLayer.removefromparent();
        //island.add(islandLayer);
        setIslandLayer();
    }
    /*
    关闭选择对话框 则 移除所有旗帜
    */
    override function exitScene()
    {
        islandLayer.removefromparent();
        super.exitScene();
    }
    
    //状态:
    //全部岛屿 -> 某个岛屿小关 ->选择难度 -> 查看难度->进入游戏
    function goBack(){
        var sl = len(scene.contextStack);
//        trace("goBack", sl, scene.contextStack);
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
        else if(sl==3){//返回选择难度页面 没有该页面
            levelNode.addaction(sineout(moveto(1000,0,0)));
            scene.contextStack.pop();
        }
    }
    
    var small;
    function selectSmall(param)
    {
        small = param;
        darkNode = sprite("dark.png").size(801,481);
        bg.add(darkNode,-1);
        levelNode = node();
        

        levelNode.addsprite("map_level_info.png").anchor(50,50).pos(400,240);
        levelNode.addsprite("map_level_attack.png").anchor(100,0).pos(750,360).setevent(EVENT_TOUCH, attackNow);
        bg.add(levelNode,0);
    }
    function attackNow()
    {
        goBack();//close Choose Page

        var mon = getRoundMonster(index-1, small); 
        global.director.pushScene(
        new BattleScene(index-1, small, 
            mon, CHALLENGE_MON, null, null

        ));
        if(global.user.db.get("readYet") == null)//未曾读过战斗提示 显示战斗提示
            global.director.pushView(new NoTipDialog(), 1, 0);
    }
    function selectDiff(param)
    {
        levelNode.addaction(sineout(moveto(1000,-800,0)));
    }
}
