var db = null
var COUNT = 10

function loadScores(){
    if (db)
        return;
    db = openDatabaseSync("ExplodeThem", "1.0", "ExplodeThem", 1000000);

    if (!db)
        return;
    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS highScores(id INT NOT NULL PRIMARY KEY, name TEXT, score INT)');
    });
}

function setScore(name, score){
    if (!db) {
        console.log("Warning: Database is not open");
        return;
    }
    var rs
    db.transaction(function(tx) {
        rs = tx.executeSql('SELECT * FROM highScores WHERE score = (SELECT MIN(score) FROM highScores) LIMIT 1');
    });

    if(rs.rows.item(0).score < score){
        db.transaction(function(tx) {
            tx.executeSql('UPDATE highScores SET score=?,name=? WHERE id=?', [score, name, rs.rows.item(0).id]);
        });
    }
    updateScoreList()
}

function reset(){
    db.transaction(function(tx) {
        tx.executeSql('DELETE FROM highScores');
    });
    db.transaction(function(tx) {
        for(var i=0; i<10; i++)
            tx.executeSql('INSERT INTO highScores VALUES(?, ?, ?)', [ i+1, '', -1 ]);
    });
    highScoresModel.clear()
    updateScoreList()
}

function updateScoreList(){

    var rs
    db.transaction(function(tx) {
        rs = tx.executeSql('SELECT * FROM highScores ORDER BY score DESC ');
    });

    if(rs.rows.length === 0)
        reset()

    for(var i = 0; i<rs.rows.length;i++) {
        var rec = rs.rows.item(i);
        if(!(rec.score < 0)){
            highScoresModel.set(i, {"name": rec.name, "score":rec.score})
        }
    }
}


