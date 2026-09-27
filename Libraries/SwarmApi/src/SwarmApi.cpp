#include "SwarmApi.h"

class SwarmApi::SwarmApiImpl {
// The actual implementation of the functions and 
// All member vars go in here
public:
    SwarmApiImpl() = default;

    void subscribe(TelemetryCallback callback) {
        callbacks_.push_back(std::move(callback));
    }

    void publish(std::span<const DroneTelemetry> packets) {
        for(const auto& packet : packets) {
            for(const auto& cb : callbacks_) {
                cb(packet);
            }
        }
    }
private:
    // We have a list of 
    std::vector<TelemetryCallback> callbacks_;
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

// Destructor goes last
SwarmApi::~SwarmApi() = default;