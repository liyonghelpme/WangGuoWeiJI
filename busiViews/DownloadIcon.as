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
        temp = bg.addsprite("downloadBack.png").anchor(0, 0).pos(42, 20).size(117, 37).color(100, 100, 100, 100).setevent(EVENT_TOUCH, onDownload);
        var cl = bg.addnode().size(117, 37).pos(41, 28).clipping(1);
        processBar = cl.addsprite("downloadProcessBar.png").anchor(0, 0).pos(0, 0).size(109, 21).color(100, 100, 100, 100);
        temp = bg.addsprite("downloadIcon.png").anchor(0, 0).pos(12, 10).size(56, 55).color(100, 100, 100, 100);
    }
    function onDownload()
    {
        if(!global.pictureManager.download)
            global.director.pushView(new DownloadDialog(), 1, 0);
    }
    function update(diff)
    {
        var cur = global.pictureManager.curProcess;
        var total = len(global.pictureManager.ALL_SOL_PICTURES);
        var pro = (100-cur*100/total)*TOTAL_LEN/100;
        processBar.pos(-pro, 0);
        if(cur >= total)
        {
            menu.removeDownloadIcon();
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
