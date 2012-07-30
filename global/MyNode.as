class MyNode
{
    var ins;
    var bg;

    function MyNode()
    {
        ins = 0;
//        trace("Node ", ins);
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
    function setZord(z)
    {
        var par = bg.parent();
        if(par != null)
        {
            bg.removefromparent();
            par.add(bg, z);
        }
    }

    function enterScene()
    {
//        trace("enterScene", this);
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
//        trace("addChild", child, z, ins);
        if(ins == 1)
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
    function addCus(act)
    {
        act.bg = bg;
        bg.addaction(act.cus);
    }
}
