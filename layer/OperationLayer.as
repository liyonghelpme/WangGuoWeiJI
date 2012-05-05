class OperationLayer extends MyNode
{
    function OperationLayer(){
        bg = sprite("background.jpg").anchor(50,50).pos(400,240).size(800,480);
        init();
        bg.add(sprite("apple.png").pos(400,10).size(64,64).setevent(EVENT_UNTOUCH,newFall),10);
    }
    function newFall(){
        new FallObject(bg,0).animateFall();
    }
}