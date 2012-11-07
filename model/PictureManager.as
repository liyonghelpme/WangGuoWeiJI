class PictureManager
{
    var waitTime = 0;
    var inConnect = 0;
    var curProcess;
    var curKind;
    var allKind = ["m", "fm", "a", "fa"];
    var ALL_SOL_PICTURES = 
[0, 1, 2, 3, 10, 11, 12, 13, 20, 21, 22, 23, 30, 31, 32, 33, 40, 41, 42, 43, 50, 51, 52, 53, 60, 61, 62, 63, 70, 71, 110, 100, 80, 81, 82, 83, 90, 91, 92, 93, 72, 73, 120, 130, 140, 150, 160, 170, 180, 190, 400, 401, 402, 403, 410, 411, 412, 413, 420, 421, 422, 423, 430, 431, 432, 433, 440, 441, 442, 443, 450, 451, 452, 453, 460, 461, 462, 463, 470, 471, 472, 473, 480, 481, 482, 483, 490, 491, 492, 493, 500, 501, 502, 503, 510, 511, 512, 513, 520, 521, 522, 523, 530, 531, 532, 533, 540, 541, 542, 543, 550, 551, 552, 553, 560, 561, 562, 563, 570, 571, 572, 573, 580, 581, 582, 583, 590, 591, 592, 593, 1010, 1020, 1030, 1040, 1050, 1060, 1070, 1080, 1090, 1100, 1110, 1120, 1130, 1140, 1150, 1160, 1170, 1180, 1190, 1200, 1210, 1220, 1230, 1240, 1250, 1260, 1270, 1280, 1290, 1300, 1310, 1320, 1330, 1340, 1350, 1360, 1370, 1380];
    function PictureManager()
    {
        curProcess = global.user.db.get("curProcess");    
        curKind = 0;
        if(curProcess == null)
        {
            curProcess = 0;
            global.user.db.put("curProcess", curProcess);
        }
        global.myAction.addAct(this);
    }
    function update(diff)
    {
        waitTime += diff;
        if(waitTime >= 100 && inConnect == 0)
        {
            waitTime = 0;
            inConnect = 1;
            trace("curProcess", curProcess, curKind);
            if(curProcess < len(ALL_SOL_PICTURES))
            {

                var ret0 = c_res_exist("soldier"+allKind[curKind]+str(ALL_SOL_PICTURES[curProcess])+".plist");
                if(!ret0)
                    request("soldier"+allKind[curKind]+str(ALL_SOL_PICTURES[curProcess])+".plist", 0, null, null);

                var ret1 = c_res_exist("soldier"+allKind[curKind]+str(ALL_SOL_PICTURES[curProcess])+".png");
                if(!ret1)
                    request("soldier"+allKind[curKind]+str(ALL_SOL_PICTURES[curProcess])+".png", 0, onGet, null);
                if(ret0 && ret1)
                    inConnect = 0;
                curKind += 1;
                if(curKind >= len(allKind))
                {
                    curKind = 0;
                    curProcess += 1;
                    global.user.db.put("curProcess", curProcess);
                }
            }
            //curProcess 超过图片数量
            else
            {
                global.myAction.removeAct(this);
            }
        }   
    }
    function onGet(filePath, ret, param)
    {
        inConnect = 0; 
    }
}
