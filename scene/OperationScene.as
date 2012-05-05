class OperationScene extends MyNode
{
    var map;
    function OperationScene(){
        bg = node();
        init();
        map = new OperationLayer();
        addChildZ(map,0);
        addChildZ(new MenuLayer(),1);
    }
}