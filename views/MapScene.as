class MapScene extends MyNode
{
    var maxLevel;
    var islandLayer;
    var flyLayer;
    
    var contextStack;
    function MapScene(){
        bg = sprite("map_background.png").size(801,481);
        init();
        islandLayer = new MapLayer();
        addChildZ(islandLayer ,1);
        
        flyLayer = new FlyLayer();
        addChildZ(flyLayer, 2);
        
        bg.add(sprite("map_toplayer.png").size(801,481),4);
        
        contextStack=[];
    }
    
    function gotoIsland(param){
        var sl = len(contextStack);
        if((sl==0 && param!=0) || (sl==1 && contextStack[1]!=param)){
            removeChild(flyLayer);
            if(param == 0){
                flyLayer = new FlyLayer();
                contextStack.pop();
            }
            else{
                flyLayer = new LevelSelectLayer(param);
                if(sl==0){
                    contextStack.append(param);
                }
                else{
                    contextStack[1] = param;
                }
            }
            islandLayer.gotoIsland(param);
            bg.addaction(sequence(delaytime(1000),callfunc(refreshFly)));
        }
    }
    
    function selectLevel(param){
        var sl = len(contextStack);
        if(sl==1 && param<6){
            flyLayer.selectLevel(param);
            contextStack.append(param);
        }
        else if(sl==2 && param>=10){
            flyLayer.selectLevel(param);
            contextStack.append(param-10);
        }
    }
    
    function refreshFly(){
        addChildZ(flyLayer,2);
    }
}
class CastleScene extends MyNode
{
    var hideTime = 0;
    var inHide = 0;
    var mc;
    var ml;
    function CastleScene()
    {
        bg = node();
        init();

        mc = new CastlePage(this);
        ml = new MenuLayer(this);
        addChild(mc);
        addChild(ml);
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
    function finishBuild()
    {
        var id = building.get("id");
        var cost = getBuildCost(id);
        global.user.doCost(cost);
        ml.finishBuild();
        mc.finishBuild();
        global.director.popView();
        building = null;
    }
    function cancelBuild()
    {
        ml.finishBuild();
        mc.cancelBuild();
        global.director.popView(); 
        building = null;
    }
    function clearHideTime()
    {
        hideTime = 0;
        if(inHide == 1)
        {
            inHide = 0;
            ml.showMenu();
        }
    }
    function update(diff)
    {
        hideTime += diff;
        if(hideTime >= 10000)
        {
            hideTime = 0;
            if(inHide == 0)
            {
                inHide = 1;
                ml.hideMenu();
            }
        }
    }
    var building = null;
    function build(id)
    {
        building = getBuild(id);
        building.update("state", 0);
        ml.beginBuild();   
        mc.beginBuild(building);
        global.director.pushView(new BuildMenu(this, building));
    }
}
