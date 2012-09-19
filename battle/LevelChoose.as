//first: initData
//updateTab
//updatePage
//updateStar
class LevelChoose extends MyNode
{
    var big;// 大关编号
    var scene;
    var flowNode;
    var PAN_Y = 72;

    var INITX = 45;
    var DIFX = 180;
    var DIFY = 190;

    var ITEM_NUM = 4;
    var ROW_NUM = 2;

    //翻页移动距离
    var PAGE_WIDTH = DIFX*ITEM_NUM;//45 + 180*4 = 765
    var POINT_DIFX = 30;
    var PAGE_NUM = ITEM_NUM*ROW_NUM;
    var POINT_WIDTH = 13;
    var POINT_HEIGHT = 13;

    var cl;

    //是否开启大关
    //得分
    //0 1 2 第一个0分与众不同

    //小关数据
    //默认开启
    var data = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1];


    var pageLayer;
    var pageNum = [];
    var nums;
    function LevelChoose(sc, b)
    {
        big = b;
        scene = sc;
        bg = node();
        init();
        initData();
        bg.addsprite("title"+str(big)+".png").pos(34, 15);
        //bg.addsprite("map_back0.png").pos(704, 9).size(79, 58).setevent(EVENT_TOUCH, goBack);
        var but0 = new NewButton("map_back0.png", [79, 58], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], goBack, null);
        but0.bg.anchor(50, 50).pos(745, 38);
        bg.add(but0.bg);
        
        cl = bg.addnode().pos(INITX, PAN_Y).size(DIFX*ITEM_NUM, DIFY*ROW_NUM);
        flowNode = cl.addnode();
        
        var pn = (len(data)+PAGE_NUM-1)/PAGE_NUM;

        pageLayer = bg.addnode().pos(global.director.disSize[0]/2, 451).anchor(50, 0);
        pageLayer.size((pn-1)*POINT_DIFX+POINT_WIDTH, POINT_HEIGHT);

        for(var i = 0; i < pn; i++)
        {
            var difx = -((pn-1)*POINT_DIFX+POINT_WIDTH)/2+POINT_DIFX*i;

            var point = pageLayer.addsprite().pos(difx, 0);
            pageNum.append(point);
        }
        var enable = checkBigEnable(big);
        var tot;
        if(enable)
        {
            tot = bg.addsprite("totalStar.png").pos(239, 17).size(139, 46);
            tot.addsprite("star.png").pos(33, 22).anchor(50, 50).size(33, 31);
            //nums = new ShadowWords("0/0", null, 22, FONT_NORMAL, [100, 100, 100]);
            //tot.add(nums.bg);
            //nums.bg.pos(57, 14);
            nums = tot.addlabel("0/0", "heiti.ttf", 25).pos(57, 14);
        }
        else
        {
            tot = bg.addsprite("totalStar.png").pos(239, 17).size(170, 46);
            tot.addsprite("star.png").pos(33, 22).anchor(50, 50).size(33, 31);
            //nums = new ShadowWords("0/0", null, 22, FONT_NORMAL, [100, 100, 100]);
            //tot.add(nums.bg);
            //nums.bg.pos(57, 14);
            nums = tot.addlabel("0/0", "heiti.ttf", 25).pos(57, 14);
        }


        updateTab();
        updatePage();
        updateStar();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

    }
    function goBack()
    {
        scene.gotoIsland(0);//飞回 主界面
    }
    function initData()
    {
        data = [];

        var enable = checkBigEnable(big);
        for(var i = 0; i < 22; i++)
        {
            if(enable == 0)
            {
                if(i == 0)
                    data.append([0, -1]);//0 not open 1 open -1 showData
                else
                    data.append([0, 0]);
            }
            else
            {
                if(i < 10)
                    data.append([rand(4), 1]);
                else 
                {
                    data.append([0, 0]);
                }
            }
        }
    }
    function updateStar()
    {
        var enable = checkBigEnable(big);
        var total = PARAMS.get("smallNum")*3;
        if(enable)
        {
            var curStar = 0;
            for(var i = 0; i < PARAMS.get("smallNum"); i++)
            {
                var star = global.user.getCurStar(big, i);
                curStar += star;
            }
            //nums.setWords(str(curStar)+"/"+str(total));
            nums.text(str(curStar)+"/"+str(total));
        }
        else
        {
            //nums.setWords(getStr("totalStar", ["[NUM]", str(total)]));
            nums.text(getStr("totalStar", ["[NUM]", str(total)]));
        }
    }

    /*
    function initData()
    {
        data = [];
        var enable = checkBigEnable(big);
        var i;
        if(enable == 0)
        {
            data.append([0, -1]);//0 not open 1 open -1 showData
            for(i = 1; i < PARAMS.get("smallNum"); i++)
            {
                data.append([0, 0]);
            }
        }
        else
        {
            //var first = 1;
            for(i = 0; i < PARAMS.get("smallNum"); i++)
            {
                var ena = checkBigSmallEnable(big, i);
                var star = global.user.getCurStar(big, i);
                if(ena)
                    data.append([star, 1]);
                else 
                {
                    data.append([star, 0]);
                }
            }
        }
    }
    */

    function updatePage()
    {
        var i;
        var oldPos = flowNode.pos();
        var curPage = (-oldPos[0])/PAGE_WIDTH;
        for(i = 0; i < len(pageNum); i++)
        {
            if(i == curPage)
            {
                pageNum[i].texture("pointWhite.png");
            }
            else
                pageNum[i].texture("pointBlack.png");
        }
    }
    //var allPanels = [];
    function updateTab()
    {
        //allPanels = [];
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);
        var i;
        var j;
        //var first = 1;
        var mon;
        var sca;
        var mData = getData(MAP_INFO, big);

        var panel;
        panel = flowNode.addsprite("unlockPanel.png");
        var pSize = panel.prepare().size();
        for(i = 0; i < len(data); i++)
        {
            var page = i/(ITEM_NUM*ROW_NUM);
            var inPage = i % (ITEM_NUM*ROW_NUM);
            var row = inPage / ITEM_NUM;
            var col = inPage % ITEM_NUM;


            //未解锁大关 第一个块
            if(data[i][1] == -1)
            {
                panel = flowNode.addsprite("unlockPanel.png").pos(page*PAGE_WIDTH+col*DIFX+pSize[0]/2, row*DIFY+pSize[1]/2).anchor(50, 50);

                panel.addsprite("lock0.png").pos(26, 28).anchor(50, 50).size(25, 30);
                panel.addlabel(getStr("condition", null), null, 20).pos(48, 21);
                panel.addsprite("star.png").anchor(50, 50).pos(62, 70).size(33, 31);
                var starLevel = stringLines(getStr("starLevel", ["[STAR]", str(mData.get("needStar")), "[LEV]", str(mData.get("needLevel"))]), 18, 21, [100, 100, 100], FONT_NORMAL);
                panel.add(starLevel);
                starLevel.pos(21, 64);

                //space 18---8 4*8= 32
                var but0 = new NewButton("greenButton0.png", [151, 49], getStr("unlock", ["[gold]", str(mData.get("gold"))]), null, 18, FONT_NORMAL, [100, 100, 100], onUnlock, null);
                panel.add(but0.bg);
                but0.bg.anchor(50, 50).pos(80, 147);
                but0.bg.addsprite("gold.png").pos(17, 24).size(30, 30).anchor(50, 50);
            }
            //小关是否开启
            else if(data[i][1] == 1)
            {
                
                panel = flowNode.addsprite("bluePanel0.png").pos(page*PAGE_WIDTH+col*DIFX+pSize[0]/2, row*DIFY+pSize[1]/2).anchor(50, 50);
                if(data[i][0] > 0)
                {
                    mon = panel.addsprite("soldier0.png").pos(79, 84).anchor(50, 50);
                    sca = getSca(mon, [164, 42]);
                    mon.scale(sca);

                    var bSize = mon.prepare().size();
                    var shadow = sprite("roleShadow.png").pos(bSize[0]/2, bSize[1]).anchor(50, 50).size(64, 32);
                    mon.add(shadow, -1);
                }

                //是否获得分
                //是否获得满分
                var sb;
                if(data[i][0] == 0)
                {
                    mon = panel.addsprite("soldier0.png").pos(79, 107).anchor(50, 50);
                    sca = getSca(mon, [164, 67]);
                    mon.scale(sca);
                }
                else if(data[i][0] < 3)
                    sb = panel.addsprite("starNot").pos(82, 149).anchor(50, 50);
                else
                    sb = panel.addsprite("starFull").pos(82, 149).anchor(50, 50);
                if(data[i][0] > 0)
                {
                    var ix = 28;
                    var dx = 47;
                    for(j = 0; j < data[i][0]; j++)
                    {
                        sb.addsprite("star.png").pos(ix+j*dx, 29).anchor(50, 50);
                    }
                    for(; j < 3; j++)
                        sb.addsprite("star2.png").pos(ix+j*dx, 29).anchor(50, 50);
                }
            }
            //未开通关卡
            else
            {
                panel = flowNode.addsprite("unlockPanel.png").pos(page*PAGE_WIDTH+col*DIFX+pSize[0]/2, row*DIFY+pSize[1]/2).anchor(50, 50);
                panel.addsprite("lock0.png").pos(86, 116).anchor(50, 50);
            }
            panel.put(i);
            //allPanels.append(panel);
            if(data[i][1] != -1)
            {
                var w = altasWord("bold", str(i+1));
                w.pos(80, 36).anchor(50, 50);
                panel.add(w);
            }
        }
    }
    function onUnlock()
    {
        var mData = getData(MAP_INFO, big);
        var cost = dict([["gold", mData.get("gold")]]);
        var buyable = global.user.checkCost(cost);
        if(buyable.get("ok") == 0)
        {
            global.director.curScene.addChildZ(new UpgradeBanner(getStr("lack", ["[NUM]", str(buyable.get("gold")), "[NAME]", getStr("gold", null)]), [100, 100, 100], null), MAX_MAP_LAYER);
            return;
        }
        
        global.user.doCost(cost);
        global.user.enableLevel(big);

        global.httpController.addRequest("challengeC/enableDif", dict([["uid", global.user.uid], ["big", big], ["gold", cost.get("gold")]]), null, null);
        updateData();
    }
    function updateData()
    {
        initData();
        updateTab();
        updatePage();
        updateStar();
        scene.islandLayer.updateData();
    }
    var lastPoints;
    var accMove;
    var curTouch;
    var oldScale;
    var player = null;
    function touchBegan(n, e, p, x, y, points)
    {
        accMove = 0;
        lastPoints = n.node2world(x, y);
        curTouch = checkInChild(flowNode, lastPoints);
        if(curTouch != null)
        {
            oldScale = bg.scale();
            curTouch.scale(oldScale[0]*80/100, oldScale[1]*80/100);
            player = global.controller.butMusic.play(0, 80, 80, 0, 100);
        }
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];
        accMove += abs(difx);


        var fPos = flowNode.pos();
        fPos[0] += difx;
        flowNode.pos(fPos);
    }

    function touchEnded(n, e, p, x, y, points)
    {
        if(curTouch != null)
        {
            curTouch.scale(oldScale);
            curTouch = null;
            player.stop();
            player = null;
        }

        if(accMove < 10)//点击选关
        {
            var newPos = n.node2world(x, y);
            var child = checkInChild(flowNode, newPos);
            if(child != null)
            {
                var selectNum = child.get();
                var enable = checkBigSmallEnable(big, selectNum);
                if(enable)
                {
                    attackNow(selectNum);
                }
            }
        }
        //当前位置
        var oldPos = flowNode.pos();
        //当前页面
        var pn = -oldPos[0]/PAGE_WIDTH;
        var rem = -oldPos[0]%PAGE_WIDTH;
        if(rem > PAGE_WIDTH/2 && rem > 0)//pn == 0 
        {
            pn += 1;
        }

        var total = (len(data)+PAGE_NUM-1)/PAGE_NUM;
        trace("curPage", pn, rem, oldPos[0], total, PAGE_NUM, PAGE_WIDTH);

        pn = min(max(0, pn), total-1);

        oldPos[0] = -pn*PAGE_WIDTH;
        flowNode.pos(oldPos);

        updatePage();

    }
        
    function attackNow(small)
    {
        goBack();//关闭 选择 小关卡 闯关结束 更新

        var mon = getRoundMonster(big, small); 
        global.director.pushScene(
        new BattleScene(big, small, 
            mon, CHALLENGE_MON, null, null

        ));

    }
}
