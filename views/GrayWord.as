/*
非全屏对话框 使用 roleNameClose png
全屏对话框使用close2 png

功能：
    换行
    识别非中文字符---》英文字符


当前打字的位置
中文3个字符

打字频率

需要scene提供打字频率的timer 用于控制
*/
class GrayWord extends MyNode
{
    var lab;
    var word;
    var width;
    var height;
    var siz;
    var paraHei;
    var col;
    var tick;
    var accTick;

    //段落间距
    //\n 分割的段落

    var scene;
    var curPos;//字节位置
    var curWordPos;//字符位置

    var curLine;

    //var totalWord;
    var totalNum;
    var sound;
    
    //音效存在问题 不能 有效播放
    //var player;
    //段落停顿时间
    var callback;
    //var curStep;
    function GrayWord(sc, w, sz, h, c, wid, hei, n, cb, step)
    {
        curLine = step;
        sound = createaudio("print.mp3");
        accTick = 0;
        tick = n;
        curPos = 0;
        curWordPos = 0;
        curLine = 0;

        scene = sc;
        totalNum = 0;
        //totalWord = w;
        word = w.split("\n");
        
        callback = cb;

        siz = sz;
        paraHei = h;
        col = c;
        width = wid;
        height = hei;

        bg = node();
        init();
        //lab = bg.addlabel("", null, siz, FONT_NORMAL, width, height, ALIGN_LEFT).color(col);
        lab = bg.addnode();
    }
    function setWord(w)
    {
        word = w.split("\n");
    }
    override function enterScene()
    {
        super.enterScene();
        global.myAction.addAct(this);
        //player = sound.play(-1, 100, 100, 0, 100);
        //sound.play(-1);
    }
    //更换行 当前行之前采用灰色
    //当前行 白色
    function setCurLine(l)
    {
        if(curLine != l)
        {
            curPos = 0;
            curWordPos = 0;
            curLine = l;
        }
    }
    /*
    ord() <= 128 ascii 字符 > 128 汉字
    len 返回的是字节长度
    substr 确实字符长度
    记录字符位置
    记录当前的字节长度
    []访问的是字节位置


    访问+1 字符
    +1 +3 字节
    */
    //var playing = 0;
    var startPrint = 0;
    function update(diff)
    {
        accTick += 1;
        if(accTick == tick)
        {
            accTick = 0;
            if(curLine < len(word))//当前行小于总行数
            {
                var line = word[curLine];
                while(curPos < len(line) && line[curPos] == " ")//忽略空格
                {
                    curPos++;
                    curWordPos++;
                }
                //打当前行字
                if(curPos < len(line))
                {
                    if(startPrint == 0)
                    {
                        startPrint = 1;
                        sound.play(-1);
                    }
                    var o = ord(line[curPos]);
                    if(o < 128)
                    {
                        curPos += 1;
                    }
                    else
                    {
                        curPos += 3;
                    }
                    curWordPos++;
                    totalNum++;
                    trace("curPos", curPos, curWordPos, totalNum, curLine, len(word), len(line));
                    
                    
                    var showWord;
                    var curSize = [0, 0];//width height 每段开始位置
                    lab.removefromparent();
                    lab = bg.addnode();
                    //之前段落
                    for(var i = 0; i < curLine; i++)
                    {
                        var w1 = lab.addlabel(word[i], null, siz, FONT_NORMAL, width, 0, ALIGN_LEFT).color([80, 80, 80]);
                        var wSize = w1.prepare().size();
                        w1.pos(0, curSize[1]);
                        curSize[0] = max(wSize[0], curSize[0]);
                        curSize[1] += wSize[1]+paraHei;
                    }
                    //当前段落位置
                    showWord = line.substr(0, curWordPos);
                    var w2 = lab.addlabel(showWord, null, siz, FONT_NORMAL, width, 0, ALIGN_LEFT).color(col);
                    w2.pos(0, curSize[1]);

                    //showWord = totalWord.substr(0, totalNum);
                    //lab.removefromparent();
                    //lab = bg.addlabel(showWord, null, siz, FONT_NORMAL, width, height, ALIGN_LEFT).color(col);
                }
                else
                {
                    if(startPrint == 1)
                    {
                        startPrint = 0;
                        sound.stop();
                    }
                    //curPos = 0;
                    //curWordPos = 0;
                    //curLine++; //不换行
                    //totalNum += 2;//换行符号\n
                    //curLine = len(word);
                }
            }
            else//结束弹出场景 压入新的战斗场景
            {
                if(startPrint == 1)
                {
                    startPrint = 0;
                    sound.stop();
                }
                //global.director.popScene();
                //global.director.pushScene();
                //if(callback != null)
                //    callback();
            }
        }
    }
    override function exitScene()
    {
        //player.stop();
        sound.stop();
        //sound.destory();
        //sound.destory();

        global.myAction.removeAct(this);
        super.exitScene();
    }
    function closeDialog()
    {
        global.director.popView();
    }
}
