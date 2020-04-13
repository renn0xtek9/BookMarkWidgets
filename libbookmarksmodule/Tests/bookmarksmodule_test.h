#ifndef BOOKMARKSMODULE_TEST_HPP
#define BOOKMARKSMODULE_TEST_HPP
#include <QtTest/QTest>
#include <QtCore/QSharedPointer>
#include <QtCore/QList>
#include <QtCore/QVariant>
#include <QtCore/QDebug>
#include <bookmarkmodel.hpp>

typedef QPair<QString,QList<QVariant>> Subfolder;    // typedef for your type
Q_DECLARE_METATYPE(Subfolder);  
bool operator== (const Subfolder& subfolder1, const Subfolder& subfolder2);

bool CompareTwoTree(QList<QVariant> tree1,QList<QVariant> tree2);


QDebug operator<< (QDebug d, const Subfolder &sb) {
    d <<"Folder "<<sb.first<<" :"<<sb.second;
    return d;
}


class bookmarksmodule_test: public QObject 
{
    Q_OBJECT
public:
    bookmarksmodule_test();
private Q_SLOTS:
    // will be called before the first testfunction is executed.
    void initTestCase();
    // will be called after the last testfunction was executed.
    void cleanupTestCase();
    // will be called before each testfunction is executed.
    void init();
    // will be called after every testfunction.
    void cleanup();
    
    void path_are_set_correctly();
    
    void get_correct_number_of_element_for_konqueror_bookmarks();
    void scan_complete_hierarchy_of_konqueror_model_bookmark();
    
    void get_correct_number_of_element_for_okular_bookmarks();
    
    void get_correct_number_of_element_for_chrome_bookmarks();
    
    
private:   
    
    QSharedPointer<Bookmarkmodel> m_model{};
    QStringList list_all_entries_of_the_model_at_this_hierarchical_level(const QModelIndex& parent_index=QModelIndex{});
    QList<QVariant> m_tree{};
    void get_tree_of_data_model(QModelIndex parent,QList<QVariant>& top_level_of_list);
};

#endif // BOOKMARKSMODULE_TEST_HPP
