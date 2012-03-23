var COL_COUNT = 6;
var ROW_COUNT = 8;
var needBang = false
var NULL = -30
var needNext = true;
var isMoved = false;
var temp = new Array(ROW_COUNT*COL_COUNT)
var index = 0

WorkerScript.onMessage = function(msg) {
    if (msg.action === 'move'){
        needNext = true;
        isMoved = false;
        needBang = false;
        index = 0;
        for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
            check(i,msg.model)
            if(msg.model.get(i).t !== 0)
                needNext = false
        }
        WorkerScript.sendMessage({ 'needBang': needBang, 'needNext': needNext, 'isMoved':isMoved })
    } else if(msg.action === 'touch'){
        var type = msg.model.get(msg.id).t
        if(type === 3){
            msg.model.set(msg.id, {t: 0, upD: msg.id - COL_COUNT, downD: msg.id+ COL_COUNT, leftD: msg.id-1,rightD: msg.id+1})
            WorkerScript.sendMessage({ 'needBang': true, 'needNext': false, 'isMoved': true})
        } else if (type > 0){
            msg.model.set(msg.id, {t: type+1})
            WorkerScript.sendMessage()
        }
    } else if(msg.action === 'splash'){
        needBang = false;
        for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
            if(msg.model.get(i).t === 3){
                needBang = true
                msg.model.set(i,{t: 0, upD: i - COL_COUNT, downD: i+ COL_COUNT, leftD: i-1,rightD: i+1})
            }
        }
        WorkerScript.sendMessage({ 'needBang': needBang, 'needNext': false, 'isMoved': true})
    } else if(msg.action === 'startLevel'){
        var rand
        for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
            rand=getRandomInt(0,3)
            if(rand === 2){
                msg.model.set(i,{t: 0, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
            } else {
                rand=getRandomInt(0,6+(msg.level-(msg.level%2))/2)
                if(rand === 3)
                    msg.model.set(i,{t: 3, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
                else if(rand === 2 || rand === 1 || rand === 0)
                    msg.model.set(i,{t: 2, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
                else
                    msg.model.set(i,{t: 1, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
            }
            //msg.model.set(i,{t: 3, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
        }
    }
    msg.model.sync();
}

function check(i,model){
    var upD = model.get(i).upD
    var downD = model.get(i).downD
    var leftD = model.get(i).leftD
    var rightD = model.get(i).rightD
    var type

    if(downD !== NULL){
        isMoved = true
        if(downD > -1 && downD < COL_COUNT*ROW_COUNT && !needHide(downD,i)){
            type = model.get(downD).t
            if(type === 0 ){
                model.set(i,{downD: downD + COL_COUNT})
            } else if(type === 3) {
                model.set(i,{downD: NULL})
                model.set(downD,{t: 0,downD: downD,upD: downD,leftD: downD ,rightD: downD })
                needBang = true
                addBang(downD)
            } else {
                model.set(downD,{t: type+1})
                model.set(i,{downD: NULL})
            }
        } else {
            model.set(i,{downD: NULL})
        }
    }
    if(upD !== NULL ){
        isMoved = true
        if(upD > -1 && upD < COL_COUNT*ROW_COUNT && !needHide(upD,i)){
            type = model.get(upD).t
            if(type === 0){
                model.set(i,{upD: upD - COL_COUNT})
            } else if(type === 3) {
                model.set(i,{upD: NULL})
                model.set(upD,{t: 0,upD: upD - COL_COUNT,downD: upD + COL_COUNT,
                              leftD: upD - 1,rightD: upD + 1})
                needBang = true
                addBang(upD)
            } else {
                model.set(upD,{t: type+1})
                model.set(i,{upD: NULL})
            }
        } else {
            model.set(i,{upD: NULL})
        }
    }
    if(leftD !== NULL ){
        isMoved = true
        if(leftD >  i - i%COL_COUNT - 1 && !needHide(leftD,i)){
            type = model.get(leftD).t
            if(type === 0){
                model.set(i,{leftD: leftD - 1})
            } else if(type === 3 ) {
                model.set(i,{leftD: NULL})
                model.set(leftD, {t: 0, upD: leftD - COL_COUNT,downD: leftD + COL_COUNT,
                              leftD: leftD - 1, rightD: leftD + 1})
                needBang = true
                addBang(leftD)
            } else {
                model.set(leftD,{t: type+1})
                model.set(i,{leftD: NULL})
            }
        } else {
            model.set(i,{leftD: NULL})
        }
    }
    if(rightD !== NULL){
        isMoved = true
        if(rightD < i - i%COL_COUNT + COL_COUNT && !needHide(rightD,i)){
            type = model.get(rightD).t
            if(type === 0){
                model.set(i,{rightD: rightD + 1})
            } else if(type === 3 ) {
                model.set(i,{rightD: NULL})
                model.set(rightD, {t: 0,upD: rightD,downD: rightD,leftD: rightD,rightD: rightD})
                needBang = true
                addBang(rightD)
            } else {
                model.set(rightD,{t: type+1})
                model.set(i,{rightD: NULL})
            }
        } else {
            model.set(i,{rightD: NULL})
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
