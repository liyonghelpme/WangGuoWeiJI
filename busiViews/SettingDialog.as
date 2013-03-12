class SettingDialog extends MyNode
{
    var music;
    var button;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
temp = bg.addsprite("back.png", ARGB_8888).anchor(0, 0).pos(150, 93).size(520, 312).color(100, 100, 100, 100);
temp = bg.addsprite("loginBack.png", ARGB_8888).anchor(0, 0).pos(169, 137).size(481, 252).color(100, 100, 100, 100);
temp = bg.addsprite("smallBack.png", ARGB_8888).anchor(0, 0).pos(201, 65).size(418, 57).color(100, 100, 100, 100);
        
        but0 = new NewButton("closeBut.png", [40, 39], getStr("", null), null, 18, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(665, 97);
        addChild(but0);

temp = bg.addsprite("settingDown.png", ARGB_8888).anchor(0, 0).pos(177, 276).size(464, 96).color(100, 100, 100, 100);
temp = bg.addsprite("settingUp.png", ARGB_8888).anchor(0, 0).pos(177, 178).size(464, 62).color(100, 100, 100, 100);
bg.addlabel(getStr("emailAddress", null), getFont(), 18).anchor(0, 50).pos(332, 345).color(37, 38, 39);
bg.addlabel(getStr("caesarGameStudio", null), getFont(), 22).anchor(0, 50).pos(331, 313).color(43, 25, 9);
temp = bg.addsprite("workshopLogo.png", ARGB_8888).anchor(0, 0).pos(188, 285).size(126, 79).color(100, 100, 100, 100);
bg.addlabel(getStr("soundAndMusic", null), getFont(), 22).anchor(0, 50).pos(190, 210).color(43, 25, 9);
bg.addlabel(getStr("developer", null), getFont(), 18).anchor(0, 50).pos(184, 259).color(66, 46, 28);
bg.addlabel(getStr("sound", null), getFont(), 18).anchor(0, 50).pos(183, 160).color(66, 46, 28);

button = bg.addsprite("onButton.png", ARGB_8888).anchor(0, 0).pos(511, 189).size(108, 41).color(100, 100, 100, 100).setevent(EVENT_TOUCH, switchMusic);
bg.addlabel(getStr("systemSetting", null), getFont(), 30).anchor(50, 50).pos(421, 91).color(32, 33, 40);
        updateMusic();
    }
    function SettingDialog()
    {
        music = global.user.getMusic();
        initView();
    }
    function closeDialog()
    {
        global.director.popView();
    }
    function updateMusic()
    {
        music = global.user.getMusic();
        if(music == 0)
            button.texture("onButton.png");
        else
            button.texture("offButton.png");
    }
    function switchMusic()
    {
        global.user.switchMusic();
        updateMusic();
        //获取当前所有活跃的音效 和 音乐 然后关闭
        global.msgCenter.sendMsg(SWITCH_MUSIC, null);
    }
}
