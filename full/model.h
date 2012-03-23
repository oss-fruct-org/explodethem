#ifndef MODEL_H
#define MODEL_H
#include <QAbstractListModel>
 #include <QStringList>
#include <QTimer>

#define NONE -30
#define COL_COUNT 6
#define ROW_COUNT 8

 class Item
 {
 public:
     Item(int t,int upD,int downD,int leftD,int rightD);

     int t() const;
     int upD() const;
     int leftD() const;
     int downD() const;
     int rightD() const;

     void setType(int type);
     void setDown(int down);
     void setUp(int up);
     void setLeft(int left);
     void setRight(int right);

     void set(int t,int upD,int downD,int leftD,int rightD);

 private:
     int m_t;
     int m_upD;
     int m_downD;
     int m_leftD;
     int m_rightD;
 };

 class MyModel : public QAbstractListModel
 {
     Q_OBJECT
 public:
     enum GameRoles {
         TypeRole = Qt::UserRole + 1,
         DownRole,
         UpRole,
         LeftRole,
         RightRole
     };
     MyModel(QObject *parent = 0);
     Q_INVOKABLE void startLevel(int level);
     Q_INVOKABLE void touch(int id);
     int getRandomInt(int min, int max);
     void addItem(const Item &item);
     void check(int i);
     bool isMoved;
     bool needBang;

     int rowCount(const QModelIndex & parent = QModelIndex()) const;

     QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
public slots:
     void move();

 private:
     QList<Item> m_Items;
     QTimer *timer;
 };
#endif // MODEL_H
