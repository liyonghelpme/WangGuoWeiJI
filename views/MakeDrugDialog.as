class MakeDrug extends MyNode
{
    var flowNode;
    var prescriptions;// = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
    const OFFY = 72;
    const ROW_NUM = 5;
    const HEIGHT = OFFY*ROW_NUM;
    const ITEM_NUM = 1;
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
        bg = node().pos(46, 90).size(703, 357).clipping(1);
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
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var data = getData(PRESCRIPTION, prescriptions[i]);
            var kind = data.get("kind");
            var level = data.get("level");
            var id = data.get("tid");
            var panel;
            var needLev = 1;
            if(global.user.getValue("level") >= level)
                panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            else
            {
                needLev = 0;
                panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i).color(55, 54, 51);
            }

            var picName = replaceStr(KindsPre[kind], ["[ID]", str(id)]);
//            trace("picName", picName);
            panel.addsprite(picName).pos(87, 28).anchor(50, 50).size(45, 45);
            var tarData = getData(kind, id);

            panel.addlabel(tarData.get("name"), null, 15).anchor(50, 50).pos(87, 57).color(0, 0, 0);
            panel.addsprite("dialogMakeDrugEqual.png").pos(170, 36).anchor(50, 50);

            var needs = data.get("needs");
            var INITX = 238;
            var INITY = 30;
            var makable = 1;
            for(var j = 0; j < len(needs); j++)
            {
//                trace("show prescription", needs);
                var hid = needs[j][0];
                var hNum = needs[j][1];
                var hData = getData(HERB, hid);

                panel.addsprite("herb"+str(hid)+".png").pos(INITX, INITY).anchor(50, 50).size(46, 44);
                panel.addlabel(hData.get("name"), null, 15).pos(INITX, 57).color(0, 0, 0).anchor(50, 50);
                var ownNum = global.user.getHerb(hid);
                var co = [14, 64, 26];
                if(ownNum < hNum)
                {
                    co = [99, 42, 47];
                    makable = 0;
                }
                if(needLev == 1)
                    panel.addlabel(str(hNum), null, 15).pos(INITX+23, 46).anchor(0, 50).color(co[0], co[1], co[2]);
                if(j != (len(needs)-1))
                {
                    panel.addsprite("dialogMakeDrugPlus.png").pos(INITX+72, 35).anchor(50, 50);
                }
                INITX += 130;
            }
//            trace("prescriptions", needLev, makable);
            var but1;
            if(needLev == 0)
            {
                var words = colorWords(getStr("needLev",  ["[LEV]", str(level)]));
//                trace("needLev words", words);
                panel.addlabel(words[0], null, 25).pos(555, 33).anchor(0, 50).color(97, 3, 3);
                panel.addlabel(words[1], null, 25).pos(555+words[2]*25, 33).color(13, 78, 13).anchor(0, 50);
            }
            else if(makable == 0)
            {
                but1 = panel.addsprite("roleNameBut0.png").pos(618, 33).anchor(50, 50).size(129, 37);
                if(MakeWhat == MAKE_DRUG)
                    but1.addlabel(getStr("herbNot", null), null, 25).anchor(50, 50).pos(64, 18).color(97, 3, 3);
                else if(MakeWhat == MAKE_EQUIP) 
                    but1.addlabel(getStr("oreNot", null), null, 25).anchor(50, 50).pos(64, 18).color(97, 3, 3);
            }
            else
            {
                but1 = panel.addsprite("roleNameBut0.png").pos(618, 33).anchor(50, 50).size(129, 37).setevent(EVENT_TOUCH, makeDrug, prescriptions[i]);
                if(MakeWhat == MAKE_DRUG)
                    but1.addlabel(getStr("makeDrug", null), null, 25).anchor(50, 50).pos(64, 18).color(100, 100, 100);
                else if(MakeWhat == MAKE_EQUIP) 
                    but1.addlabel(getStr("makeEquip", null), null, 25).anchor(50, 50).pos(64, 18).color(100, 100, 100);
            }
//            trace("finish Init MakeDrug");

        }
    }
    /*
    配方ID---> 对应的配方数据
    */
    function makeDrug(n, e, p, x, y, points)
    {

        var pre = getData(PRESCRIPTION, p);
        
        var needs = pre.get("needs");
        var kind = pre.get("kind");
        var tid = pre.get("tid");
        //消耗药材和矿石
        for(var i = 0; i < len(needs); i++)
        {
            global.user.changeHerb(needs[i][0], -needs[i][1]); 
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

        updateTab();
    }
}
class Herb extends MyNode
{
    var herbs;// = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
    var flowNode;
    const OFFY = 72;
    const ROW_NUM = 5;
    const HEIGHT = OFFY*ROW_NUM;
    const ITEM_NUM = 1;
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
        bg = node().pos(46, 90).size(703, 357).clipping(1);
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
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            panel.addsprite("herb"+str(herbs[i])+".png").pos(60, 26).anchor(50, 50).size(54, 40);
            var data = getData(HERB, herbs[i]);
            panel.addlabel(data.get("name"), null, 15).anchor(50, 50).pos(60, 52).color(0, 0, 0);
            var num = global.user.getHerb(herbs[i]);
//            trace("herbNum", num, data);
            var co = [14, 64, 26];
            if(num == 0)
                co = [99, 42, 47];
            panel.addlabel(str(num), null, 15).pos(86, 37).anchor(0, 50).color(co[0], co[1], co[2]);
            panel.addlabel(data.get("des"), null, 20, FONT_NORMAL, 514, 41, ALIGN_LEFT).pos(133, 18).color(59, 56, 56);
//            trace("initHerb", num);
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
    function MakeDrugDialog(k)
    {
        MakeWhat = k;
        bg = sprite("dialogFriend.png");
        init();
        bg.addsprite("dialogMakeDrug.png").pos(150, 40).anchor(50, 50);
        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        var but0 = bg.addsprite("roleNameBut0.png").pos(400, 23).size(126, 40).setevent(EVENT_TOUCH, switchView, 0);
        but0.addlabel(getStr("makeDrugPage", null), null, 22).anchor(50, 50).pos(63, 20);

        but0 = bg.addsprite("roleNameBut0.png").pos(560, 23).size(126, 40).setevent(EVENT_TOUCH, switchView, 1);
        if(MakeWhat == MAKE_DRUG)
            but0.addlabel(getStr("drugs", null), null, 22).anchor(50, 50).pos(63, 20);
        else if(MakeWhat == MAKE_EQUIP)
            but0.addlabel(getStr("allOres", null), null, 22).anchor(50, 50).pos(63, 20);
        //cl = bg.addnode().pos(46, 90).size(703, 357).clipping(1);
        //flowNode = cl.addnode();
        
        makeDrugView = null;
        herbView = null;

        switchView(null, null, 0, null, null, null);
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function switchView(n, e, p, x, y, points)
    {
        if(selected != p)
        {
            if(selected == 0)
                makeDrugView.removeSelf();
            else if(selected == 1)
                herbView.removeSelf();
            selected = p;
            if(p == 0)
            {
                if(makeDrugView == null)
                    makeDrugView = new MakeDrug(MakeWhat);
                addChild(makeDrugView);
            }
            else if(p == 1)
            {
                if(herbView == null)
                    herbView = new Herb(MakeWhat);
                addChild(herbView);
            }
        }
//        trace("finish SwitchView", selected);
    }
}
