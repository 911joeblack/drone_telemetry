#include "SwarmApi.h"
#include <iostream>

int main() {
    SwarmApi api;

    // 1. This serves as the UI/Logger
    // We need to subscribe a lambda callback
    api.subscribe([](const DroneTelemetry& t) {
        std::cout << "[Subscriber] Received Drone " << t.drone_id 
                  << " at (" << t.pos_x << ", " << t.pos_y << ", " << t.pos_z 
                  << ") Velocity: " << t.velocity << '\n';
    });

    // 2. This will be our Network Transport
    // Take some raw bytes and publish them
    std::vector<DroneTelemetry> incoming_data = {
        {1, 100, 10.0f, 20.0f, 30.0f, 15.0f},
        {2, 100, -5.0f, 12.0f, 50.0f, 22.1f}
    };

    std::cout << "[Publisher] Sending batch of " << incoming_data.size() << " packets...\n";

    api.publish(incoming_data);

    return 0;
}