class SettingDialog extends MyNode
{
    var music;
    var button;
    function SettingDialog()
    {
        bg = sprite("dialogSetting.png").pos(global.director.disSize[0]/2, global.director.disSize[1]/2).anchor(50, 50);
        bg.addsprite("roleNameClose.png").pos(564, 36).anchor(50, 50).setevent(EVENT_TOUCH, closeDialog);
        init();
        music = 0;
        button = bg.addsprite("dialogOff.png").pos(397, 136).setevent(EVENT_TOUCH, switchMusic);

    }
    function closeDialog()
    {
        global.director.popView();
    }
    function switchMusic()
    {
        music = 1 - music;
        if(music == 1)
            button.texture("dialogOn.png");
        else
            button.texture("dialogOff.png");
    }
}
