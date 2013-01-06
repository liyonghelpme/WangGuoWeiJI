class OtherPlayer extends FriendList
{
    //访问木瓜好友 或者 推荐好友
    //获取所有木瓜好友 获取 100个推荐好友 显示木瓜好友100
    var recommand = null;
    var papayaFriend = null;
    function OtherPlayer(s)
    {
        friendKind = VISIT_OTHER;
        scene = s;
        initView();
        initData();
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

    //第一个位置邀请好友
    //得到100个推荐好友 和 所有的 我方好友之后 初始化结束
    //设定每个好友数据的内部编号
    override function updateData()
    {
        data = global.friendController.getOtherFriend();
        for(var i = 0; i < len(data); i++)
        {
            data[i].update("curNum", i);
        }
        data.insert(0, dict([["uid", INVITE_FRIEND], ["id", -1], ["name", getStr("emptySeat", null)], ["level", 0], ["curNum", -1]]));
    }

    override function initData()
    {
        papayaFriend = global.friendController.getPapayaList();
        recommand = global.friendController.getRecommand();
        data = null;
        if(papayaFriend == null || recommand == null)
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

    override function update(diff)
    {
        //好友控制器 获取推荐好友数据成功
        if(global.friendController.initFriend == 1 && global.friendController.initYet == 1 && data == null)
        {
            papayaFriend = global.friendController.getPapayaList();
            recommand = global.friendController.getRecommand();
            trace("papayaFriend", len(papayaFriend), len(recommand));
            initYet = 1;
            updateData();
            updateTab();
        }
    }
}
