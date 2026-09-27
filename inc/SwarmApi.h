#pragma once
#include <cstdint>
#include <span>
#include <functional>
#include <memory>

struct DroneTelemetry {
    uint32_t drone_id;
    uint64_t logical_tick;
    float pos_x, pos_y, pos_z;
    float velocity;
};

using TelemetryCallback = std::function<void(const DroneTelemetry&)>;

class SwarmApi {
public:
// This will use the PIMPL idiom 
    SwarmApi();
    ~SwarmApi();

    // Prevent copying for strict ownership of the Impl
    SwarmApi(const SwarmApi&) = delete;
    SwarmApi& operator=(const SwarmApi&) = delete;

    // We can use move semantics, it doesnt copy or assign ownership
    // To more than one thing
    SwarmApi(SwarmApi&&) noexcept;
    SwarmApi& operator=(SwarmApi&&) noexcept;

    // Pub/Sub
    // Register a subscriber callback
    void subscribe(TelemetryCallback callback);

    // Publish telemetry data
    // std::span is similar to std::string_view but for non-string
    // contiguous memory
    void publish(std::span<const DroneTelemetry> packets);

    // temp func
    void testPIMPL();

private:
    // Forward Declaration of the implementation class
    class SwarmApiImpl;

    // PIMPL idiom
    // This will be the only member variable for this class
    // The implementation class will contain the member variables
    std::unique_ptr<SwarmApiImpl> pIMPL;
};