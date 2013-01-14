class Controller
{
    var butMusic = null;
    var pickMusic = null;
    //初始化音乐资源
    function Controller()
    {
        var exist = fetch("but.mp3");
        if(exist == null)
        {
            request("but.mp3", 0, finishDownload);
        }
        else 
            finishDownload();
        pickMusic = createsound("pick.mp3");
    }
    function finishDownload()
    {
        butMusic = createsound("but.mp3");
    }
}
