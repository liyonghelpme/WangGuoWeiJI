/*
因为MyNode bg 的put 已经被使用了所以需要判断 get得到的对象如果不是MyNode 则不处理exitScene

退出场景exitScene和被当前父亲节点删除关系
也就是父亲 exitScene 则 子节点也exitScene 修改场景状态
ins

退出场景 ins = 0
删除节点  =  bg removefrom  ins = 0
*/
class MyNode
{
    var ins;
    var bg;
    //var myChild;

    function MyNode()
    {
        ins = 0;
//        trace("Node ", ins);
    }
    function init()
    {
        bg.put(this);
        ins = 0;
        //myChild = [];
    }
    //都在exitScene的时候 删除自己
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

    /*
    节点从场景中出去 以及 重新回到场景中 需要 child重新添加入 bg.add(bg)
    */
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
        return this;
    }
    
    function getPos()
    {
        return bg.pos();
    }

    /*
    只是退出场景 也会删除myChild
    */
    function exitScene()
    {
        ins = 0;
        //bg.removefromparent();
        exitAllChild(); 
        //bg.put(null);
    }
    function addChild(child)
    {
        addChildZ(child, 0);
    }
    function addChildZ(child, z)
    {
        if(ins == 1)
            child.enterScene();
        bg.add(child.bg, z);
    }
    //mynode 调用isinstance 有问题？
    //重写 removeChild 方法
    function removeChild(child)
    {
        //if(child.isinstance(MyNode))
        //{
        child.removeSelf();
        //bg.remove(child.bg);
        //child.exitScene();
        //}
        //else
        //{
        //    trace("type child error", type(child));
        //}
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

class EmptyNode extends MyNode
{
    function EmptyNode()
    {
        bg = node();
        init();
    }
}
