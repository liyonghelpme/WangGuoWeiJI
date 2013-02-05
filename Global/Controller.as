class Controller
{
    //初始化音乐资源
    
    const SOUND = 0;
    const MEDIA = 1;
    var names = [["but.mp3", SOUND], ["pick.mp3", SOUND], ["business.mp3", MEDIA], ["fight0.mp3", MEDIA], ["fight1.mp3", MEDIA], ["print0.mp3", SOUND], ["print1.mp3", SOUND], ["clickSol.mp3", SOUND]];
    var musics = dict();
    function receiveMsg(mp)
    {

        var msgId = mp[0];
        if(msgId == SWITCH_MUSIC)
        {
            var ms = global.user.getMusic();
            var k = curPlayMusic.keys(); 
            trace("switch musics", ms, k);
            for(var i = 0; i < len(k); i++)
            {
                var handler = curPlayMusic.get(k[i]);
                if(handler != null) {
                    if(ms == 0) {
                        handler.play(-1);
                    } else {
                        handler.pause();
                    }
                }
            }
        }
    }
    function Controller()
    {
        //开启音乐----》场景需要注册的背景音乐需要开始播放
        //关闭音乐---》场景注册的背景音乐需要关闭

        //开启音效----》在开启的时候才允许播放
        global.msgCenter.registerCallback(SWITCH_MUSIC, this);
        for(var i = 0; i < len(names); i++)
        {

            if(getParam("debugSound"))
            {
                request(names[i][0], 1, finishDownload, names[i]);
            }
            else
            {
                var exist = fetch(names[i][0]);
                if(exist == null)
                {
                    request(names[i][0], 0, finishDownload, names[i]);
                }
                else
                {
                    finishDownload(null, 1, names[i]);
                }
            }
        }
    }
    function finishDownload(fp, ret, param)
    {
        if(ret)
        {
            if(param[1] == SOUND)
                musics[param[0]] = createsound(param[0]);
            else if(param[1] == MEDIA)
                musics[param[0]] = createaudio(param[0]);
        }
    }
    function playSound(name)
    {
        //关闭返回
        if(global.user.getMusic() == 1)
            return null;
        if(musics.get(name) != null)
            return musics.get(name).play(0, 80, 80, 0, 100);
        return null;
    }
    function stopSound(name)
    {
    }
    var curPlayMusic = dict();
    function playMedia(name)
    {
        var handler = null;
        //关闭返回
        handler = musics[name];
        if(global.user.getMusic() == 0)
        {
            if(musics.get(name) != null)
            {
                musics[name].play(-1);
            }
        }
        curPlayMusic.update(name, handler);
    }
    function pauseMedia(name)
    {
        curPlayMusic.pop(name);
        if(musics.get(name) != null)
            return musics[name].pause();
        return null;
    }

}
