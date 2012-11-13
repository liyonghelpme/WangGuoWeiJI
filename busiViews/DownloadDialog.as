class DownloadDialog extends MyNode
{
    function DownloadDialog()
    {
        initView();
    }
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
        temp = bg.addsprite("back.png").anchor(0, 0).pos(150, 93).size(520, 312).color(100, 100, 100, 100);
        temp = bg.addsprite("loginBack.png").anchor(0, 0).pos(169, 137).size(481, 252).color(100, 100, 100, 100);
        temp = bg.addsprite("smallBack.png").anchor(0, 0).pos(201, 65).size(418, 57).color(100, 100, 100, 100);
        temp = bg.addsprite("scoreWhite.png").anchor(0, 0).pos(195, 177).size(384, 176).color(100, 100, 100, 100);
        temp = bg.addsprite("scroll.png").anchor(0, 0).pos(223, 114).size(374, 57).color(100, 100, 100, 100);
        temp = bg.addsprite("soldier444.png").anchor(50, 50).pos(598, 306).size(262, 196).color(100, 100, 100, 100);
        but0 = new NewButton("roleNameBut0.png", [174, 54], getStr("downloadNow", null), null, 27, FONT_NORMAL, [100, 100, 100], onDownloadNow, null);
        but0.bg.pos(299, 403);
        addChild(but0);
        but0 = new NewButton("roleNameBut1.png", [174, 54], getStr("waitDownload", null), null, 27, FONT_NORMAL, [100, 100, 100], closeDialog, null);
        but0.bg.pos(519, 403);
        addChild(but0);
        bg.addlabel(getStr("downFinReward", ["[NUM]", str(getParam("downReward"))]), "fonts/heiti.ttf", 20).anchor(50, 50).pos(410, 147).color(43, 25, 9);
        temp = bg.addlabel(getStr("YouNeedDownload", null), "fonts/heiti.ttf", 18, FONT_NORMAL, 246, 0, ALIGN_LEFT).anchor(0, 0).pos(215, 220).color(28, 15, 4);
        temp = bg.addlabel(getStr("downloadTip", null), "fonts/heiti.ttf", 15, FONT_NORMAL, 255, 0, ALIGN_LEFT).anchor(0, 0).pos(215, 277).color(39, 38, 38);
        bg.addlabel(getStr("newSolPicDownload", null), "fonts/heiti.ttf", 30).anchor(50, 50).pos(423, 95).color(32, 33, 40);
    }
    function onDownloadNow()
    {
        global.pictureManager.startDownload();
        global.msgCenter.sendMsg(BEGIN_DOWNLOAD, null);
        global.director.popView();
    }

    function closeDialog()
    {
        global.director.popView();
    }
}
