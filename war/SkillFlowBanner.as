//skill FlowBanner
//选择技能
//控制技能释放的位置
//如果英雄死亡 则 停止释放
//清空技能列表
class SkillFlowBanner extends MyNode
{
    const INITX = 12;
    const INITY = 403;
    const WIDTH = 565;
    const HEIGHT = 73;
    
    const OFFX = 81;
    const ITEM_NUM = 7;


    //const WIDTH = 103;
    //const HEIGHT = 90;
    //const COL_NUM = 5;
    //const ITEM_NUM = 1;
    const PANEL_WIDTH = 71;
    const PANEL_HEIGHT = 71;
    //const TOTAL_WIDTH = WIDTH*COL_NUM;

    var pausePage;
    var soldier = null;
    //id level coldTime ready
    var skillList = [];
    var cl;
    var flowNode;

    var shadowWord;
    var words;
    //显示 生命值上限 攻击力 防御力 药水
    //药水 数量 
    //drug：data

    //id num coldTime ready
    var drugData;
    //排序药品 
    function cmp(a, b)
    {
        return a[0]-b[0];
        //getData(DRUG, a[0]).get("id") - getData(DRUG, b[0]).get("id");
    }
    //超过skillList 的长度
    //skillList = soldierItems
    //drugData = hereColdTime
    //ShowData

    //id, level, startColdTime, ready
    function initDrug()
    {
        drugData = [];
        var temp = global.user.drugs.items();
        for(var i = 0; i < len(temp); i++)
        {
            var dd = getData(DRUG, temp[i][0]);
            if(temp[i][1] > 0)
            {
                if(dd.get("skillId") != -1)//只显示有技能药水
                {
                    drugData.append([temp[i][0], 0, 0, 1]);//drugId
                }
            }
        }
        bubbleSort(drugData, cmp);
    }
    /*
    选择士兵 显示 士兵的属性值 左上角
    temp = bg.addsprite("mapSel.png").anchor(0, 0).pos(12, 403).size(71, 70).color(100, 100, 100, 100);
    */

    const ARROW_WID = 56;
    const ARROW_HEI = 56;
    var arrow;
    function initView()
    {
        bg = node();
        init();
        cl = bg.addnode().anchor(0, 0).pos(INITX, INITY).size(WIDTH, HEIGHT).color(100, 100, 100, 100);
        flowNode = cl.addnode();

        cl.setevent(EVENT_TOUCH, touchBegan);
        cl.setevent(EVENT_MOVE, touchMoved);
        cl.setevent(EVENT_UNTOUCH, touchEnded);

        arrow = bg.addsprite("mapMenuArr.png").anchor(50, 50).pos(INITX+ARROW_WID/2+OFFX*ITEM_NUM, INITY+ARROW_HEI/2).size(ARROW_WID, ARROW_HEI).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onArr);
    }
    var attributeList = null;
    function SkillFlowBanner(s)
    {
        pausePage = s;
        //bg = node();
        //init();
        initView();
        //cl = bg.addnode().size(TOTAL_WIDTH, 82).pos(9, 384).clipping(1);
        //flowNode = cl.addnode();
        initDrug();
        //setSoldier(null);
        updateSkillPanel(null);
        shadowWord = bg.addsprite("storeBlack.png").pos(10, 323).visible(0);
        words = null;

    }
    var accMove;
    var lastPoints;
    //kind level coldTime ready
   
    //准备好则不显示shadow
    //没有准备好则显示shadow
    //冷却时间不同 全局 由 SkillFlow 控制
    function update(diff)
    {
        if(soldier != null && soldier.state == MAP_SOL_DEAD)//如果士兵死亡
        {
            setSoldier(null);
        }

        if(attributeList != null)
        {
            attributeList.removefromparent();
            attributeList = null;
        }
        if(soldier != null)
        {
            attributeList = stringLines(getStr("solAtt", 
                                        ["[HEAL]", str(soldier.health), 
                                        "[NAME]", soldier.data.get("name"), 
                                        "[BOUNDARY]", str(soldier.healthBoundary),
                                        "[PATTACK]", str(soldier.attack),
                                        "[PDEFENSE]", str(soldier.defense),
                                        "[RANGE]", str(soldier.attRange),
                                        "[SPEED]", str(soldier.attSpeed),
                                        ]), 
                                        18, 20, [0, 0, 0], FONT_NORMAL);
            attributeList.pos(50, 140);
            bg.add(attributeList);
        }

        var panel;
        var pSize;
        var i;
        var pData;
        var ready;
        var shadow;
        var coldTime;
        var sSize;
        var rate;
        var kind;
        for(i = 0; i < len(drugData); i++)
        {
            ready = drugData[i][3];
            if(!ready)
            {
                drugData[i][2] += diff; 
                if(drugData[i][2] >= DRUG_COLD_TIME)
                {
                    drugData[i][2] = 0;
                    drugData[i][3] = 1;
                }
            }
        }
        //遍历所有 面板
        //更新阴影状态
        for(var j = 0; j < len(allPanels); j++)
        {
            panel = allPanels[j];
            pSize = panel.prepare().size();
            pData = panel.get();

            //技能 药品
            kind = pData[0];
            //对应编号
            i = pData[1];
            
            if(kind == SKILL)
                ready = skillList[i][3];
            else 
                ready = drugData[i][3];

            shadow = panel.get(1);
            //ready 删除
            if(ready)
            {
                if(shadow != null)
                {
                    shadow.removefromparent();
                }
                continue;
            }
            else
            {
                if(shadow == null)
                {
                    shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]);
                    panel.add(shadow, 1, 1);//tag = 1
                }
                sSize = panel.prepare().size();//应该是panel的Size
                //技能未冷却
                if(pData[0] == SKILL)
                {
                    var skillId = skillList[i][0];
                    var skTime = skillList[i][2];
                    //拯救技能 升级减少冷却时间
                    //单体攻击 群体攻击 直线攻击
                    //冷却时间是由 士兵timer决定的
                    coldTime = getSkillColdTime(soldier.sid, skillId, skillList[i][1]);
                    rate = max((coldTime-skTime), 0)*100/coldTime;//leftTime
                    //trace("rate", rate, coldTime, skillList[i]);
                }
                //药品未冷却
                else if(pData[0] == DRUG)
                {
                    var passTime = drugData[i][2];
                    rate = max((DRUG_COLD_TIME-passTime), 0)*100/DRUG_COLD_TIME;//leftTime
                }
                shadow.size(sSize[0], sSize[1]*rate/100);
            }
        }

    }
    //停止药品更新状态
    override function enterScene()
    {
        super.enterScene();
        pausePage.scene.sceneSlowTimer.addTimer(this);
    }
    //使用技能tar！=null 施法成功
    //取消技能
    //士兵管理数据 这里 管理view 如果数据没有ready 则显示 shadow
    function finishSkill(tar)
    {
        if(tar != null)
        {
            var kind = selSkill.get()[0]
            var selNum = selSkill.get()[1];
            if(kind == SKILL)
            {
                skillList[selNum][3] = 0;//ready = 0 施法士兵 修改自身状态
                skillList[selNum][2] = 0;//coldTime now
            }
            else if(kind == DRUG)
            {
                drugData[selNum][3] = 0;//ready = 0 施法士兵 修改自身状态
                drugData[selNum][2] = 0;//coldTime now
                global.httpController.addRequest("soldierC/useDrugInRound", dict([["uid", global.user.uid], ["tid", drugData[selNum][0]]]), null, null);
                global.user.changeGoodsNum(DRUG, drugData[selNum][0], -1);
                var num = global.user.getGoodsNum(DRUG, drugData[selNum][0]);
                if(num <= 0)
                    drugData.pop(selNum);
            }
            updateSkillPanel(soldier);
        }
        trace("finishSkill", words);
        clearSelSkill();
    }
    function clearSelSkill()
    {
        shadowWord.visible(0);
        if(words != null)
        {
            words.removefromparent();
            words = null;
        }
        if(selSkill != null)
        {
            selSkill.texture("mapUnSel.png");
            selSkill = null;
        }
    }

    override function exitScene()
    {
        pausePage.scene.sceneSlowTimer.removeTimer(this);
        //global.timer.removeTimer(this);
        super.exitScene();
    }
    var curSel;
    function touchBegan(n, e, p, x, y, points)
    {
        //if(selSkill == null)//没有进入技能释放状态
        //如果进入技能释放状态 如果当前点击到其它技能则切换技能
        {
            curSel = null;
            accMove = 0;
            lastPoints = n.node2world(x, y);

            if(soldier != null && soldier.color == ENECOLOR)
            {
                return;
            }
            var child = checkInChild(flowNode, lastPoints);
            if(child != null)
            {
                var kind = child.get()[0];
                var selNum = child.get()[1];
                var ready;
                if(kind == SKILL)
                    ready = skillList[selNum][3];
                else if(kind == DRUG)
                    ready = drugData[selNum][3];
                if(ready)//技能 药品已经准备完善
                {
                    if(selSkill == child)//新选择如果和当前选择技能一致则取消技能
                    {
                        pausePage.scene.cancelSkill();
                        clearSelSkill();
                    }
                    else//新选择不同于当前技能
                    {
                        if(selSkill != null)//选择其它技能放弃当前技能                         
                            clearSelSkill();
                        child.texture("mapSel.png");
                        curSel = child;
                    }
                }
                else
                {
                    //var coldTime = getSkillColdTime(soldier.sid, skillList[selNum][0]);
                    //trace("skillNotReady", skillList[selNum], coldTime);
                }
            }
        }
    }

    function touchMoved(n, e, p, x, y, points)
    {
        var oldPos = lastPoints;
        lastPoints = n.node2world(x, y);
        var difx = lastPoints[0]-oldPos[0];
        
        var curPos = flowNode.pos();
        curPos[0] += difx;
        flowNode.pos(curPos);

        accMove += abs(difx);
    }

    var selSkill = null;
    //点击背景地图 选择技能
    function touchEnded(n, e, p, x, y, points)
    {
        var newPos = n.node2world(x, y);

        if(curSel != null && accMove >= 10)
        //移动步子太大 取消选择
        {
            curSel.texture("mapUnSel.png");
        }
        if(accMove < 10 && curSel != null)
        //移动步子小确认选择
        {
            selSkill = curSel;
            var kind = curSel.get()[0];
            var selectNum = curSel.get()[1];
            //当前没有选择技能 则选择技能
            var w = "";
            var sdata;
            if(kind == DRUG)
            {
                var dData = getData(DRUG, drugData[selectNum][0]);
                sdata = getData(SKILL, dData["skillId"]);
            }
            else if(kind == SKILL)
            {
                sdata = getData(SKILL, skillList[selectNum][0]); 
            }
            var skillKind = sdata.get("kind");
                
            if(skillKind == MAKEUP_SKILL && soldier.makeUpState)//士兵已经处于变身状态 不能再次变身 清理按钮状态
            {
                clearSelSkill();
                return;
            }

            if(skillKind == SINGLE_ATTACK_SKILL || skillKind == SPIN_SKILL)
            {
                w = getStr("selTarget", null);
            }
            else if(skillKind == MULTI_ATTACK_SKILL)
            {
                w = getStr("selMulti", null);
            }
            else if(skillKind == LINE_SKILL)
            {
                w = getStr("selRow", null);
            }
            else if(skillKind == HEAL_SKILL || skillKind == MULTI_HEAL_SKILL || skillKind == SAVE_SKILL || skillKind == MAKEUP_SKILL )
                w = getStr("selOurSol", null);

            words = shadowWord.addlabel(w, "fonts/heiti.ttf", 25);
            var wSize = words.prepare().size();
            var sSize = shadowWord.prepare().size();
            sSize[0] = max(wSize[0], sSize[0]);
            shadowWord.size(sSize);
            words.anchor(50, 50).pos(sSize[0]/2, sSize[1]/2);
            shadowWord.visible(1);
            
            if(kind == SKILL)
                pausePage.scene.selectSkill(soldier, skillList[selectNum][0], skillList[selectNum][1]);
            //使用药水模拟 技能使用
            else if(kind == DRUG)
                pausePage.scene.selectDrug(soldier, drugData[selectNum][0]);
        }
        
        var curPos = flowNode.pos();
        var cols = (len(allPanels)+ITEM_NUM-1)/ITEM_NUM;
        curPos[0] = min(0, max(-cols*OFFX+WIDTH, curPos[0]));
        flowNode.pos(curPos);
    }
    var arrState = 0;//0展开 1收回
    function onArr()
    {
        arrState = 1-arrState;
        updateSkillPanel(soldier);
    }

    //内部更新所有面板状态函数
    function updateSkillPanel(sol)
    {

        allPanels = [];

        soldier = sol;
        if(soldier == null)
            skillList = [];
        else
            skillList = sol.skillList;//global.user.getSolSkills(soldier.sid).items();//skillId level lastColdTime

        trace("set soldier skillList", skillList);

        var oldPos = flowNode.pos();
        flowNode.removefromparent();
        flowNode = cl.addnode().pos(oldPos); 

        //展开
        if(arrState == 0)
        {
            arrow.scale(-100, 100);
            //arrow.pos(622, 440);
            if((len(skillList)+len(drugData)) < ITEM_NUM)
            {
                arrow.pos(INITX+ARROW_WID/2+(len(skillList)+len(drugData))*OFFX, INITY+ARROW_HEI/2); 
            }
            else
                arrow.pos(INITX+ARROW_WID/2+ITEM_NUM*OFFX, INITY+ARROW_HEI/2);
        }
        else//收起 不显示菜单
        {
            arrow.scale(100, 100);
            //arrow.pos(51, 440);
            arrow.pos(INITX+ARROW_WID/2, INITY+ARROW_HEI/2);
            return;
        }
        //点击技能
        var panel;
        var ready;
        var pSize;
        var shadow;
        var i;
        var id;
        var sca;

        var temp;
        
        for(i = 0; i < len(skillList); i++)
        {
            panel = flowNode.addsprite("mapUnSel.png").pos(i*OFFX, 0);
            allPanels.append(panel);//对应相应技能位置 面板
            id = skillList[i][0];
            
            var skillPic = panel.addsprite(replaceStr(KindsPre[SKILL], ["[ID]", str(id)])).anchor(50, 50).pos(36, 34).color(100, 100, 100, 100);
            sca = getSca(skillPic, [PANEL_WIDTH, PANEL_HEIGHT]);
            skillPic.scale(sca);

            temp = panel.addsprite("skillLevel.png").anchor(0, 0).pos(17, 54).size(52, 13).color(100, 100, 100, 100);
            panel.addlabel(getStr("skillLevel", ["[LEV]", str(skillList[i][1])]), "fonts/heiti.ttf", 13).anchor(50, 50).pos(41, 59).color(100, 100, 100);


            ready = skillList[i][3];

            if(!ready)
            {
                pSize = panel.prepare().size();
                shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]).size(PANEL_WIDTH, PANEL_HEIGHT);
                panel.add(shadow, 1, 1);//tag = 1
            }

            panel.put([SKILL, i]);
            var sData = getData(SKILL, id);
            if(sData["kind"] == MAKEUP_SKILL)
                global.taskModel.showHintArrow(panel, panel.prepare().size(), MAKEUP_BUT);
        }
        //点击药品
        for(i = 0; i < len(drugData); i++)
        {
            panel = flowNode.addsprite("mapUnSel.png").pos((i+len(skillList))*OFFX, 0);
            allPanels.append(panel);//对应相应技能位置 面板

            var drugPic = panel.addsprite(replaceStr(KindsPre[DRUG], ["[ID]", str(drugData[i][0])])).anchor(50, 50).pos(36, 34).color(100, 100, 100, 100);
            sca = getSca(drugPic, [67, 43]);
            drugPic.scale(sca);
            
            temp = panel.addsprite("skillLevel.png").anchor(0, 0).pos(17, 54).size(52, 13).color(100, 100, 100, 100);
            panel.addlabel(str(global.user.getGoodsNum(DRUG, drugData[i][0])), "fonts/heiti.ttf", 13).anchor(50, 50).pos(41, 59).color(100, 100, 100);


            ready = drugData[i][3];
            if(!ready)//技能ID 与众不同
            {
                pSize = panel.prepare().size();
                shadow = sprite("skillShadow.png").anchor(0, 100).pos(0, pSize[1]);
                panel.add(shadow, 1, 1);//tag = 1
            }
            panel.put([DRUG, i]);
        }

    }
    //所有的技能菜单
    //外部调用 设定 当前士兵函数
    var allPanels = [];
    function setSoldier(sol)
    {
        trace("setSoldier");
        if(soldier == sol)
            return;
        if(soldier != null)
        {
            soldier.clearSkillState();
        }
        if(sol != null)
        {
            sol.setSkillState();
        }
        updateSkillPanel(sol); 
        
    }

}
