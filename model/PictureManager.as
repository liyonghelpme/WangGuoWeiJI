class PictureManager
{
    var waitTime = 0;
    var inConnect = 0;
    var curProcess;
    //var curKind;
    var allKind = ["m",  "a"];//"fm","fa"
    var needDownload = [];
    var downloadList = [];
    var defaultDownload = 1;
    var callback = null;
    function checkNeedDownload()
    {
        if(curProcess < len(downloadList) && global.user.getValue("level") >= getParam("downloadLevel"))
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
    function startDownload(d, cb)
    {
        trace("startDownload", d, cb);
        if(download)
            return;
        callback = cb;
        defaultDownload = d;//是否默认全部下载 还是 闯关临时下载图片
        //全部图片下载保存进度
        if(!defaultDownload)
            curProcess = 0;
        else
            curProcess = global.user.db.get("curProcess");    

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
                    if(curProcess < len(downloadList))
                    {
                        //move attack feature move feature move
                        for(var i = 0; i < len(allKind); i++)
                        {
                            var name = "soldier"+allKind[i]+str(downloadList[curProcess])+".plist";
                            var ret0 = c_res_exist(name);
                            if(!ret0)
                            {
                                needDownload.append(name);
                            }
                            name = "soldier"+allKind[i]+str(downloadList[curProcess])+".png";
                            var ret1 = c_res_exist(name);
                            if(!ret1)
                            {
                                needDownload.append(name);
                            }
                        }
                        //战斗特效
                        var solAttackEffect = magicAnimate.get(downloadList[curProcess]);

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
                        //变身技能 变身动画
                        var solId = downloadList[curProcess];
                        var sdata = getData(SOLDIER, solId);
                        if(sdata["isHero"] == 1)
                        {
                            var heroId = solId/10*10+4;
                            //当前处理的ID 和 英雄ID 不同
                            //且英雄ID 没有 加入下载队列中
                            if(solId != heroId && downloadList.index(heroId) == -1)
                            {
                                downloadList.append(heroId);
                            }
                        }

                        curProcess++;
                        //默认下载情况下保存下载进度
                        if(defaultDownload)
                            global.user.db.put("curProcess", curProcess);
                    }
                    //curProcess 超过图片数量
                    else
                    {
                        global.myAction.removeAct(this);
                        //下载所有士兵图片任务
                        if(defaultDownload)
                            global.taskModel.doCycleTaskByKey("download", 1);
                        if(callback != null)
                            callback();
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
