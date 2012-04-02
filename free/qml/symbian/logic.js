var COL_COUNT = 6;
var ROW_COUNT = 8;
var needBang = false
var NULL = -30
var needNext = true;
var isMoved = false;
var splash = false;
var temp = new Array(ROW_COUNT*COL_COUNT)
var index = 0

function move() {
    needNext = true;
    isMoved = false;
    needBang = false;
    index = 0;
    for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
        check(i)
        if(listModel.get(i).t !== 0)
            needNext = false
    }
    pseudoWorker.message(needBang, needNext, isMoved)
}
function touch(id){
    var type = listModel.get(id).t
    if(type >= 3){
        listModel.set(id, {t: 0, upD: id - COL_COUNT, downD: id+ COL_COUNT, leftD: id-1,rightD: id+1})
        needNext = false;
        isMoved = true;
        needBang = true;
        pseudoWorker.message(needBang, needNext, isMoved)
    } else if (type > 0){
        listModel.set(id, {t: type+1})
    }
}
function shaked(){
    needBang = false;
    needNext = false;
    isMoved = true;
    splash = false;
    for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
        if(listModel.get(i).t === 3 && !listModel.get(i).water){
            needBang = true
            splash = true
            listModel.set(i,{t: 0, upD: i - COL_COUNT, downD: i+ COL_COUNT, leftD: i-1,rightD: i+1})
        }
    }
    if(splash)
        shake--
    pseudoWorker.message(needBang, needNext, isMoved)
}
function startLevel(level){
    var rand
    /*for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
        rand=getRandomInt(0,3)
        if(rand === 2){
            listModel.set(i,{t: 0, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
        } else {
            rand=getRandomInt(0,6+(msg.level-(msg.level%2))/2)
            if(rand === 3)
                listModel.set(i,{t: 3, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL, water:true})
            else if(rand === 2 || rand === 1 || rand === 0)
                listModel.set(i,{t: 2, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
            else
                listModel.set(i,{t: 1, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
        }
        //listModel.set(i,{t: 3, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
    }*/
    var big = getBig(level)
    var medium = getMedium(level)
    var space = getSpace(level)
    var water = 2
    for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
        rand=getRandomInt(1,COL_COUNT*ROW_COUNT)
        if(rand <= big){
            listModel.set(i,{t: 3, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL, water:false})
        } else if(rand <= big+medium){
            listModel.set(i,{t: 2, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL, water:false})
        } else if(rand <= big+medium+space){
            listModel.set(i,{t: 0, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL, water:false})
        } else if(rand <= big+medium+space+water){
            listModel.set(i,{t: 3, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL, water:true})
        } else {
            listModel.set(i,{t: 1, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL, water:false})
        }
    }
}

function check(i){
    var upD = listModel.get(i).upD
    var downD = listModel.get(i).downD
    var leftD = listModel.get(i).leftD
    var rightD = listModel.get(i).rightD
    var type

    if(downD !== NULL){
        isMoved = true
        if(downD > -1 && downD < COL_COUNT*ROW_COUNT && !needHide(downD,i)){
            type = listModel.get(downD).t
            if(type === 0 ){
                listModel.set(i,{downD: downD + COL_COUNT})
            } else if(type === 3) {
                if(listModel.get(i).water){
                    if(!listModel.get(downD).water)
                        listModel.set(downD,{t: type-1})
                } else {
                    listModel.set(downD,{t: 0,downD: downD,upD: downD,leftD: downD ,rightD: downD })
                    needBang = true
                    addBang(downD)
                }
                listModel.set(i,{downD: NULL})
            } else {
                if(listModel.get(i).water){
                    if(type !==1)
                        listModel.set(downD,{t: type-1})
                }
                else
                    listModel.set(downD,{t: type+1})
                listModel.set(i,{downD: NULL})
            }
        } else {
            listModel.set(i,{downD: NULL})
        }
    }
    if(upD !== NULL ){
        isMoved = true
        if(upD > -1 && upD < COL_COUNT*ROW_COUNT && !needHide(upD,i)){
            type = listModel.get(upD).t
            if(type === 0){
                listModel.set(i,{upD: upD - COL_COUNT})
            } else if(type === 3 ) {
                if(listModel.get(i).water){
                    if(!listModel.get(upD).water)
                        listModel.set(upD,{t: type-1})
                } else {
                    listModel.set(upD,{t: 0,upD: upD - COL_COUNT,downD: upD + COL_COUNT,
                                  leftD: upD - 1,rightD: upD + 1})
                    needBang = true
                    addBang(upD)
                }
                listModel.set(i,{upD: NULL})
            } else {
                if(listModel.get(i).water){
                    if(type !==1)
                        listModel.set(upD,{t: type-1})
                }
                else
                    listModel.set(upD,{t: type+1})
                listModel.set(i,{upD: NULL})
            }
        } else {
            listModel.set(i,{upD: NULL})
        }
    }
    if(leftD !== NULL ){
        isMoved = true
        if(leftD >  i - i%COL_COUNT - 1 && !needHide(leftD,i)){
            type = listModel.get(leftD).t
            if(type === 0){
                listModel.set(i,{leftD: leftD - 1})
            } else if(type === 3 ) {
                if(listModel.get(i).water){
                    if(!listModel.get(leftD).water)
                        listModel.set(leftD,{t: type-1})
                } else {
                    listModel.set(leftD, {t: 0, upD: leftD - COL_COUNT,downD: leftD + COL_COUNT,
                                  leftD: leftD - 1, rightD: leftD + 1})
                    needBang = true
                    addBang(leftD)
                }
                listModel.set(i,{leftD: NULL})
            } else {
                if(listModel.get(i).water){
                    if(type !==1)
                        listModel.set(leftD,{t: type-1})
                }
                else
                    listModel.set(leftD,{t: type+1})
                listModel.set(i,{leftD: NULL})
            }
        } else {
            listModel.set(i,{leftD: NULL})
        }
    }
    if(rightD !== NULL){
        isMoved = true
        if(rightD < i - i%COL_COUNT + COL_COUNT && !needHide(rightD,i)){
            type = listModel.get(rightD).t
            if(type === 0){
                listModel.set(i,{rightD: rightD + 1})
            } else if(type === 3 ) {
                if(listModel.get(i).water){
                    if(!listModel.get(rightD).water)
                        listModel.set(rightD,{t: type-1})
                } else {
                    listModel.set(rightD, {t: 0,upD: rightD,downD: rightD,leftD: rightD,rightD: rightD})
                    needBang = true
                    addBang(rightD)
                }
                listModel.set(i,{rightD: NULL})
            } else {
                if(listModel.get(i).water){
                    if(type !==1)
                        listModel.set(rightD,{t: type-1})
                }
                else
                    listModel.set(rightD,{t: type+1})
                listModel.set(i,{rightD: NULL})
            }
        } else {
            listModel.set(i,{rightD: NULL})
        }
    }
}

function getRandomInt(min, max){
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function needHide(id, root){
    if(id === root)
        return false
    for(var i = 0; i<index; i++){
        if(temp[i] === id){
            return true;
        }
    }
    return false
}

function addBang(id){
    temp[index] = id
    index++
}

function getBig(level){
    if(level < 2)
        return 6
    else if(level < 4)
        return 5
    else if(level < 6)
        return 4
    else if(level < 8)
        return 3
    else if(level < 10)
        return 2
    else
        return 1
}
function getMedium(level){
    if(level < 14)
       return 18 - level
    else
        return 3
}
function getSpace(level){
    if(level < 14)
        return 7+level;
    else
        return 20;
}
