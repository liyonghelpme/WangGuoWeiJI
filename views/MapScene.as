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
    function CastleScene()
    {
        bg = node();
        init();

        var mc = new CastlePage();
        var ml = new MenuLayer();
        addChild(mc);
        addChild(ml);
    }
}
