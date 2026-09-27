#include "SwarmApi.h"
#include <iostream>

class SwarmApi::SwarmApiImpl {
// The actual implementation of the functions and 
// All member vars go in here
public:
    SwarmApiImpl() 
        : dummy(10)
    {}

    void subscribe(TelemetryCallback callback) {
        return;
    }

    void publish(std::span<const DroneTelemetry> packets) {
        return;
    }

    void testPIMPL() {
        std::cout << "Testing PIMPL functionality" << dummy << std::endl;
    }
private:
    int32_t dummy;
};

// We must define all our constructors here
SwarmApi::SwarmApi() 
    : pIMPL(std::make_unique<SwarmApiImpl>())
{}

// Move Semantics
SwarmApi::SwarmApi(SwarmApi&&) noexcept = default;
SwarmApi& SwarmApi::operator=(SwarmApi&&) noexcept = default;


// Implement the SwarmApi function's here
// Its calling the impl->SwarmApi

// Pub/Sub
// Register a subscriber callback
void SwarmApi::subscribe(TelemetryCallback callback) {
    pIMPL->SwarmApiImpl::subscribe(callback);
}

// Publish telemetry data
// std::span is similar to std::string_view but for non-string
// contiguous memory
void SwarmApi::publish(std::span<const DroneTelemetry> packets) {
    pIMPL->SwarmApiImpl::publish(packets);
}

// temp func
void SwarmApi::testPIMPL() {
    pIMPL->SwarmApiImpl::testPIMPL();
}

// Destructor goes last
SwarmApi::~SwarmApi() = default;


// void dummyClass::printHello() {
//     std::cout << m_str;
// }