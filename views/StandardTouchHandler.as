//Only a interface 
class StandardTouchHandler
{
    var bg;
    var lastPos;

    function enterScene()
    {
        //super.enterScene();
        bg.setevent(EVENT_TOUCH|EVENT_MULTI_TOUCH, tBegan);
        bg.setevent(EVENT_MOVE, tMove);
        bg.setevent(EVENT_UNTOUCH, tEnded);
        //global.touchManager.addStandard(this);
    }
    function tBegan(n, e, p, x, y, points)
    {
        var newPos = getWorldPos(n, points);
        touchBegan(newPos);
    }
    function tMove(n, e, p, x, y, points)
    {
        var newPos = getWorldPos(n, points);
        touchMove(newPos); 
    }
    function tEnded(n, e, p, x, y, points)
    {
        var newPos = getWorldPos(n, points);
        touchEnded(newPos);
    }
    /*
    function exitScene()
    {
        global.touchManager.removeTouch(this);
        //super.exitScene();
    }
    */
    function touchBegan(points)
    {
        //trace("began", points);
        lastPos = points;
        return 1;
    }
    function MoveBack(difx, dify)
    {
        var oldPos = bg.pos();

        bg.pos(oldPos[0]+difx, oldPos[1]+dify);
        var leftTop = bg.world2node(0, 0);
        var rightBottom = bg.world2node(global.director.disSize[0], global.director.disSize[1]);
        if(leftTop[0] < 0 && difx > 0)
            difx = 0;
        if(leftTop[1] < 0 && dify > 0)
            dify = 0;
        if(rightBottom[0] > bg.size()[0] && difx < 0)
            difx = 0;
        if(rightBottom[1] > bg.size()[1] && dify < 0)
            dify = 0;
        bg.pos(oldPos[0]+difx, oldPos[1]+dify);
    }
    function ScaleBack(sca)
    {
        var oldScale = bg.scale();

        if(oldScale[0]+sca >= 200 || oldScale[0]+sca <= 50)
            return;

        bg.scale(oldScale[0]+sca, oldScale[1]+sca);
        var leftTop = bg.world2node(0, 0);
        var rightBottom = bg.world2node(global.director.disSize[0], global.director.disSize[1]);

        if(leftTop[0] < 0 && sca < 0)  
            sca = 0;
        if(leftTop[1] < 0 && sca < 0)
            sca = 0;
        if(rightBottom[0] > bg.size()[0] && sca < 0)
            sca = 0;
        if(rightBottom[1] > bg.size()[1] && sca < 0)
            sca = 0;
        bg.scale(oldScale[0]+sca, oldScale[1]+sca);
        return sca;
    }
    function touchMove(points)
    {
        //trace("move", points);
        var oldPos = lastPos;
        lastPos = points;
        var difx;
        var dify;
        if(len(points) >= 3)//-1 0 1
        {
            if(len(oldPos) < 3)
                return;
            var oldDis = distance(oldPos[0], oldPos[1]); 
            var newDis = distance(points[0], points[1]);
            var sca = newDis-oldDis;
            //var move = midMove(oldPos, points);
            difx = oldPos[1][0]-oldPos[0][0];
            dify = oldPos[1][1]-oldPos[0][1];
            var midOld = [oldPos[0][0]+difx/2, oldPos[0][1]+dify/2];
            var oldInBg = bg.world2node(midOld[0], midOld[1]);
            sca = ScaleBack(sca);
            var newInBg = bg.node2world(oldInBg[0], oldInBg[1]);
            var move = [midOld[0]-newInBg[0], midOld[1]-newInBg[1]];
            MoveBack(move[0], move[1]);

        }
        else if(len(points) >= 2)
        {
            var leftFinger = 0;
            if(points[0] == null)
                leftFinger = 1;
            difx = points[leftFinger][0]-oldPos[leftFinger][0];
            dify = points[leftFinger][1]-oldPos[leftFinger][1];
            MoveBack(difx, dify);
        }
    }
    function touchEnded(points)
    {
        //trace("ended", points);
    }
    
}
