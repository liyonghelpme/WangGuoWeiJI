class DownloadIcon extends MyNode
{
    var menu;
    var processBar;
    function DownloadIcon(m)
    {
        menu = m;
        initView();
    }
    const TOTAL_LEN = 109;
    const PRO_HEI = 21;
    function initView()
    {
        bg = node();
        init();
        var but0;
        var line;
        var temp;
        var sca;
temp = bg.addsprite("downloadBack.png", ARGB_8888).anchor(0, 0).pos(42, 20).size(117, 37).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onDownload);
        var cl = bg.addnode().size(117, 37).pos(41, 28).clipping(1);
processBar = cl.addsprite("downloadProcessBar.png", ARGB_8888).anchor(0, 0).pos(0, 0).size(109, 21).color(100, 100, 100, 100);
temp = bg.addsprite("downloadIcon.png", ARGB_8888).anchor(0, 0).pos(12, 10).size(56, 55).color(100, 100, 100, 100);
        this.update(0);//立即更新进度
    }
    function onDownload()
    {
        if(!global.pictureManager.download)
            global.director.pushView(new DownloadDialog(), 1, 0);
    }
    function update(diff)
    {
        var curProgress = global.pictureManager.getCurProgress();
        var pro = (100-curProgress)*(TOTAL_LEN+getParam("progressBarBaseOff"))/100+getParam("progressBarBaseOff");
        processBar.pos(-pro, 0);
        if(getParam("debugDownload"))
            trace("downloading ", curProgress, pro, processBar.pos());
        if(curProgress >= 100)
        {
            //menu.removeDownloadIcon();
            removeSelf();
            //没有下载过图片则奖励
            if(global.user.getValue("downloadYet") == 0)
            {
                var gain = dict([["gold", getParam("downloadGold")]]);
                global.httpController.addRequest("downloadFinish", dict([["uid", global.user.getValue("uid")], ["gain", json_dumps(gain)]]), null, null);
                global.user.doAdd(gain);
                global.user.setValue("downloadYet", 1);
                trace("downloadYet", gain);
            }
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
    function closeDialog()
    {
        global.director.popView();
    }
}
