//根据 用户的邻居上限
class Neibor extends FriendList
{
    function Neibor(p, s, sc)
    {
        friendKind = VISIT_NEIBOR;
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode();
        initData();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    //正常获取数据之后 更新座位数据
    //水晶在数据初始化的时候生成
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
class PapayaFriend extends FriendList
{
    function PapayaFriend(p, s, sc)
    {
        friendKind = VISIT_PAPAYA;
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode();
        initData();


        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }



    override function initData()
    {
        data = global.friendController.getPapayaList();
        if(data == null)
        {
            initYet = 0;
        }
        else
        {
            initYet = 1;
            //setCrystal();
            updateTab();
        }
    }


    override function update(diff)
    {
        //好友控制器 获取推荐好友数据成功
        if(global.friendController.initFriend == 1 && data == null)
        {
            data = global.friendController.getPapayaList();
            //setCrystal();
            initYet = 1;
            updateTab();
        }
    }
}
class Recommand extends FriendList
{
    function Recommand(p, s, sc)
    {
        friendKind = VISIT_RECOMMAND;
        scene = sc;
        bg = node().pos(p).size(s).clipping(1);
        init();
        flowNode = bg.addnode();
        initData();

        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }


    override function update(diff)
    {
        //好友控制器 获取推荐好友数据成功
        if(global.friendController.initYet == 1 && data == null)
        {
            data = global.friendController.getRecommand();
            initYet = 1;
            trace("getRecommand", data);
            updateTab();
        }
    }

    override function initData()
    {
        data = global.friendController.getRecommand();
        trace("getRecommand", data);
        if(data == null)
        {
            initYet = 0;
        }
        else
        {
            initYet = 1;
            updateTab();
        }
    }
}
/*
;首先获取所有好友的信息 friend 逐行显示
当好友没有的时候再去显示所有其它的好友

显示邻居数据的过程:
*/
class FriendDialog extends MyNode
{
    //var cl;
    //var flowNode;
    //var friend;//FriendControler

    const OFFX = 168;
    const OFFY = 165;
    const ITEM_NUM = 4;
    const ROW_NUM = 2;
    const WIDTH = OFFX * ITEM_NUM;
    const HEIGHT = OFFY*ROW_NUM;
    

    var views;
    var curSel = -1;

    var titles = ["dialogNeibor.png", "dialogPapa.png", "dialogRec.png"];
    var showTitle;
    function FriendDialog()
    {
        bg = sprite("dialogFriend.png");
        init();
        //initData();
        bg.addsprite("dialogFriendTitle.png").pos(60, 8);
        bg.addsprite("closeBut.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        var but1 = bg.addsprite("roleNameBut0.png").pos(350, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, switchView, 0);
but1.addlabel(getStr("showNeibor", null), "fonts/heiti.ttf", 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);

        but1 = bg.addsprite("roleNameBut0.png").pos(500, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, switchView, 1);
but1.addlabel(getStr("showPapaya", null), "fonts/heiti.ttf", 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);

        var but0 = bg.addsprite("roleNameBut0.png").pos(650, 43).anchor(50, 50).size(129, 41).setevent(EVENT_TOUCH, switchView, 2);
but0.addlabel(getStr("recFriend", null), "fonts/heiti.ttf", 25).pos(64, 20).anchor(50, 50).color(100, 100, 100);

        showTitle = bg.addsprite("dialogNeibor.png").pos(396, 95).anchor(50, 50);
        
        var po = [74, 120];
        var sz = [WIDTH, HEIGHT-4];

        var nei = new Neibor(po, sz, this);
        var paf = new PapayaFriend(po, sz, this);
        var rec = new Recommand(po, sz, this);
        views = [nei, paf, rec];
        
        switchView(null, null, 0, null, null, null);

    }
    function switchView(n, e, sel, x, y, points)
    {
        if(curSel != sel)
        {
            if(curSel != -1)
                views[curSel].removeSelf();
            curSel = sel;

            addChild(views[curSel]);
            showTitle.texture(titles[curSel]);
        }
        
    }

    override function enterScene()
    {
        super.enterScene();
        global.timer.addTimer(this);
    }
    override function exitScene()
    {
        global.timer.removeTimer(this);
        super.exitScene();
    }
    var showRefresh = null;
    function update(diff)
    {
        if(curSel != -1)
        {
            //trace("initYet", views[curSel].initYet);
            if(views[curSel].initYet != 1)
            {
                if(showRefresh == null)
                {
                    showRefresh = bg.addsprite().addaction(repeat(animate(2000, "feed0.png", "feed1.png","feed2.png","feed3.png","feed4.png","feed5.png","feed6.png","feed7.png"))).anchor(50, 50).pos(402, 239);
                }
            }
            else
            {
                if(showRefresh != null )
                {
                    showRefresh.removefromparent();
                }
            }
        }
    }

    function closeDialog()
    {
        global.director.popView();
    }
    function addFriend()
    {
    }
    function sendGift()
    {
    }
}
