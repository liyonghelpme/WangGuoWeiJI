class DrugDialog extends MyNode
{
    var soldier;
    var healthText;
    var attText;
    var defText;
    var im;
    var nameText;
    var cl;
    var flowNode;
    const OFFY = 72;
    const ROW_NUM = 5;
    const HEIGHT = OFFY*ROW_NUM;
    const ITEM_NUM = 1;
    var kind;

    //kind EQUIP 
    //kind DRUG
    var data;

    /*
    用户当前拥有的药品
    用户当前拥有的装备
    士兵当前拥有的装备
    */
    const FREE_EQUIP = 0;
    const USE_EQUIP = 1;
    function initData()
    {
        var key;
        var i;
        data = [];
        if(kind == DRUG)
        {
            key = global.user.drugs.keys();
            for(i = 0; i < len(key); i++)
                data.append([FREE_EQUIP, key[i]]);
        }
        else if(kind == EQUIP)
        {
            //没有使用的装备
            //被某个士兵使用的装备
            //tid kind ownerid
            key = global.user.soldierEquip.items();
            var myThing = [];
            var otherThing = [];
            for(i = 0; i < len(key); i++)
            {
                if(key[i][1][1] == soldier.sid)
                    myThing.append([USE_EQUIP, key[i][0]]);
                else
                    otherThing.append([USE_EQUIP, key[i][0]]);
            }
            data = myThing+otherThing; 

            key = global.user.equips.keys();
            for(i = 0; i < len(key); i++)
            {
                data.append([FREE_EQUIP, key[i]]);
            }
        }

        //id number 
        //列表的count不会改变 只会改变数量 和排序
    }
    function DrugDialog(s, k)
    {
        kind = k;
        soldier = s;
        bg = sprite("dialogFriend.png");
        init();
        initData();
        im = bg.addsprite("soldier"+str(soldier.id)+".png").pos(98, 40).anchor(50, 50).size(71, 67);
        nameText = bg.addlabel(soldier.myName, null, 24).pos(160, 44).anchor(0, 50).color(0, 0, 0);



        var banner = bg.addsprite("dialogDrugInfo.png").pos(275, 28);

        healthText = bg.addlabel("1000", null, 24).pos(321, 44).anchor(0, 50).color(100, 100, 100);
        attText = bg.addlabel("1000", null, 24).pos(474, 44).anchor(0, 50).color(100, 100, 100);
        defText = bg.addlabel("1000", null, 24).pos(623, 44).anchor(0, 50).color(100, 100, 100);

        bg.addsprite("close2.png").pos(765, 27).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);

        cl = bg.addnode().pos(46, 90).size(703, 357).clipping(1);
        flowNode = cl.addnode();

        updateTab();
        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);
    }

    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(data);
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    function updateTab()
    {
        trace("init Drug Dialog View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var rg = getRange();
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addsprite("dialogMakeDrugBanner.png").pos(0, OFFY*i);
            var id;
            var ifUse = 0;
            var useData;
            if(data[i][0] == USE_EQUIP)
                ifUse = 1;
            if(ifUse == 0)
                id = data[i][1];
            else
            {
                useData = global.user.getUseThing(kind, data[i][1]);
                id = useData[0];
            }


            var obj = panel.addsprite(replaceStr(KindsPre[kind], ["[ID]", str(id)])).pos(60, 35).anchor(50, 50);
            var bsize = obj.prepare().size();
            var sca = min(64*100/bsize[0], 60*100/bsize[1]);
            obj.scale(sca, sca);

            var objData = getData(kind, id);
            //panel.addlabel(objData.get("name"), null, 15).anchor(50, 50).pos(60, 52).color(0, 0, 0);
            var num;
            if(ifUse == 0)
                num = global.user.getThingNum(kind, id);
            else
                num = 1;

            trace("herbNum", num, objData);
            var co = [14, 64, 26];
            if(num == 0)
                co = [99, 42, 47];
            if(ifUse == 0)
                panel.addlabel(str(num), null, 15).pos(86, 37).anchor(0, 50).color(co[0], co[1], co[2]);
            else
            {
                var solName = global.user.getSoldierData(useData[1]).get("name");
                panel.addlabel(solName, null, 15).pos(86, 37).anchor(0, 50).color(co[0], co[1], co[2]);
            }
                
            panel.addlabel("desc", null, 20, FONT_NORMAL, 514, 41, ALIGN_LEFT).pos(133, 18).color(59, 56, 56);
            trace("initHerb", num);
            var but0 = panel.addsprite("roleNameBut0.png").pos(611, 34).size(126, 37).anchor(50, 50);
            var words = getStr("useIt", null);
            if(num == 0)
            {
                words = getStr("buyIt", null); 
                but0.addlabel(words, null , 30).pos(63, 18).anchor(50, 50);
                but0.setevent(EVENT_TOUCH, buyIt, data[i][1]);
            }
            else
            {
                if(ifUse == 0)
                {
                    but0.addlabel(words, null , 30).pos(63, 18).anchor(50, 50);
                    but0.setevent(EVENT_TOUCH, useIt, data[i][1]);
                }
                else
                {
                    words = getStr("unloadIt", null);
                    but0.addlabel(words, null , 30).pos(63, 18).anchor(50, 50);
                    but0.setevent(EVENT_TOUCH, unloadIt, data[i][1]);
                }
            }

        }
    }
    //tid [id sid]
    function unloadIt(n, e, p, x, y, points)
    {
        trace("unloadIt", p);
        global.user.unloadThing(p);
        initData();
        updateTab();
        //var useData = global.user.getUseThing(kind, p);//
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
        var rows = (len(data)+ITEM_NUM-1)/ITEM_NUM;
        curPos[1] = min(0, max(-rows*OFFY+HEIGHT, curPos[1]));
        flowNode.pos(curPos);
        updateTab();
    }
    function closeDialog()
    {
        global.director.popView();
    }

    function buyIt(n, e, p, x, y, points)
    {
        global.director.popView();
        var store = new Store(global.director.curScene);
        global.director.pushView(store,  1, 0);
        if(kind == DRUG)
            store.changeTab(store.DRUG_PAGE);
        else if(kind == EQUIP)
            store.changeTab(store.EQUIP_PAGE);
    }

    function useIt(n, e, p, x, y, points)
    {
        trace("useIt", p);
        global.user.useThing(kind, p, soldier);
        initData();
        updateTab();
    }
        

    override function enterScene()
    {
        super.enterScene();
        global.user.addSoldierListener(this);
        updateSoldier(soldier);
        global.user.addListener(this);
        updateValue(global.user.resource);
    }
    override function exitScene()
    {
        global.user.removeListener(this);
        global.user.removeSoldierListener(this);
        super.exitScene();
    }
    function updateValue(res)
    {
    
    }
    function updateSoldier(sol)
    {
        if(sol.sid == soldier.sid)
        {
            im.texture("soldier"+str(soldier.id)+".png");
            nameText.text(soldier.myName);
            healthText.text(str(soldier.health)+"/"+str(soldier.healthBoundary));
            attText.text(str(soldier.attack));
            defText.text(str(soldier.defense));
        }
    }
}
