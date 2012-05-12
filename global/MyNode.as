class MyNode
{
    var ins;
    var bg;

    function MyNode()
    {
        ins = 0;
        trace("Node ", ins);
    }
    function init()
    {
        bg.put(this);
        ins = 0;
    }
    function removeSelf()
    {
        bg.removefromparent();
        exitScene();
    }

    function enterScene()
    {
        ins = 1;
        var sub = bg.subnodes();
        if(sub != null)
            for(var i = 0; i < len(sub); i++)
            {
                var ch = sub[i].get();
                if(ch != null)
                {
                    ch.enterScene();
                }
            }
    }
    //[x, y]
    function setPos(p)
    {
        bg.pos(p);
    }
    
    function getPos()
    {
        return bg.pos();
    }
    function exitScene()
    {
        ins = 0;
        exitAllChild(); 
        //bg.put(null);
    }
    function addChild(child)
    {
        addChildZ(child, 0);
    }
    function addChildZ(child, z)
    {
        trace(child, z, ins);
        child.enterScene();
        bg.add(child.bg, z);
    }
    function removeChild(child)
    {
        bg.remove(child.bg);
        child.exitScene();
    }
    function exitAllChild()
    {
        var childs = bg.subnodes();
        if(childs == null)
            return;
        for(var i = 0; i < len(childs); i++)
        {
            if(childs[i].get() != null)
                childs[i].get().exitScene();
        }
    }
}
