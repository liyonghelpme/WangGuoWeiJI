class MakeDrug extends MyNode
{
    var flowNode;
    var prescriptions;// = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];

    const OFFY = 75;
    const ROW_NUM = 5;
    const ITEM_NUM = 1;
    const WIDTH = 710;
    const HEIGHT = 375;
    const PANEL_WIDTH = 703;
    const PANEL_HEIGHT = 72;
    const INIT_X = 46;
    const INIT_Y = 90;
    var MakeWhat;
    function initData()
    {
        prescriptions = [];
        var i;
        var key = prescriptionData.keys(); 
        var pData;
        if(MakeWhat == MAKE_DRUG)
        {
            for(i = 0; i < len(key); i++)
            {
                pData = getData(PRESCRIPTION, key[i])

                if(pData.get("kind") == DRUG)
                {
                    prescriptions.append(key[i]);
                }
            }
        }
        else if(MakeWhat == MAKE_EQUIP)
        {
            for(i = 0; i < len(key); i++)
            {
                pData = getData(PRESCRIPTION, key[i]);
                if(pData.get("kind") == EQUIP)
                    prescriptions.append(key[i]);
            }
        }
    }

    function MakeDrug(k)
    {
        MakeWhat = k;
        bg = node().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        init();
        initData();
        flowNode = bg.addnode();

        updateTab();
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];
        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);

        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowNode.pos();
        var rows = (len(prescriptions)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(prescriptions);
        return [max(0, lowRow-(ROW_NUM-1)), min(rowNum, upRow+(ROW_NUM+1))];
    }
    function updateTab()
    {
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = bg.addnode().pos(oldPos);

        var rg = getRange();
        var temp;
        var sca;
        var but0;
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var data = getData(PRESCRIPTION, prescriptions[i]);
            var kind = data.get("kind");
            var level = data.get("level");
            var id = data.get("tid");
            var panel;
            panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            panel.put(i);

            var tarData = getData(kind, id);

            temp = panel.addsprite(replaceStr(KindsPre[kind], ["[ID]", str(id)])).anchor(50, 50).pos(74, 28).color(100, 100, 100, 100);
            sca = getSca(temp, [68, 44]);
            temp.scale(sca);
            panel.addlabel(tarData["name"], "fonts/heiti.ttf", 15).anchor(50, 50).pos(77, 57).color(0, 0, 0);
            temp = panel.addsprite("equal.png").anchor(0, 0).pos(143, 23).size(33, 26).color(100, 100, 100, 100);

            var needs = data.get("needs");
            var CURX = 232;
            var CURY = 28;
            var DIFFX = 130;
            var makable = 1;
            
            for(var j = 0; j < len(needs); j++)
            {
                var hid = needs[j][0];
                var hNum = needs[j][1];
                var hData = getData(HERB, hid);

                temp = panel.addsprite(replaceStr(KindsPre[HERB], ["[ID]", str(hid)])).anchor(50, 50).pos(CURX, CURY).color(100, 100, 100, 100);
                sca = getSca(temp, [68, 44]);
                temp.scale(sca);
                panel.addlabel(hData.get("name"), "fonts/heiti.ttf", 15).anchor(50, 50).pos(CURX, 57).color(0, 0, 0);
                var ownNum = global.user.getGoodsNum(HERB, hid);
                var co = [20, 71, 20];
                if(ownNum < hNum)
                {
                    co = [99, 42, 47];
                    makable = 0;
                }
                panel.addlabel(str(hNum), "fonts/heiti.ttf", 20).anchor(0, 50).pos(CURX+21, 45).color(co[0], co[1], co[2]);


                if(j < (len(needs)-1))
                    temp = panel.addsprite("plus.png").anchor(0, 0).pos(CURX+50, 18).size(35, 35).color(100, 100, 100, 100);
                CURX += DIFFX;
            }

            but0 = new NewButton("roleNameBut1.png", [123, 40], getStr("forge", null), null, 18, FONT_NORMAL, [100, 100, 100], makeDrug, i);
            but0.bg.pos(619, 36);
            panel.add(but0.bg);
            if(makable == 0)
            {
                but0.setGray();
                but0.setCallback(null);
                but0.word.setWords(getStr("resNot", null));
            }
            if(MakeWhat == MAKE_DRUG)
                but0.word.setWords(getStr("doDrug", null));

        }
    }
    /*
    配方ID---> 对应的配方数据
    */
    function makeDrug(curNum)
    {
        var p = prescriptions[curNum];
        var pre = getData(PRESCRIPTION, p);
        
        var needs = pre.get("needs");
        var kind = pre.get("kind");
        var tid = pre.get("tid");
        //消耗药材和矿石
        for(var i = 0; i < len(needs); i++)
        {
            global.user.changeGoodsNum(HERB, needs[i][0], -needs[i][1]); 
        }
        if(kind == DRUG)
        {
            global.httpController.addRequest("goodsC/makeDrug", dict([["uid", global.user.uid], ["pid", p]]), null, null); 
            global.user.makeDrug(tid);
        }
        else if(kind == EQUIP)
        {
            var eid = global.user.getNewEid();
            global.httpController.addRequest("goodsC/makeEquip", dict([["uid", global.user.uid], ["eid", eid], ["pid", p]]), null, null); 
            global.user.makeEquip(eid, tid);
        }
        global.director.curScene.addChild(new UpgradeBanner(getStr("makeSuc", null) , [100, 100, 100], null));

        updateTab();
        
        if(kind == DRUG)
            global.taskModel.doDayTaskByKey("makeDrug", 1);
        if(kind == EQUIP)
            global.taskModel.doDayTaskByKey("forge", 1);
    }
}
class Herb extends MyNode
{
    var herbs;// = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
    var flowNode;

    const OFFY = 75;
    const ROW_NUM = 5;
    const ITEM_NUM = 1;
    const WIDTH = 710;
    const HEIGHT = 375;
    const PANEL_WIDTH = 703;
    const PANEL_HEIGHT = 72;
    const INIT_X = 46;
    const INIT_Y = 90;
    var MakeWhat;

    function initData()
    {
        herbs = [];
        var i;
        var key = herbData.keys();
        var hData;
        if(MakeWhat == MAKE_DRUG)
        {
            for(i = 0; i < len(key); i++)
            {
                hData = getData(HERB, key[i]);
                if(hData.get("kind") == MEDICINE)
                {
                    herbs.append(key[i]);
                }
            }
        }
        else if(MakeWhat == MAKE_EQUIP)
        {
            for(i = 0; i < len(key); i++)
            {
                hData = getData(HERB, key[i]);
                if(hData.get("kind") == ORE)
                {
                    herbs.append(key[i]);
                }
            }
        }
    }
    function Herb(k)
    {
        MakeWhat = k;
        bg = node().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        init();
        initData();
        flowNode = bg.addnode();
        updateTab();
        bg.setevent(EVENT_TOUCH, touchBegan);
        bg.setevent(EVENT_MOVE, touchMoved);
        bg.setevent(EVENT_UNTOUCH, touchEnded);
    }
    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(herbs);
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    function updateTab()
    {
//        trace("init Herb View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = bg.addnode().pos(oldPos);

        var rg = getRange();
        var temp;
        var but0;
        var sca;
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            var data = getData(HERB, herbs[i]);


            temp = panel.addsprite("herb"+str(herbs[i])+".png").anchor(50, 50).pos(45, 35).color(100, 100, 100, 100);
            sca = getSca(temp, [68, 56]);
            temp.scale(sca);
            temp = panel.addlabel(data["name"]+" "+data["des"], "fonts/heiti.ttf", 18, FONT_NORMAL, 558, 0, ALIGN_LEFT).anchor(0, 0).pos(91, 19).color(56, 52, 52);

            var num = global.user.getGoodsNum(HERB, herbs[i]);
            var co = [8, 61, 20];
            if(num == 0)
                co = [99, 42, 47];
            panel.addlabel(str(num), "fonts/heiti.ttf", 20).anchor(0, 50).pos(63, 52).color(8, 61, 20);
        }
    }
    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
    }
    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var dify = lastPoints[1]-oldPos[1];
        var curPos = flowNode.pos();
        curPos[1] += dify;
        flowNode.pos(curPos);

        accMove += abs(dify);
    }
    function touchEnded(n, e, p, x, y, points)
    {
        var curPos = flowNode.pos();
        var rows = (len(herbs)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
}

class MakeDrugDialog extends MyNode
{
    var selected = null;
    //var cl = null;
    //var flowNode;
    var makeDrugView;
    var herbView;
    var MakeWhat;

    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("haha.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);

        temp = bg.addsprite("forgeTitle.png").anchor(50, 50).pos(163, 45).size(169, 67).color(100, 100, 100, 100);
        if(MakeWhat == MAKE_DRUG)
            temp.texture("drugTitle.png", UPDATE_SIZE);

        but0 = new NewButton("roleNameBut0.png", [111, 42], getStr("forgePage", null), null, 20, FONT_NORMAL, [100, 100, 100], switchView, 0);
        but0.bg.pos(413, 43);
        addChild(but0);
        if(MakeWhat == MAKE_DRUG)
            but0.word.setWords(getStr("drugPage", null));

        but0 = new NewButton("violetBut.png", [113, 42], getStr("allOres", null), null, 20, FONT_NORMAL, [100, 100, 100], switchView, 1);
        but0.bg.pos(533, 43);
        addChild(but0);
        if(MakeWhat == MAKE_DRUG)
            but0.word.setWords(getStr("drugs", null));

        but0 = new NewButton("blueButton.png", [113, 42], getStr("forgeTip", null), null, 20, FONT_NORMAL, [100, 100, 100], onForgeTip, null);
        but0.bg.pos(653, 43);
        addChild(but0);
        if(MakeWhat == MAKE_DRUG)
            but0.word.setWords(getStr("drugTip", null));
    }
    function onForgeTip()
    {
    }
    var views;
    function MakeDrugDialog(k)
    {
        MakeWhat = k;
        initView();
        
        makeDrugView = new MakeDrug(MakeWhat);
        herbView = new Herb(MakeWhat);
        views = [makeDrugView, herbView];
        switchView(0);
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function switchView(p)
    {
        if(selected != p)
        {
            if(selected != null)
                views[selected].removeSelf();
            selected = p;
            addChild(views[selected]);
        }
    }
}
