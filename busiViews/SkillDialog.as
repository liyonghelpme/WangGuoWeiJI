class SkillDialog extends MyNode
{
    var cl;
    var flowNode;
    var kind;

    const OFFY = 75;
    const ROW_NUM = 4;
    const ITEM_NUM = 1;
    const WIDTH = 710;
    const HEIGHT = 297;
    const PANEL_WIDTH = 703;
    const PANEL_HEIGHT = 72;
    const INIT_X = 46;
    const INIT_Y = 164;

    //kind EQUIP  eid ---> global.user.equips level, owner, kind 
    //kind DRUG   kindId
    var data;
    //var filterIs = null;

    const EQUIP_KIND = 0;
    const DETAIL_EQUIP = 1;

    /*
    用户当前拥有的药品
    用户当前拥有的装备
    士兵当前拥有的装备
    */
    function cmp(a, b)
    {
        return a[1]-b[1];
    }
    function initData()
    {
        var skillId = heroSkill.get(soldier.id);
        //var skillId = soldier.data.get("skillId");
        data = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
        if(skillId != null)
            data.append(skillId);
    }
    //s 操作士兵对象 k 药品或者 武器 复活药水
    //0 1 2 3 stoneNum
    var nums = [];
    function setStoneNum()
    {
        for(var i = 0; i < 4; i++)
            nums[i].text(str(global.user.getGoodsNum(MAGIC_STONE, i)));
    }
    var soldier;
    var skillText;
    function updateSkillText()
    {
        var curSkillNum = global.user.getCurSkillNum(soldier.sid);
        var maxSkillNum = getMaxSkillNum(getCareer(soldier.id));
        //trace("maxSkillNum", maxSkillNum, curSkillNum, sol.sid, sol.id);
        skillText.text(getStr("moreSkill", ["[NUM]", str(maxSkillNum)]));
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(0, 0).size(800, 480).color(100, 100, 100, 100);
        temp = bg.addsprite("diaBack.png").anchor(0, 0).pos(38, 10).size(705, 64).color(100, 100, 100, 100);
        but0 = new NewButton("closeBut.png", [41, 41], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(772, 27);
        addChild(but0);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(30, 79).size(739, 386).color(100, 100, 100, 100);

        temp = bg.addsprite("skillTitle.png").anchor(50, 50).pos(163, 45).size(167, 61).color(100, 100, 100, 100);
        temp = bg.addsprite("treasureBack.png").anchor(0, 0).pos(278, 25).size(441, 38).color(100, 100, 100, 100);
        temp = bg.addsprite("magicStone3.png").anchor(0, 0).pos(614, 30).size(28, 28).color(100, 100, 100, 100);
        temp = bg.addsprite("magicStone2.png").anchor(0, 0).pos(503, 29).size(30, 30).color(100, 100, 100, 100);
        temp = bg.addsprite("magicStone1.png").anchor(0, 0).pos(391, 29).size(30, 30).color(100, 100, 100, 100);
        temp = bg.addsprite("magicStone0.png").anchor(0, 0).pos(280, 29).size(28, 29).color(100, 100, 100, 100);

        temp = bg.addlabel(getStr("brown", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(316, 43).color(100, 100, 100);
        nums.append(temp);
        temp = bg.addlabel(getStr("yellow", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(427, 43).color(100, 100, 100);
        nums.append(temp);
        temp = bg.addlabel(getStr("green", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(539, 43).color(100, 100, 100);
        nums.append(temp);
        temp = bg.addlabel(getStr("blue", null), "fonts/heiti.ttf", 20).anchor(0, 50).pos(650, 43).color(100, 100, 100);
        nums.append(temp);
        setStoneNum();

        var curSkillNum = global.user.getCurSkillNum(soldier.sid);
        var maxSkillNum = getMaxSkillNum(getCareer(soldier.id));
        temp = bg.addsprite("dialogMakeDrugBanner.png").anchor(0, 0).pos(46, 90).size(703, 71).color(70, 70, 70, 100);
        skillText = bg.addlabel(getStr("moreSkill", ["[NUM]", str(maxSkillNum)]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(400, 125).color(100, 100, 100);
    }
    function SkillDialog(sol)
    {
        soldier = sol;
        initView();
        cl = bg.addnode().pos(INIT_X, INIT_Y).size(WIDTH, HEIGHT).clipping(1);
        flowNode = cl.addnode();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        initData();
        updateTab();
    }

    function getRange()
    {
        var curPos = flowNode.pos();
        var lowRow = -curPos[1]/OFFY;
        var upRow = (-curPos[1]+HEIGHT+OFFY-1)/OFFY;
        var rowNum = len(data);
        return [max(0, lowRow-ROW_NUM), min(rowNum, upRow+ROW_NUM)];
    }
    /*
    药品存储药品的类型ID
    装备存储装备的 eid
    */
    function updateTab()
    {
//        trace("init Drug Dialog View");
        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos);

        var temp;
        var sca;
        var but0;

        var rg = getRange();
        var skills = global.user.getSolSkills(soldier.sid);
        for(var i = rg[0]; i < rg[1]; i++)
        {
            var panel = flowNode.addnode().pos(0, OFFY*i);
            panel.put(i);

            var grayPanel = panel.addsprite("dialogMakeDrugBanner.png");
            var id = data[i];
            
            var level = skills.get(id, -1);
            if(level == -1)
                grayPanel.color(70, 70, 70, 100);

            temp = panel.addsprite(replaceStr(KindsPre[SKILL], ["[ID]", str(id)])).anchor(50, 50).pos(45, 35).color(100, 100, 100, 100);
            sca = getSca(temp, [68, 56]);
            temp.scale(sca);

            var objData = getData(SKILL, id);
            panel.addlabel(objData.get("name") + " " + objData.get("des"), "fonts/heiti.ttf", 18).anchor(0, 50).pos(97, 37).color(56, 52, 52);
            
            if(level == -1)
            {
                var cost = getCost(SKILL, id);
                var its = cost.items()[0];
                but0 = new NewButton("violetBut.png", [113, 35], getStr("costBuy", ["[KIND]", its[0]+".png", "[NUM]", str(its[1])]), null, 18, FONT_NORMAL, [100, 100, 100], onBuyIt, i);
                but0.bg.pos(630, 35);
                panel.add(but0.bg);
            }
            else
            {
                temp = panel.addsprite("skillLevel.png").anchor(0, 0).pos(29, 48).size(60, 14).color(100, 100, 100, 100);
                panel.addlabel(getStr("eqLevel", ["[LEV]", str(level+1)]), "fonts/heiti.ttf", 15).anchor(50, 50).pos(58, 56).color(49, 90, 48);
                if(objData["kind"] == MAKEUP_SKILL)
                {
                    but0 = new NewButton("roleNameBut0.png", [72, 36], getStr("upgrade", null), null, 18, FONT_NORMAL, [100, 100, 100], onUpgrade, i);
                    but0.bg.pos(652, 35);
                    panel.add(but0.bg);
                }
                else
                {
                    but0 = new NewButton("roleNameBut0.png", [72, 36], getStr("upgrade", null), null, 18, FONT_NORMAL, [100, 100, 100], onUpgrade, i);
                    but0.bg.pos(573, 35);
                    panel.add(but0.bg);
                    but0 = new NewButton("blueButton.png", [68, 35], getStr("giveup", null), null, 18, FONT_NORMAL, [100, 100, 100], onGiveup, i);
                    but0.bg.pos(653, 35);
                    panel.add(but0.bg);
                }
            }
        }
                

    }
    //升级装备 参数位置 
    function onUpgrade(p)
    {
        var skillId = data[p];
        global.director.pushView(new UpgradeSkillDialog(this, soldier.sid, skillId), 1, 0);
    }
    //放弃技能
    function onGiveup(p)
    {
        var skillId = data[p];
        global.httpController.addRequest("soldierC/giveupSkill", dict([["uid", global.user.uid], ["soldierId", soldier.sid], ["skillId", skillId]]), null, null);

        global.user.giveupSkill(soldier.sid, skillId);
        //updateTab();
        //updateSkillText();
    }
    var buySkillId;
    //显示购买的资源资源对话框
    //英雄转职剩余技能点
    var buyed = 0;
    function onBuyIt(p)
    {
        var curSkillNum = global.user.getCurSkillNum(soldier.sid);
        var maxSkillNum = getMaxSkillNum(getCareer(soldier.id));
        var leftNum = maxSkillNum-curSkillNum;
        if(leftNum <= 0)//技能点不足
        {
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("heroSkillCountNot", ["[NUM]", str(maxSkillNum)]), [100, 100, 100], null));
            return;
        }
        

        var skillId = data[p];
        buySkillId = skillId;

        var sdata = getData(SKILL, skillId);
        var needLevel = sdata.get("heroLevel");
        if(soldier.level < needLevel)
        {
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("heroLevelNot", ["[LEV]", str(needLevel)]), [100, 100, 100], null));
            return;
        }

        var cost = getCost(SKILL, skillId);
        var buyable = global.user.checkCost(cost);
        if(buyable["ok"] == 0)
        {
            var it = cost.items();
            global.director.curScene.addChild(new ResLackBanner(getStr("resLack", ["[NAME]", getStr(it[0][0], null), "[NUM]", str(it[0][1])]) , [100, 100, 100], BUY_RES[it[0][0]], ObjKind_Page_Map[it[0][0]], this));
            return;
        }
        if(buyed == 0)
        {
            buyed = 1;
            global.director.curScene.dialogController.addBanner(new UpgradeBanner(getStr("clickToBuy", null), [100, 100, 100], null));
            return;
        }
        else
        {
            buyed = 0;
            doBuySkill(cost);
        }


    }
    function doBuySkill(cost)
    {
        global.httpController.addRequest("soldierC/buySkill", dict([["uid", global.user.uid], ["soldierId", soldier.sid], ["skillId", buySkillId]]), null, null);
        global.user.buySkill(soldier.sid, buySkillId);

    }

    var lastPoints;
    var accMove;
    function touchBegan(n, e, p, x, y, points)
    {
        lastPoints = n.node2world(x, y);
        accMove = 0;
        buyed = 0;
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


    //升级装备 降级装备
    function receiveMsg(para)
    {
        var msgId = para[0];
        if(msgId == UPDATE_SKILL)
        {
            updateTab(); 
            updateSkillText();
        }
        else if(msgId == UPDATE_MAGIC_STONE)//变更宝石数量
        {
            setStoneNum(); 
        }
    }
    override function enterScene()
    {
        super.enterScene();
        global.msgCenter.registerCallback(UPDATE_SKILL, this);
        global.msgCenter.registerCallback(UPDATE_MAGIC_STONE, this);
    }
    override function exitScene()
    {
        global.msgCenter.removeCallback(UPDATE_SKILL, this);
        global.msgCenter.removeCallback(UPDATE_MAGIC_STONE, this);
        super.exitScene();
    }
}
