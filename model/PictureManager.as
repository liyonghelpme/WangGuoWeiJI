class PictureManager
{
    var waitTime = 0;
    var inConnect = 0;
    var curProcess;
    //var curKind;
    var allKind = ["m", "fm", "a", "fa"];
    var needDownload = [];
    var ALL_SOL_PICTURES = 
[0, 1, 2, 3, 10, 11, 12, 13, 20, 21, 22, 23, 30, 31, 32, 33, 40, 41, 42, 43, 50, 51, 52, 53, 60, 61, 62, 63, 70, 71, 110, 100, 80, 81, 82, 83, 90, 91, 92, 93, 72, 73, 120, 130, 140, 150, 160, 170, 180, 190, 400, 401, 402, 403, 410, 411, 412, 413, 420, 421, 422, 423, 430, 431, 432, 433, 440, 441, 442, 443, 450, 451, 452, 453, 460, 461, 462, 463, 470, 471, 472, 473, 480, 481, 482, 483, 490, 491, 492, 493, 500, 501, 502, 503, 510, 511, 512, 513, 520, 521, 522, 523, 530, 531, 532, 533, 540, 541, 542, 543, 550, 551, 552, 553, 560, 561, 562, 563, 570, 571, 572, 573, 580, 581, 582, 583, 590, 591, 592, 593, 1010, 1020, 1030, 1040, 1050, 1060, 1070, 1080, 1090, 1100, 1110, 1120, 1130, 1140, 1150, 1160, 1170, 1180, 1190, 1200, 1210, 1220, 1230, 1240, 1250, 1260, 1270, 1280, 1290, 1300, 1310, 1320, 1330, 1340, 1350, 1360, 1370, 1380];
    function checkNeedDownload()
    {
        if(curProcess < len(ALL_SOL_PICTURES) && global.user.getValue("level") >= getParam("downloadLevel"))
        {
            return 1;
        }
        return 0;
    }
    function PictureManager()
    {
        curProcess = global.user.db.get("curProcess");    
        //curKind = 0;
        if(curProcess == null)
        {
            curProcess = 0;
            global.user.db.put("curProcess", curProcess);
        }

    }
    var download = 0;
    function startDownload()
    {
        if(download)
            return;
        download = 1;
        global.myAction.addAct(this);
    }
    function update(diff)
    {
        if(download)
        {
            waitTime += diff;
            if(waitTime >= getParam("downloadTime") && inConnect == 0)
            {
                waitTime = 0;
                //还有下载图 
                if(len(needDownload) > 0)
                {
                    var pic = needDownload.pop(0);
                    inConnect = 1;
                    request(pic, 0, onGet, null);
                }
                //获取新的 下载图
                else
                {
                    trace("curProcess", curProcess);
                    if(curProcess < len(ALL_SOL_PICTURES))
                    {
                        for(var i = 0; i < len(allKind); i++)
                        {
                            var name = "soldier"+allKind[i]+str(ALL_SOL_PICTURES[curProcess])+".plist";
                            var ret0 = c_res_exist(name);
                            if(!ret0)
                            {
                                needDownload.append(name);
                            }
                            name = "soldier"+allKind[i]+str(ALL_SOL_PICTURES[curProcess])+".png";
                            var ret1 = c_res_exist(name);
                            if(!ret1)
                            {
                                needDownload.append(name);
                            }
                        }
                        var solAttackEffect = magicAnimate.get(ALL_SOL_PICTURES[curProcess]);

                        if(solAttackEffect != null)
                        {
                            for(i = 0; i < len(solAttackEffect); i++)
                            {
                                var ani = solAttackEffect[i];
                                if(ani != -1)
                                {
                                    var pics = pureMagicData.get(ani)[0];
                                    if(len(pics) > 0)
                                    {
                                        name = "s"+str(ani)+"e.plist";
                                        ret0 = c_res_exist(name);
                                        if(!ret0)
                                        {
                                            needDownload.append(name);
                                        }
                                        name = "s"+str(ani)+"e.png";
                                        ret1 = c_res_exist(name);
                                        if(!ret1)
                                            needDownload.append(name);
                                    }
                                }
                            }
                        }

                        curProcess++;
                        global.user.db.put("curProcess", curProcess);
                    }
                    //curProcess 超过图片数量
                    else
                    {
                        global.myAction.removeAct(this);
                        global.taskModel.doCycleTaskByKey("download", 1);
                    }
                }
            }
        }
    }
    function onGet(filePath, ret, param)
    {
        inConnect = 0; 
    }
}
