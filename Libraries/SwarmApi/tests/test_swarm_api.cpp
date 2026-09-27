#include <gtest/gtest.h>
#include "../inc/SwarmApi.h"
#include <vector>

TEST(SwarmApiTest, SingleSubscriberReceivesTelemetry) {
    SwarmApi api;

    bool callback_fired = false;
    DroneTelemetry received_packet{};

    // Subscribe lambda that captures local vars by ref
    api.subscribe([&](const DroneTelemetry& t) {
        callback_fired = true;
        received_packet = t;
    });

    // Publish dummy payload
    std::vector<DroneTelemetry> payload = {
        {42, 1000, 10.5f, 20.0f, -5.0f, 50.0f}
    };
    api.publish(payload);

    // Assert the callback actually fired, and that the data is intact
    EXPECT_TRUE(callback_fired) << "The callback wasn't executed";
    EXPECT_EQ(received_packet.drone_id, 42);
    EXPECT_EQ(received_packet.logical_tick, 1000);
    EXPECT_FLOAT_EQ(received_packet.pos_x, 10.5f);
    EXPECT_FLOAT_EQ(received_packet.pos_y, 20.0f);
    EXPECT_FLOAT_EQ(received_packet.pos_z, -5.0f);
    EXPECT_FLOAT_EQ(received_packet.velocity, 50.0f);
}

TEST(SwarmApiTest, MultipleSubscribersAndPackets) {
    SwarmApi api;

    int sub1_count{};
    int sub2_count{};

    api.subscribe([&](const auto&){ sub1_count++; });
    api.subscribe([&](const auto&) { sub2_count++; });

    // Publish a batch of 3 packets
    std::vector<DroneTelemetry> payload(3); 
    api.publish(payload);

    // Both subscribers should have been called exactly 3 times
    EXPECT_EQ(sub1_count, 3);
    EXPECT_EQ(sub2_count, 3);
}