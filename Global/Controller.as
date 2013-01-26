class Controller
{
    //初始化音乐资源
    
    const SOUND = 0;
    const MEDIA = 1;
    var names = [["but.mp3", SOUND], ["pick.mp3", SOUND], ["business.mp3", MEDIA], ["fight0.mp3", MEDIA], ["fight1.mp3", MEDIA], ["print0.mp3", SOUND], ["print1.mp3", SOUND]];
    var musics = dict();
    function Controller()
    {
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
        if(musics.get(name) != null)
            return musics.get(name).play(0, 80, 80, 0, 100);
        return null;
    }
    function stopSound(name)
    {
    }
    function playMedia(name)
    {
        if(musics.get(name) != null)
            return musics[name].play(-1);
        return null;
    }
    function pauseMedia(name)
    {
        if(musics.get(name) != null)
            return musics[name].pause();
        return null;
    }

}
