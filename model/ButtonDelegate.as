class ButtonDelegate
{
    var bg;
    var needRelease;
    var needScale;
    var lastPos;
    
    var callBackObject;
    var callBackParam;
    function ButtonDelegate(node, nr, ns, cbo, cbp){
        lastPos=null;
        needRelease = nr;
        needScale = ns;
        bg = node;
        
        callBackObject = cbo;
        callBackParam = cbp;
    }
    
    function touchBegan(x, y)
    {
        if(bg==null || bg.parent() == null){
            global.touchManager.removeTouch(this);
            return 0;
        }
        var pos = bg.world2node(x, y);
        lastPos = [x, y];
        return pos[0] < bg.size()[0] && pos[1] < bg.size()[1] && pos[0] > 0 && pos[1] > 0;
    }
    function touchMove(x, y)
    {
        var pos = bg.world2node(x, y);
        if(lastPos!=null){
            var ret=pos[0] < bg.size()[0] && pos[1] < bg.size()[1] && pos[0] > 0 && pos[1] > 0;
            if(ret==1){
                if(needScale==1){
                    bg.scale(110,110);
                }
            }
            else{
                if(needRelease==1){
                    lastPos=null;
                }
                else{
                    ret = 1;
                }
                if(needScale==1){
                    bg.scale(100,100);
                }
            }
            return ret;
        }
        return 0;
    }
    function touchEnded(x, y)
    {
        var pos = bg.world2node(x, y);
        if(lastPos!=null){
            var ret=pos[0] < bg.size()[0] && pos[1] < bg.size()[1] && pos[0] > 0 && pos[1] > 0;
            if(ret == 1){
                callBackObject.onclicked(callBackParam);
            }
        }
        if(needScale==1){
            bg.scale(100,100);
        }
    }
}