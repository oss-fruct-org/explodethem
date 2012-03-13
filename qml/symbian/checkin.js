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
        }
    } else if(msg.action === 'startLevel'){
        var rand
        for(var i = 0;i < COL_COUNT*ROW_COUNT; i++){
            rand=getRandomInt(0,4)
            if(rand === 0){
                msg.model.set(i,{t: 0, upD:NULL, downD:NULL, rightD:NULL,leftD:NULL})
            } else {
                rand=getRandomInt(0,6+msg.level-(msg.level%2))
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

    if(downD !== NULL){
        isMoved = true
        if(downD > -1 && downD < COL_COUNT*ROW_COUNT && !needHide(downD,i)){
            if(model.get(downD).t > 0 && model.get(downD).t < 3 ){
                model.set(downD,{t: model.get(downD).t+1})
                model.set(i,{downD: NULL})
            } else if(model.get(downD).t === 3) {
                model.set(i,{downD: NULL})
                model.set(downD,{t: 0,downD: downD,upD: downD,leftD: downD ,rightD: downD })
                needBang = true
                addBang(downD)
            }
            else
                model.set(i,{downD: downD + COL_COUNT})
        } else {
            model.set(i,{downD: NULL})
        }
    }
    if(upD !== NULL ){
        isMoved = true
        if(upD > -1 && upD < COL_COUNT*ROW_COUNT && !needHide(upD,i)){
            if(model.get(upD).t > 0 && model.get(upD).t < 3 ){
                model.set(model.get(i).upD,{t: model.get(upD).t+1})
                model.set(i,{upD: NULL})
            } else if(model.get(model.get(i).upD).t === 3) {
                model.set(i,{upD: NULL})
                model.set(upD,{t: 0,upD: upD - COL_COUNT,downD: upD + COL_COUNT,
                              leftD: upD - 1,rightD: upD + 1})
                needBang = true
                addBang(upD)
            }
            else
                model.set(i,{upD: upD - COL_COUNT})
        } else {
            model.set(i,{upD: NULL})
        }
    }
    if(leftD !== NULL ){
        isMoved = true
        if(leftD >  i - i%COL_COUNT - 1 && !needHide(leftD,i)){
            if(model.get(leftD).t > 0 && model.get(leftD).t < 3 ){
                model.set(leftD,{t: model.get(leftD).t+1})
                model.set(i,{leftD: NULL})
            } else if(model.get(leftD).t === 3 ) {
                model.set(i,{leftD: NULL})
                model.set(leftD, {t: 0, upD: leftD - COL_COUNT,downD: leftD + COL_COUNT,
                              leftD: leftD - 1, rightD: leftD + 1})
                needBang = true
                addBang(leftD)
            }
            else
                model.set(i,{leftD: leftD - 1})
        } else {
            model.set(i,{leftD: NULL})
        }
    }
    if(rightD !== NULL){
        isMoved = true
        if(rightD < i - i%COL_COUNT + COL_COUNT && !needHide(rightD,i)){
            if(model.get(rightD).t > 0 && model.get(rightD).t < 3 ){
                model.set(rightD,{t: model.get(rightD).t+1})
                model.set(i,{rightD: NULL})
            } else if(model.get(rightD).t === 3) {
                model.set(i,{rightD: NULL})
                model.set(rightD, {t: 0,upD: rightD,downD: rightD,leftD: rightD,rightD: rightD})
                needBang = true
                addBang(rightD)
            }
            else
                model.set(i,{rightD: rightD + 1})
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
