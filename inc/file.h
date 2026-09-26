#include <string>

class dummyClass {
public:
    void printHello();

    dummyClass() 
        : m_str("Hello World\n")
    {}

private:
    std::string m_str;
};