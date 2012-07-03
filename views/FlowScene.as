class FlowScene extends MyNode
{
    var flowMenu;
    var island;
    //kind 0 1
    function FlowScene(k)
    {
        bg = node();
        init();
        island = new FlowIsland(this, k);
        addChild(island);
        flowMenu = new FlowMenu(this);
        addChild(flowMenu);
    }
}
