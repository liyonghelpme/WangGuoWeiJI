class Neibor extends FriendList
{
    function Neibor(s)
    {
        friendKind = VISIT_NEIBOR;
        scene = s;
        initView();
        initData();
        updateTab();
    }
    function initView()
    {
        bg = node();
        init();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }

    //显示添加好友为邻居  增加好友空位 
    function showEmptySeat()
    {
        data = global.friendController.getNeibors();
        //setCrystal();//只在邻居数据中增加水晶
        data = copy(data);

        var neiborMax = global.user.getValue("neiborMax");

        if(neiborMax > len(data))
        {
            for(var i = 0; i < (neiborMax-len(data)); i++)
                data.append(dict([["uid", EMPTY_SEAT], ["id", -1], ["name", getStr("emptySeat", null)], ["level", 0]]));
        }
        //增加邻居上限
        data.append(dict([["uid", ADD_NEIBOR_MAX], ["id", -1], ["name", getStr("addNeiborMax", null)], ["level", 0]]));
        trace("neiborMax", neiborMax, len(data));
    }
    override function updateData()
    {
        showEmptySeat();
    }
    
    override function update(diff)
    {
        //好友控制器 获取推荐好友数据成功
        if(global.friendController.initNeiborYet == 1 && data == null)
        {
            data = global.friendController.getNeibors();
            initYet = 1;
            updateData();
            updateTab();
        }
    }
    
    override function initData()
    {
        data = global.friendController.getNeibors();
        if(data == null)
        {
            initYet = 0;
        }
        else 
        {
            initYet = 1;
            updateData();
            updateTab();
        }
    }

}
