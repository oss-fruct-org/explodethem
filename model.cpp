#include "model.h"
#include <QDebug>

Item::Item(int t, int upD, int downD, int leftD, int rightD)
    : m_t(t), m_upD(upD), m_downD(downD), m_leftD(leftD), m_rightD(rightD)
{
}

int Item::t() const
{
    return m_t;
}
int Item::downD() const
{
    return m_downD;
}
int Item::upD() const
{
    return m_upD;
}
int Item::leftD() const
{
    return m_leftD;
}
int Item::rightD() const
{
    return m_rightD;
}

void Item::setType(int type)
{
    m_t = type;
}

void Item::setDown(int down)
{
    m_downD = down;
}

void Item::setUp(int up)
{
    m_upD = up;
}

void Item::setLeft(int left)
{
    m_leftD = left;
}

void Item::setRight(int right)
{
    m_rightD = right;
}

void Item::set(int t, int upD, int downD, int leftD, int rightD)
{
    m_t=t;
    m_upD = upD;
    m_downD = downD;
    m_leftD = leftD;
    m_rightD = rightD;
}




 MyModel::MyModel(QObject *parent)
     : QAbstractListModel(parent)
 {
     QHash<int, QByteArray> roles;
     roles[TypeRole] = "t";
     roles[DownRole] = "downD";
     roles[RightRole] = "rightD";
     roles[LeftRole] = "leftD";
     roles[UpRole] = "upD";
     setRoleNames(roles);

     for(int i = 0; i <48;i++)
         addItem(Item(0,NONE,NONE,NONE,NONE));
     timer = new QTimer(this);
     connect(timer, SIGNAL(timeout()), this, SLOT(move()));
 }


 void MyModel::startLevel(int level)
 {

     int rand;
     for(int i = 0;i < 48; i++){
         rand=getRandomInt(0,4);
         if(rand == 0){
             m_Items[i].set(0,NONE,NONE,NONE,NONE);
         } else {
             rand=getRandomInt(0,6+level-(level%2));
             if(rand == 3)
                 m_Items[i].set(3,NONE,NONE,NONE,NONE);
             else if(rand == 2 || rand == 1 || rand == 0)
                 m_Items[i].set(2,NONE,NONE,NONE,NONE);
             else
                 m_Items[i].set(1,NONE,NONE,NONE,NONE);
         }
         //m_Items[i].set(3,NONE,NONE,NONE,NONE);
     }
     dataChanged(this->index(0), this->index(rowCount() - 1));
 }

 void MyModel::touch(int id)
 {

     int type = m_Items[id].t();
     if(type == 3){
         m_Items[id].set(0, id-COL_COUNT, id+COL_COUNT,id-1, id+1);
         timer->start(400);
        // WorkerScript.sendMessage({ 'needBang': true, 'needNext': false, 'isMoved': true})
     } else if (type > 0){
         m_Items[id].setType(type+1);
     }
     dataChanged(this->index(id), this->index(id));
 }

 void MyModel::move()
 {
     isMoved = false;
     for(int i = 0;i < 48; i++)
         check(i);
     if(!isMoved)
         timer->stop();

 }


 int MyModel::getRandomInt(int min, int max)
 {
     //qsrand((uint)t_time.msec());
     return qrand() % ((max + 1) - min) + min;
 }

 void MyModel::addItem(const Item &item)
 {
     beginInsertRows(QModelIndex(), rowCount(), rowCount());
     m_Items << item;
     endInsertRows();
 }

 void MyModel::check(int i)
 {
     int upD =  m_Items[i].upD();
     int downD =  m_Items[i].downD();
     int leftD =  m_Items[i].leftD();
     int rightD =  m_Items[i].rightD();

     if(downD != NONE){
         isMoved = true;
         if(downD > -1 && downD < COL_COUNT*ROW_COUNT /*&& !needHide(downD,i)*/){
             if(m_Items[downD].t() > 0 && m_Items[downD].t() < 3 ){
                 m_Items[downD].setType(m_Items[downD].t()+1);
                 m_Items[i].setDown(NONE);
                 dataChanged(this->index(i), this->index(i));
                 dataChanged(this->index(downD), this->index(downD));
             } else if(m_Items[downD].t() == 3) {
                 m_Items[i].setDown(NONE);
                 m_Items[downD].set(0,downD,downD,downD,downD);
                 needBang = true;
                 dataChanged(this->index(i), this->index(i));
                 dataChanged(this->index(downD), this->index(downD));
                 //addBang(downD);
             } else {
                 m_Items[i].setDown(downD + COL_COUNT);
                 dataChanged(this->index(i), this->index(i));
             }
         } else {
             m_Items[i].setDown(NONE);
             dataChanged(this->index(i), this->index(i));
         }
     }
     if(upD != NONE ){
         isMoved = true;
         if(upD > -1 && upD < COL_COUNT*ROW_COUNT /*&& !needHide(upD,i)*/){
             if(m_Items[upD].t() > 0 && m_Items[upD].t() < 3 ){
                 m_Items[upD].setType(m_Items[upD].t()+1);
                 m_Items[i].setUp(NONE);
                 dataChanged(this->index(i), this->index(i));
                 dataChanged(this->index(upD), this->index(upD));
             } else if(m_Items[upD].t() == 3){
                 m_Items[i].setUp(NONE);
                 m_Items[upD].set(0, upD-COL_COUNT, upD+COL_COUNT, upD-1, upD+1);
                 needBang = true;
                 dataChanged(this->index(i), this->index(i));
                 dataChanged(this->index(upD), this->index(upD));
                 //addBang(upD);
             }
             else{
                 m_Items[i].setUp(upD - COL_COUNT);
                dataChanged(this->index(i), this->index(i));
             }
         } else {
            m_Items[i].setUp(NONE);
            dataChanged(this->index(i), this->index(i));
         }

     }
     if(leftD != NONE ){
         isMoved = true;
         if(leftD >  i - i%COL_COUNT - 1 /*&& !needHide(leftD,i)*/){
             if(m_Items[leftD].t() > 0 && m_Items[leftD].t() < 3 ){
                 m_Items[leftD].setType(m_Items[leftD].t()+1);
                 m_Items[i].setLeft(NONE);
                 dataChanged(this->index(i), this->index(i));
                 dataChanged(this->index(leftD), this->index(leftD));
             } else if(m_Items[leftD].t() == 3){
                 m_Items[i].setLeft(NONE);
                 m_Items[leftD].set(0, leftD-COL_COUNT, leftD+COL_COUNT, leftD-1, leftD+1);
                 needBang = true;
                 dataChanged(this->index(i), this->index(i));
                 dataChanged(this->index(leftD), this->index(leftD));
                 //addBang(leftD);
             }
             else{
                 m_Items[i].setLeft(leftD-1);
                dataChanged(this->index(i), this->index(i));
             }
         } else {
            m_Items[i].setLeft(NONE);
            dataChanged(this->index(i), this->index(i));
         }
     }
     if(rightD != NONE){
         isMoved = true;
         if(rightD < i - i%COL_COUNT + COL_COUNT /*&& !needHide(rightD,i)*/){
             if(m_Items[rightD].t() > 0 && m_Items[rightD].t() < 3 ){
                 m_Items[rightD].setType(m_Items[rightD].t()+1);
                 m_Items[i].setRight(NONE);
                 dataChanged(this->index(rightD), this->index(rightD));
                 dataChanged(this->index(i), this->index(i));
             } else if(m_Items[rightD].t() == 3) {
                 m_Items[i].setRight(NONE);
                 m_Items[rightD].set(0,rightD,rightD,rightD,rightD);
                 needBang = true;
                 //addBang(downD);
                 dataChanged(this->index(rightD), this->index(rightD));
                 dataChanged(this->index(i), this->index(i));
             } else {
                 m_Items[i].setRight(rightD + 1);
                dataChanged(this->index(i), this->index(i));
             }
         } else {
             m_Items[i].setRight(NONE);
             dataChanged(this->index(i), this->index(i));
         }
     }
 }

 int MyModel::rowCount(const QModelIndex & parent) const {
     return m_Items.count();
 }

 QVariant MyModel::data(const QModelIndex & index, int role) const {
     if (index.row() < 0 || index.row() > m_Items.count())
         return QVariant();

     const Item &item = m_Items[index.row()];
     if (role == TypeRole)
         return item.t();
     else if (role == DownRole)
         return item.downD();
     else if (role == UpRole)
         return item.upD();
     else if (role == LeftRole)
         return item.leftD();
     else if (role == RightRole)
         return item.rightD();
     return QVariant();
 }
